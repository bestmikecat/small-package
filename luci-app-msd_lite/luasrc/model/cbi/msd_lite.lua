require ("nixio.fs")
require ("luci.sys")
require ("luci.http")
require ("luci.dispatcher")
require "luci.model.uci".cursor()

m = Map("msd_lite")
m.title = translate("Multi Stream daemon Lite")
m.description = translate("The lightweight version of Multi Stream daemon (msd) Program for organizing IP TV streaming on the network via HTTP.")

m:section(SimpleSection).template  = "msd_lite/msd_lite_status"

s = m:section(TypedSection, "instance")
s.addremove = true
s.anonymous = false
s.addbtntitle = translate("Add instance")

o = s:option(Flag, "enabled", translate("Enable"))
o.default = o.disabled
o.rmempty = false

o = s:option(DynamicList, "address", translate("Bind address"))
o.datatype = "list(ipaddrport(1))"
o.rmempty = false

o = s:option(ListValue, "interface", translate("Source interface"))
local interfaces = luci.sys.exec("ls -l /sys/class/net/ 2>/dev/null |awk '{print $9}' 2>/dev/null")
for interface in string.gmatch(interfaces, "%S+") do
   o:value(interface)
end
o:value("", translate("Disable"))
o.default = ""
o.description = translate("For multicast receive.")

o = s:option(Value, "threads", translate("Worker threads"))
o.datatype = "uinteger"
o.default = "0"
o.description = translate("0 = auto.")

o = s:option(Flag, "bind_to_cpu", translate("Bind threads to CPUs"))
o.default = o.disabled

o = s:option(Flag, "drop_slow_clients", translate("Disconnect slow clients"))
o.default = o.disabled

o = s:option(Value, "precache_size", translate("Pre cache size"))
o.datatype = "uinteger"
o.default = "4096"

o = s:option(Value, "ring_buffer_size", translate("Ring buffer size"))
o.datatype = "uinteger"
o.default = "1024"
o.description = translate("Stream receive ring buffer size.")

o = s:option(Value, "multicast_recv_buffer_size", translate("Receive buffer size"))
o.datatype = "uinteger"
o.default = "512"
o.description = translate("Multicast receive socket buffer size.")

o = s:option(Value, "multicast_recv_timeout", translate("Receive timeout"))
o.datatype = "uinteger"
o.default = "2"
o.description = translate("Multicast receive timeout.")

return m