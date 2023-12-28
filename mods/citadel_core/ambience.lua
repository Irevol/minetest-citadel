local player_state = {}

minetest.register_on_leaveplayer(function(player)
	player_state[player:get_player_name()] = nil
end)

local function musiccheck(player)
	local pname = player:get_player_name()

	-- Start playing all 3 songs in loop immediately, and
	-- we'll change songs by cross-fading them.
	local state = player_state[pname]
	if not state then
		state = {}
		for i, v in ipairs(citadel.sounds) do
			state[i] =  {
				id = minetest.sound_play(v.file, {
					to_player = pname,
					gain = 0.001,
					loop = true,
				}),
				gain = 0.001
			}
		end
		player_state[pname] = state
	end

	-- Figure out what song should be playing, and at what relative
	-- volume, by searching for nearby ghosts.  Doing this statelessly
	-- instead of requiring ghosts or other scripts to tell us what
	-- to change the song to makes this more robust in the event of
	-- unexpected modes of transition.
	local ppos = player:get_pos()
	local song = 1
	local gain = 1
	for _, ent in pairs(minetest.luaentities) do
		if ent.name == cc.."ghost" then
			if ent._images[1] == 50 then
				song = 3
				if ent._audio_duck_time then gain = 1/5 end
			else
				local pos = ent.object:get_pos()
				if pos and vector.distance(pos, ppos) < 5 then
					song = 2
					if ent._audio_duck_time then gain = 1/5 end
					break
				end
			end
		end
	end

	-- Mute all songs other than the target one.  Change the target
	-- song to the desired gain.
	local function fadeto(stateobj, rate, target)
		if stateobj.gain == target then return end
		minetest.sound_fade(stateobj.id, rate, target)
		stateobj.gain = target
	end
	for i, v in pairs(state) do
		if song ~= i then
			fadeto(v, 0.2, 0.001)
		elseif gain == 1 then
			fadeto(v, 0.2, citadel.sounds[i].gain)
		else
			fadeto(v, 2, citadel.sounds[i].gain * gain)
		end
	end
end

minetest.register_globalstep(function()
	for _, player in pairs(minetest.get_connected_players()) do
		musiccheck(player)
	end
end)