#!/usr/local/Cellar/lua/5.3.5_1/bin/lua
t = {}
table.insert(t,1)
table.insert(t,2)
table.insert(t,3)
t["four"] = 4
t["five"] = 5
t["six"] = 6
t[10] = 10
t[11] = 11

print("\n=== by keys")
for key,value in pairs(t) do
	print("key(" .. key .. ") value (" .. value ..")")
end

print("\n=== by index")
for index,value in pairs(t) do 
        print("index(" .. index .. ") value (" .. value ..")")
end

print("\n=== by for loop")
for index=1, 10, 1 do
	if t[index] then
        	print("index(" .. index .. ") value (" .. t[index] ..")")
	end
end


