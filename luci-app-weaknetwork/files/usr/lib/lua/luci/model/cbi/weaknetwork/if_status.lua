require("luci.sys")
require("luci.sys.zoneinfo")
require("luci.tools.webadmin")
require("luci.fs")
require("luci.config")

for k, v in ipairs(luci.sys.net.devices()) do
    if v ~= "lo" then
        luci.sys.call("ifconfig " .. v)
    end
end


m = Map("weaknetwork", translate("网络接口配置信息"), translate(""))

return m
