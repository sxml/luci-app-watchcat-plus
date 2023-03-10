module("luci.controller.watchcat", package.seeall)

function index()
   if not nixio.fs.access("/etc/config/watchcat") then
      return
   end
   page = entry({"admin", "services", "watchcat"}, alias("admin", "services", "watchcat", "periodic_reboot"),
    _("Watchcat Plus"), 10)  -- 首页
   page.dependent = true
	page.acl_depends = { "luci-app-watchcat-plus" }
   entry({"admin", "services", "watchcat", "periodic_reboot"}, cbi("watchcat/periodic_reboot"), _("Periodic reboot"), 10).leaf = true -- "定时重启模式页面" 
   entry({"admin", "services", "watchcat", "ping_reboot"}, cbi("watchcat/ping_reboot"), _("Ping reboot"), 20).leaf = true -- "Ping重启模式页面" 
   entry({"admin", "services", "watchcat", "restart_iface"}, cbi("watchcat/restart_iface"), _("Restart interface"), 30).leaf = true -- "重启接口模式页面" 
   entry({"admin", "services", "watchcat", "run_script"}, cbi("watchcat/run_script"), _("Run Script"), 40).leaf = true -- "运行脚本模式界面" 
   entry({"admin", "services", "watchcat", "log"}, form("watchcat/log"), _("Log"), 50).leaf = true -- 日志页面

end

function action_logtail()
	local e = {}
	e.log = luci.sys.exec("logread | grep watchcat")
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end