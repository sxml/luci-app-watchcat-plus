module("luci.controller.watchcat-plus", package.seeall)

function index()
   if not nixio.fs.access("/etc/config/watchcat") then
      return
   end
   local page
   page = entry({"admin", "services", "watchcat-plus"}, alias("admin", "services", "watchcat-plus", "periodic_reboot"),
               _("Watchcat Plus"), 10)  -- 首页
   page.dependent = true
	page.acl_depends = { "luci-app-watchcat-plus" }
   
   entry({"admin", "services", "watchcat-plus", "periodic_reboot"}, cbi("watchcat-plus/periodic_reboot"), _("Periodic reboot"), 10).leaf = true -- "定时重启模式页面" 
   entry({"admin", "services", "watchcat-plus", "ping_reboot"}, cbi("watchcat-plus/ping_reboot"), _("Ping reboot"), 20).leaf = true -- "Ping重启模式页面" 
   entry({"admin", "services", "watchcat-plus", "restart_iface"}, cbi("watchcat-plus/restart_iface"), _("Restart interface"), 30).leaf = true -- "重启接口模式页面" 
   entry({"admin", "services", "watchcat-plus", "run_script"}, cbi("watchcat-plus/run_script"), _("Run Script"), 40).leaf = true -- "运行脚本模式界面" 
   entry({"admin", "services", "watchcat-plus", "log"}, form("watchcat-plus/log"), _("Log"), 50).leaf = true -- 日志页面
   entry({"admin", "services", "watchcat-plus", "logtail"}, call("action_logtail")).leaf = true -- 日志采集
end

function action_logtail()
	local fs = require "nixio.fs"
	local log_path = "/var/log/aliyundrive-webdav.log"
	local e = {}
	e.running = luci.sys.call("pidof aliyundrive-webdav >/dev/null") == 0
	if fs.access(log_path) then
		e.log = luci.sys.exec("tail -n 100 %s | sed 's/\\x1b\\[[0-9;]*m//g'" % log_path)
	else
		e.log = ""
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end