m = Map("system", 
	translate("periodic_reboot"), 
	translate("Watchcat allows configuring a periodic reboot when the " ..
		  "Internet connection has been lost for a certain period of time."
		 ))

s = m:section(TypedSection, "watchcat")
s.anonymous = true
s.addremove = true

-- 定时重启模式
mode = s:option(Value, "mode",
		translate("Operating mode"),
		translate("Periodic Reboot: Reboot this device after a specified interval of time."))
mode.default = "periodic_reboot"
mode.rmempty = true

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

-- 强制重启延时
forcedelay = s:option(Value, "forcedelay",
		      translate("Forced reboot delay"),
		      translate("When rebooting the system, the watchcat will trigger a soft reboot. " ..
				"Entering a non zero value here will trigger a delayed hard reboot " ..
				"if the soft reboot fails. Enter a number of seconds to enable, " ..
				"use 0 to disable"))
forcedelay.datatype = "uinteger"
forcedelay.default = "0"

return m
