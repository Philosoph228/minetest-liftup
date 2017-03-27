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
		local orig_y = pos.y
		local z = pos.z
		
		local free = 0
		local free_above = false
		
		while y <= 30926 do
			y = y+1
			local upper_node = minetest.get_node({x=x, y=y, z=z})
			
			if upper_node.name == "ignore" then
				minetest.get_voxel_manip():read_from_map({x=x, y=y, z=z}, {x=x, y=y, z=z})
				upper_node = minetest.get_node(pos)
			end
			
			if upper_node.name == "air" then
				if y == orig_y+2 then
					free_above = true;
				end
				
				if free_above == false then
					free = free+1;
				end
			else
				free = 0
				free_above = false
			end
			
			if free == 2 then
				if free_above == false then
					if y-2 ~= orig_y then
						clicker:setpos({x=x, y=y-1.5, z=z})
					end
				end
				return
			end
		end	
	end,
})

minetest.register_craft({
	output = 'liftup:liftup_block',
	recipe = {
		{'default:diamond', 'default:diamond', 'default:diamond'},
		{'default:diamond', 'group:stick', 'default:diamond'},
		{'default:diamond', 'default:diamond', 'default:diamond'},
	}
})