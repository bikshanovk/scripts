#!/usr/local/Cellar/lua/5.3.5_1/bin/lua
t = {}
table.insert(t,1)
table.insert(t,2)
table.insert(t,3)
t["four"] = 4
t["five"] = 5
t["six"] = 6
t[4] = 4

print("\n=== by keys")
for key,value in pairs(t) do
	print("key(" .. key .. ") value (" .. value ..")")
end

print("\n=== by index")
for index,value in pairs(t) do 
        print("index(" .. index .. ") value (" .. value ..")")
end

