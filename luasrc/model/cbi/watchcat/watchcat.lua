m = Map("system", 
	translate("Watchcat"), 
	translate("Watchcat allows configuring a periodic reboot when the " ..
		  "Internet connection has been lost for a certain period of time."
		 ))

s = m:section(TypedSection, "watchcat")
s.anonymous = true
s.addremove = true

-- 四种模式
mode = s:option(ListValue, "mode",
		translate("Operating mode"),
		translate("Ping Reboot: Reboot this device if a ping to a specified host fails for a specified duration of time. "..
				"Periodic Reboot: Reboot this device after a specified interval of time. "..
				"Restart Interface: Restart a network interface if a ping to a specified host fails for a specified duration of time."..
				"Run Script: Run a script if a ping to a specified host fails for a specified duration of time."))
mode:value("ping_reboot", "Ping Reboot")
mode:value("periodic_reboot", "Periodic reboot")
mode:value("restart_iface", "Restart Interface")
mode:value("run_script", "Run Script")
mode.widget = "radio"

-- 运行脚本
script = s:option(Value, "script", translate("Script to run"))
script.datatype = "file"
script.default = "/etc/watchcat.user.sh"
script.description = translate("Script to run when the host has not responded for the specified duration of time. The script is passed the interface name as $1`")
script:depends("mode","run_script");

-- 周期
period = s:option(Value, "period", 
		  translate("Period"),
		  translate("In periodic mode, it defines the reboot period. " ..
			    "In internet mode, it defines the longest period of " .. 
			    "time without internet access before a reboot is engaged." ..
			    "Default unit is seconds, you can use the " ..
			    "suffix 'm' for minutes, 'h' for hours or 'd' " ..
			    "for days"))
period.default = '6h'

-- ping 主机
pinghosts = s:option(Value, "pinghosts", 
translate("Ping host"),
translate("Host address to ping"))
pinghosts.datatype = "host(1)"
pinghosts.default = "8.8.8.8"
pinghosts:depends({mode="ping_reboot"})
pinghosts:depends({mode="restart_iface"})
pinghosts:depends({mode="run_script"})


-- ping 地址簇
addressfamily = s:option(ListValue, 'addressfamily',
				 translate('Address family for pinging the host'))
addressfamily:value("any", "any");
addressfamily:value("ipv4", "ipv4");
addressfamily:value("ipv6", "ipv6");
addressfamily.default = "any";
addressfamily:depends({ mode="ping_reboot" });
addressfamily:depends({ mode="restart_iface" });
addressfamily:depends({ mode="run_script" });

-- ping周期
pingperiod = s:option(Value, "pingperiod", 
		      translate("Ping period"),
		      translate("How often to check internet connection. " ..
				"Default unit is seconds, you can you use the " ..
				"suffix 's' for seconds, suffix 'm' for minutes, 'h' for hours or 'd' " ..
				"for days"))
pingperiod.default = "30s"
pingperiod:depends({ mode="ping_reboot" });
pingperiod:depends({ mode="restart_iface" });
pingperiod:depends({ mode="run_script" });

-- ping 包大小
pingsize = s:option(ListValue, 'pingsize', translate('Ping Packet Size'));
pingsize:value('small', translate('Small: 1 byte'));
pingsize:value('windows', translate('Windows: 32 bytes'));
pingsize:value('standard', translate('Standard: 56 bytes'));
pingsize:value('big', translate('Big: 248 bytes'));
pingsize:value('huge', translate('Huge: 1492 bytes'));
pingsize:value('jumbo', translate('Jumbo: 9000 bytes'));
pingsize.default = 'standard';
pingsize:depends({ mode="ping_reboot" });
pingsize:depends({ mode="restart_iface" });
pingsize:depends({ mode="run_script" });

-- 强制重启延时
forcedelay = s:option(Value, "forcedelay",
		      translate("Forced reboot delay"),
		      translate("When rebooting the system, the watchcat will trigger a soft reboot. " ..
				"Entering a non zero value here will trigger a delayed hard reboot " ..
				"if the soft reboot fails. Enter a number of seconds to enable, " ..
				"use 0 to disable"))
forcedelay.datatype = "uinteger"
forcedelay.default = "0"
forcedelay:depends({mode="ping_reboot"});
forcedelay:depends({mode="periodic_reboot"});

-- 接口
interface = s:option(Value, "interface",
				translate('Interface'),
				translate('Applies to Ping Reboot, Restart Interface, and Run Script modes Specify the interface to monitor and react if a ping over it fails.'));
device_table = luci.sys.net.devices();
if table then
	for k, v in ipairs(device_table) do
		if v ~= "lo" then
			interface:value(k, v)
		end
	end 
end
interface:depends({ mode= "ping_reboot" });
interface:depends({ mode= "restart_iface" });
interface:depends({ mode= "run_script" });

return m
