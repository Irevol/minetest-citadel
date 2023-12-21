
minetest.register_entity(cc.."ghost", {
	initial_properties = {
		visual = "mesh",
		mesh = "character.b3d",
		visual_size = { x=1, y=1, z=1 },
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		textures = {"ghost.png"},
		physical = false,
		glow = 10,
		use_texture_alpha = true,
		backface_culling = false,
		damage_texture_modifier = "",
		hp_max = 100000,
	},
	_anim_timer = 0,
	_images= {},
	_image_index = 1,
	_factor = 1,
	_by_player = false,
	on_rightclick = function(self, clicker)
		if self._image_index > #self._images then
			self._image_index = 1
		end
		
		citadel.hud("text_overlay.png^dia"..self._images[self._image_index]..".png^[colorize:#ffffff:200", 5, 2, 0.35)

		--endgame stuff
		if self._images[self._image_index] == 50 then
			minetest.after(4, function(self) 
				self._factor = 0
				self.object:set_velocity({x=0,y=10,z=0}) 
			end, self)
			minetest.after(5, function(self) self.object:remove() end, self)
			minetest.after(7, function() citadel.hud("white_hud.png") end)
			minetest.after(8, function()
				local player = minetest.get_player_by_name("singleplayer")
				player:set_pos(minetest.deserialize(data:get_string("endpos")))
				citadel.set_ambience(1)
			end)
		end
		
		self._image_index = self._image_index + 1
	end,
	on_activate = function(self, staticdata, dtime_s)
	    self.object:set_texture_mod("^[opacity:100")
		self.object:set_velocity({x=0,y=0.1,z=0})
		self._images = minetest.deserialize(staticdata)
		self.object:set_armor_groups({immortal = 1})
	end,
	on_step = function(self, dtime_s)
		
		self._anim_timer = self._anim_timer + dtime_s*self._factor
		if self._anim_timer > 2 then
			self.object:set_velocity({x=0,y=0-self.object:get_velocity().y,z=0})
			self._anim_timer = 0
		end

		local objects = minetest.get_objects_inside_radius(self.object:get_pos(), 5)
		local by_player = false
		for o=1, #objects do
			local obj = objects[o]
			if obj and obj:is_player() then
				by_player = true
				local dir = vector.direction(self.object:get_pos(),obj:get_pos())
				local yaw = minetest.dir_to_yaw(dir)
				if yaw then
					self.object:set_yaw(yaw)
					break
				end
			end
		end
		if data:get_string("ended") == "" then
			if by_player and not self._by_player then
				self._by_player = true
				citadel.set_ambience(2)
			elseif not by_player and self._by_player then
				self._by_player = false
				citadel.set_ambience(1)
			end
		end
	end,
})

