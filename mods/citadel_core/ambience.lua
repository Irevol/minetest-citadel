
--minetest.sound_play(spec, parameters, [ephemeral])
--minetest.sound_fade(handle, step, gain)
function citadel.set_ambience(id)
	if data:get_string("ambience_handle") ~= "" then
		minetest.sound_fade(data:get_string("ambience_handle"), 0.2, 0)
	end
	local handle = minetest.sound_play(citadel.sounds[id].file, {to_player = "singleplayer", gain = citadel.sounds[id].gain, fade = 0.2, pitch = 1.0, loop=true}, false)
	data:set_int("ambience_handle", handle)
end

minetest.register_on_joinplayer(function(ObjectRef, last_login)
	citadel.set_ambience(1)
end)