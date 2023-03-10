m = Map("watchcat", 
	translate("Restart Interface"), 
	translate("Watchcat allows configuring a periodic reboot when the " ..
		  "Internet connection has been lost for a certain period of time."
		 ))

s = m:section(TypedSection, "watchcat")
s.anonymous = true
s.addremove = true

-- 是否启用
enable = e:option(Flag, "enabled", translate("Enabled"))
enable.rmempty = false

-- 重启接口模式
mode = s:option(Value, "mode",
		translate("Operating mode"),
		translate("Restart Interface: Restart a network interface if a ping to a specified host fails for a specified duration of time."))
mode.default = "restart_iface"

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

-- ping 地址簇
addressfamily = s:option(ListValue, 'addressfamily',
				 translate('Address family for pinging the host'))
addressfamily:value("any", "any");
addressfamily:value("ipv4", "ipv4");
addressfamily:value("ipv6", "ipv6");
addressfamily.default = "any";

-- ping周期
pingperiod = s:option(Value, "pingperiod", 
		      translate("Ping period"),
		      translate("How often to check internet connection. " ..
				"Default unit is seconds, you can you use the " ..
				"suffix 's' for seconds, suffix 'm' for minutes, 'h' for hours or 'd' " ..
				"for days"))
pingperiod.default = "30s"

-- ping 包大小
pingsize = s:option(ListValue, 'pingsize', translate('Ping Packet Size'));
pingsize:value('small', translate('Small: 1 byte'));
pingsize:value('windows', translate('Windows: 32 bytes'));
pingsize:value('standard', translate('Standard: 56 bytes'));
pingsize:value('big', translate('Big: 248 bytes'));
pingsize:value('huge', translate('Huge: 1492 bytes'));
pingsize:value('jumbo', translate('Jumbo: 9000 bytes'));
pingsize.default = 'standard';

-- 接口
interface = s:option(Value, "interface",
				translate('Interface'),
				translate('Applies to Ping Reboot, Restart Interface, and Run Script modes Specify the interface to monitor and react if a ping over it fails.'));
device_table = luci.sys.net.devices();
if table then
	for k, v in ipairs(device_table) do
		if v ~= "lo" then
			interface:value(v, v)
		end
	end 
end

return m
