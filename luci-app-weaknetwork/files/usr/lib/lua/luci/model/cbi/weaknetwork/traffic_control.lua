require("luci.sys")
require("luci.sys.zoneinfo")
require("luci.tools.webadmin")
require("luci.fs")
require("luci.config")

local m, s, o

--[
--m = Map("配置文件文件名", "配置页面标题", "配置页面说明")
--选择后保存在"/etc/config/weaknetwork"
--]
local state_msg=translate("Netem 是 Linux 2.6 及以上内核版本提供的一个网络模拟功能模块。该功能模块可以用来在性能良好的局域网中，模拟出复杂的互联网传输性能，诸如低带宽、传输延迟、丢包等情况。").."<br/>"..translate("Netem模拟流量控制只能控制发包动作,不能控制收包动作,同时,它直接对物理接口生效,如果控制了物理的 eth0,那么逻辑网卡(比如 eth0:1)也会受到影响,反之,如果您在逻辑网卡上做控制,该控制可能是无效的。")
m = Map("weaknetwork", translate("Netem模拟流量控制"), translate(state_msg))
-- m:chain("luci")


--[ s = m:section(TypedSection, "if_status", translate("使用说明"))
--s.anonymous = true
--s.addremove = false
--]

s = m:section(TypedSection, "controlboard", translate("控制面板"))

-- 不显示Section的名称,不允许增加或删除Section
s.anonymous = true
s.addremove = true


s:tab("if", translate("作用接口"))
s:tab("loss", translate("模拟丢包"))
s:tab("delay", translate("模拟延迟"))
s:tab("duplicate", translate("模拟包重复"))
s:tab("corrupt", translate("模拟包损坏"))
s:tab("reorder", translate("模拟数据包乱序（Linux kernel >= 2.6.16）"))

o = s:taboption("if", Flag, "enable", translate("开启模拟流量限制(选中开启)"))

ifname = s:taboption("if", MultiValue, "interface", translate("作用接口"))
for k, v in ipairs(luci.sys.net.devices()) do
    if v ~= "lo" then
        ifname:value(v)
    end
end


-- --------------------------------------------
-- 丢包
-- Value(文本框)、ListValue(下拉框)、Flag(选择框)
--
o = s:taboption("loss", ListValue, "loss", translate("丢包率"))
o.default = '0%'
o:value('0%', translate("不丢包"))
o:value('5%', translate("5%"))
o:value('10%', translate("10%"))
o:value('15%', translate("15%"))
o:value('20%', translate("20%"))
o:value('25%', translate("25%"))
o:value('30%', translate("30%"))
o:value('35%', translate("35%"))
o:value('40%', translate("40%"))
o:value('45%', translate("45%"))
o:value('50%', translate("50%"))
o:value('55%', translate("55%"))
o:value('60%', translate("60%"))
o:value('65%', translate("65%"))
o:value('70%', translate("70%"))
o:value('75%', translate("75%"))
o:value('80%', translate("80%"))
o:value('85%', translate("85%"))
o:value('90%', translate("90%"))
o:value('95%', translate("95%"))
o:value('100%', translate("100%"))

--a = s:taboption("loss", Flag, "loss_input", translate("其他值"))
--a.enable = '0'
--a.disable = '1'

-- o = s:taboption("loss", Value, "loss_input", translate("丢包率"))
-- o.default = '0%'


o = s:taboption("loss", ListValue, "loss_s_rate", translate("丢包成功率"))
o.default = '0%'
o:value('0%', translate("0%"))
o:value('5%', translate("5%"))
o:value('10%', translate("10%"))
o:value('15%', translate("15%"))
o:value('20%', translate("20%"))
o:value('25%', translate("25%"))
o:value('30%', translate("30%"))
o:value('35%', translate("35%"))
o:value('40%', translate("40%"))
o:value('45%', translate("45%"))
o:value('50%', translate("50%"))
o:value('55%', translate("55%"))
o:value('60%', translate("60%"))
o:value('65%', translate("65%"))
o:value('70%', translate("70%"))
o:value('75%', translate("75%"))
o:value('80%', translate("80%"))
o:value('85%', translate("85%"))
o:value('90%', translate("90%"))
o:value('95%', translate("95%"))
o:value('100%', translate("100%"))

-- o = s:taboption("loss", Value, "loss_s_rate_input", translate("丢包成功率"))
-- o.default = '0%'


-- --------------------------------------------
-- 延迟
--
o = s:taboption("delay", Value, "delay", translate("延迟(ms)"))
o.datatype = "uinteger"
o.default = '0'

o = s:taboption("delay", Value, "float", translate("延迟波动值(ms)"))
o.datatype = "uinteger"
o.default = '0'

o = s:taboption("delay", ListValue, "delay_rate", translate("波动率"))
o.default = '0%'
o:value('0%', translate("0%"))
o:value('5%', translate("5%"))
o:value('10%', translate("10%"))
o:value('15%', translate("15%"))
o:value('20%', translate("20%"))
o:value('25%', translate("25%"))
o:value('30%', translate("30%"))
o:value('35%', translate("35%"))
o:value('40%', translate("40%"))
o:value('45%', translate("45%"))
o:value('50%', translate("50%"))
o:value('55%', translate("55%"))
o:value('60%', translate("60%"))
o:value('65%', translate("65%"))
o:value('70%', translate("70%"))
o:value('75%', translate("75%"))
o:value('80%', translate("80%"))
o:value('85%', translate("85%"))
o:value('90%', translate("90%"))
o:value('95%', translate("95%"))
o:value('100%', translate("100%"))

