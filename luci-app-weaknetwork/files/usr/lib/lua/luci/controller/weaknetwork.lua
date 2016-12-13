module("luci.controller.weaknetwork",package.seeall)

function index()
    entry({"admin", "weaknetwork"}, alias("admin", "weaknetwork", "traffic_control"), _("弱网配置"), 30).index = true

    entry({"admin", "weaknetwork", "traffic_control"}, cbi("weaknetwork/traffic_control"), _("流量控制"), 1)

    entry({"admin", "weaknetwork", "bw_limit"}, cbi("weaknetwork/bw_limit"), _("带宽限制"), 2)

    entry({"admin", "weaknetwork", "if_status"}, cbi("weaknetwork/if_status"), _("接口状态"), 3)
end
