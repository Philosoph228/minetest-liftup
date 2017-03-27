--[[

liftup mod

Copyright (c) 2017 Philosoph228 <philosoph228@gmail.com>
Source Code: https://github.com/Philosoph228/minetest-liftup
License: MIT

]]--


minetest.register_node("liftup:liftup_block", {
	description = "Lift Up block",
	tiles = {
		"liftup_vertical_side.png",
		"liftup_vertical_side.png",
		"liftup_side.png"
	},
	groups = {cracky=2},
	sounds = default.node_sound_defaults(),
	
	on_rightclick = function(pos, node, clicker, itemstack)
		-- Prevent server crash
		if clicker == nil then
			return false
		end
		
		local x = pos.x
		local y = math.max(-30927, pos.y)
		local z = pos.z
		
		local free = 0
		local concrete = 0
		local limit = 100
		
		-- Search for non-air block
		while free <= limit do
			y = y+1
			
			local upper_node = minetest.get_node({x=x, y=y, z=z})
			
			if upper_node.name == "ignore" then
				minetest.get_voxel_manip():read_from_map({x=x, y=y, z=z}, {x=x, y=y, z=z})
				upper_node = minetest.get_node({x=x, y=y, z=z})
			end
			
			if upper_node.name ~= "air" then
				free = 0
				break
			else
				free = free+1
			end
		end
		
		if free > limit then
			return
		end	
		
		while y < 30926 do
			y = y+1
			
			local upper_node = minetest.get_node({x=x, y=y, z=z})
			
			if upper_node.name == "ignore" then
				minetest.get_voxel_manip():read_from_map({x=x, y=y, z=z}, {x=x, y=y, z=z})
				upper_node = minetest.get_node({x=x, y=y, z=z})
			end
			
			if upper_node.name ~= "air" then
				free = 0
				concrete = concrete+1
			else
				free = free+1
				if free == 2 then
					local stand_on = minetest.get_node({x=x, y=y-2, z=z})					
					if minetest.registered_nodes[stand_on.name].damage_per_second ~= 0 then
						minetest.chat_send_player(clicker:get_player_name(), "It's unsafe to lift up here because "..stand_on.name..".")
					else
						clicker:setpos({x=x, y=y-1.5, z=z})
					end
					return
				end
			end
		end
	end,
})

minetest.register_craft({
	output = 'liftup:liftup_block',
	recipe = {
		{'default:cobble', 'default:cobble', 'default:cobble'},
		{'default:gold_ingot', 'group:diamond', 'default:gold_ingot'},
		{'default:cobble', 'default:cobble', 'default:cobble'},
	}
})