-- o = s:taboption("delay", Value, "delay_rate_input", translate("波动率"))
-- o.default = '0%'

--
-- 包重复
--
-- o = s:taboption("duplicate", ListValue, "duplicate", translate("数据包重复率"))
-- o.default = '0%'
-- o:value('0%', translate("0%"))
-- o:value('5%', translate("5%"))
-- o:value('10%', translate("10%"))
-- o:value('15%', translate("15%"))
-- o:value('20%', translate("20%"))
-- o:value('25%', translate("25%"))
-- o:value('30%', translate("30%"))
-- o:value('35%', translate("35%"))
-- o:value('40%', translate("40%"))
-- o:value('45%', translate("45%"))
-- o:value('50%', translate("50%"))
-- o:value('55%', translate("55%"))
-- o:value('60%', translate("60%"))
-- o:value('65%', translate("65%"))
-- o:value('70%', translate("70%"))
-- o:value('75%', translate("75%"))
-- o:value('80%', translate("80%"))
-- o:value('85%', translate("85%"))
-- o:value('90%', translate("90%"))
-- o:value('95%', translate("95%"))
-- o:value('100%', translate("100%"))

o = s:taboption("duplicate", Value, "duplicate_input", translate("数据包重复率(百分比)%"))
o.datatype = "ufloat"
o.default = '0'

--
-- 包损坏
--
-- o = s:taboption("corrupt", ListValue, "corrupt", translate("数据包损坏率(较小值)"))
-- o.default = '0%'
-- o:value('0%', translate("0%"))
-- o:value('5%', translate("5%"))
-- o:value('10%', translate("10%"))
-- o:value('15%', translate("15%"))
-- o:value('20%', translate("20%"))
-- o:value('25%', translate("25%"))
-- oo:value('30%', translate("30%"))
-- oo:value('35%', translate("35%"))
-- oo:value('40%', translate("40%"))
-- oo:value('45%', translate("45%"))
-- oo:value('50%', translate("50%"))
-- oo:value('55%', translate("55%"))
-- oo:value('60%', translate("60%"))
-- oo:value('65%', translate("65%"))
-- oo:value('70%', translate("70%"))
-- oo:value('75%', translate("75%"))
-- oo:value('80%', translate("80%"))
-- oo:value('85%', translate("85%"))
-- oo:value('90%', translate("90%"))
-- oo:value('95%', translate("95%"))
-- oo:value('100%', translate("100%"))

o = s:taboption("corrupt", Value, "corrupt_input", translate("数据包损坏率(百分比，较小值)%"))
o.datatype = "ufloat"
o.default = '0'

--
-- 包乱序
--
o = s:taboption("reorder", ListValue, "reorder", translate("数据包乱序率"))
o.default = '0%'
o:value('0%', translate("0%"))
o:value('5%', translate("5%"))
o:value('10%', translate("10%"))
o:value('15%', translate("15%"))
o:value('20%', translate("20%"))
o:value('25%', translate("25%"))
o:value('30%', translate("30%"))
o:value('35%', translate("35%"))
o:value('40%', translate("40%"))
o:value('45%', translate("45%"))
o:value('50%', translate("50%"))
o:value('55%', translate("55%"))
o:value('60%', translate("60%"))
o:value('65%', translate("65%"))
o:value('70%', translate("70%"))
o:value('75%', translate("75%"))
o:value('80%', translate("80%"))
o:value('85%', translate("85%"))
o:value('90%', translate("90%"))
o:value('95%', translate("95%"))
o:value('100%', translate("100%"))

-- o = s:taboption("reorder", Value, "reorder_input", translate("数据包乱序率"))
-- o.default = '0%'

o = s:taboption("reorder", ListValue, "relative", translate("乱序相关度"))
o.default = '0%'
o:value('0%', translate("0%"))
o:value('5%', translate("5%"))
o:value('10%', translate("10%"))
o:value('15%', translate("15%"))
o:value('20%', translate("20%"))
o:value('25%', translate("25%"))
o:value('30%', translate("30%"))
o:value('35%', translate("35%"))
o:value('40%', translate("40%"))
o:value('45%', translate("45%"))
o:value('50%', translate("50%"))
o:value('55%', translate("55%"))
o:value('60%', translate("60%"))
o:value('65%', translate("65%"))
o:value('70%', translate("70%"))
o:value('75%', translate("75%"))
o:value('80%', translate("80%"))
o:value('85%', translate("85%"))
o:value('90%', translate("90%"))
o:value('95%', translate("95%"))
o:value('100%', translate("100%"))

-- o = s:taboption("reorder", Value, "relative_input", translate("乱序相关度"))
-- o.default = '0%'


--[ local apply = luci.http.formvalue("cbi.apply")
--if apply then
--    io.popen("/etc/init.d/weaknetem restart")
--end
--]

return m
