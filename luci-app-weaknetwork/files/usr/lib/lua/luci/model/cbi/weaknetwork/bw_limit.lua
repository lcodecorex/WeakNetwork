require("luci.sys")
require("luci.sys.zoneinfo")
require("luci.tools.webadmin")
require("luci.fs")
require("luci.config")

-- TODO 创建SimpleForm

local state_msg = "<b><font color=\"red\">" .. translate("TC需要内核支持CBQ队列，若设置无效，可能是当前的内核不支持。") .. "</font></b><br/>"..translate("配置和使用流量控制器TC（Traffic Control），主要分以下几个方面。分别为建立队列、建立分类、建立过滤器 和 建立路由，另外还需要对现有的队列、分类、过滤器和路由进行监视。 其使用步骤为：").."<br/>"..translate("1.针对网络物理设备(如以太网卡eth0)绑定一个CBQ(Class Based Queue)队列").."<br/>"..translate("2.在该队列上建立分类").."<br/>"..translate("3.为每一分类建立一个基于路由的过滤器").."<br/>"..translate("4.与过滤器相配合，建立特定的路由表")
m = Map("weaknetwork", translate("tc qdisc带宽限制"), translate(state_msg))
m:chain("luci")

s = m:section(TypedSection, "bw_cbq", translate("1. 建立队列"), translate("对网络物理设备(如以太网卡eth0)绑定一个CBQ(Class Based Queue)队列"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enable", translate("开启带宽流量限制"))

ifname = s:option(MultiValue, "ifnet", translate("绑定网卡(接口)"))
for k, v in ipairs(luci.sys.net.devices()) do
    if v ~= "lo" then
        ifname:value(v)
    end
end

o = s:option(Value, "bw", translate("流量带宽(Mbit)"))
o.datatype = "ufloat"
o.default = '10'

o = s:option(Value, "avpkt", translate("包平均大小(字节)"))
o.datatype = "uinteger"
o.default = '1000'

o = s:option(Value, "cell", translate("包间隔发送单元大小(字节)"))
o.datatype = "uinteger"
o.default = '8'

o = s:option(Value, "mpu", translate("最小传输包大小(字节)"))
o.datatype = "uinteger"
o.default = '64'

-- ----------------------------
s = m:section(TypedSection, "class_root", translate("2. 创建根分类"), translate("一般情况下，针对一个队列需建立一个根分类，然后再在其上建立子分类。对于分类，按其分类的编号顺序起作用，编号小的优先；一旦符合某个分类匹配规则，通过该分类发送数据包，则其后的分类不再起作用。"))
s.anonymous = true
s.addremove = false

o = s:option(Value, "bw", translate("最大可用带宽(Mbit)"))
o.datatype = "ufloat"
o.default = '10'

o = s:option(Value, "rate", translate("实际分配的带宽(Mbit)"))
o.datatype = "ufloat"
o.default = '10'

o = s:option(Value, "maxburst", translate("可接收冲突的发送最长包数目(字节)"))
o.datatype = "uinteger"
o.default = '20'

o = s:option(Value, "allot", translate("最大传输单元加MAC头的大小(字节)"))
o.datatype = "uinteger"
o.default = '1514'

o = s:option(Value, "prio", translate("优先级"))
o.datatype = "uinteger"
o.default = '8'

o = s:option(Value, "avpkt", translate("包平均大小(字节)"))
o.datatype = "uinteger"
o.default = '1000'

o = s:option(Value, "cell", translate("包间隔发送单元大小(字节)"))
o.datatype = "uinteger"
o.default = '8'

o = s:option(Value, "weight", translate("相应于实际带宽的加权速率(Mbit)"))
o.datatype = "ufloat"
o.default = '1'

-- o = s:option(Value, "protocol", translate("过滤器协议(默认优先级别100，过滤器为基于路由表)"))
-- o.default = 'ip'


-- --------------------------------
s = m:section(TypedSection, "class_child", translate("3. 创建子分类"))
s.anonymous = true
s.addremove = true

o = s:option(Value, "bw", translate("最大可用带宽(Mbit)"))
o.datatype = "ufloat"
o.default = '10'

o = s:option(Value, "rate", translate("实际分配的带宽(Mbit)"))
o.datatype = "ufloat"
o.default = '8'

o = s:option(Value, "maxburst", translate("可接收冲突的发送最长包数目(字节)"))
o.datatype = "uinteger"
o.default = '20'

o = s:option(Value, "allot", translate("最大传输单元加MAC头的大小(字节)"))
o.datatype = "uinteger"
o.default = '1514'

o = s:option(Value, "prio", translate("优先级"))
o.datatype = "uinteger"
o.default = '1'

o = s:option(Value, "avpkt", translate("包平均大小(字节)"))
o.datatype = "uinteger"
o.default = '1000'

o = s:option(Value, "cell", translate("包间隔发送单元大小(字节)"))
o.datatype = "uinteger"
o.default = '8'

o = s:option(Value, "weight", translate("相应于实际带宽的加权速率(Kbit)"))
o.datatype = "uinteger"
o.default = '800'

o = s:option(Value, "split", translate("分类的分离点"))
o.default = '1:0'

o = s:option(Flag, "bounded", translate("不可借用未使用带宽"))
o.enable ='1'
o.disable = '0'
o.default = '0'

-- o = s:option(Value, "protocol", translate("过滤器协议"))
-- o.default = 'ip'

o = s:option(Value, "route_id", translate("路由映射分类序号(不可重复)"))
o.datatype = "uinteger"
o.default = '1'


-- --------------------------------
s = m:section(TypedSection, "route", translate("4. 建立路由"), translate("该路由是与前面所建立的路由映射一一对应"))
s.anonymous = true
s.addremove = true

o = s:option(Value, "ip_addr", translate("限速主机的ip地址"))

o = s:option(Value, "if_addr", translate("接口的ip地址"))
o.default = '192.168.1.1'

o = s:option(Value, "route_id", translate("映射序号(发往主机的数据包通过该分类转发)"))
o.datatype = "uinteger"




local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/weaknettc restart")
end

return m
