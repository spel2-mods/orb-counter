meta = {
	name = "Orb Counter",
	version = "0.1",
	description = "Displays how many orbs are left",
	author = "fienestar",
	online_safe = true,
}

register_option_int("font_size", "font size", "", 86, 16, 256)

set_callback(function(save_ctx)
    local save_data_str = json.encode({
		["version"] = "0.1",
		["options"] = options
	})
    save_ctx:save(save_data_str)
end, ON.SAVE)

set_callback(function(load_ctx)
    local save_data_str = load_ctx:load()
    if save_data_str ~= "" then
        local save_data = json.decode(save_data_str)
		if save_data.options then
			options = save_data.options
			if options.font_size == nil then
				options.font_size = 86
			end
		end
    end
end, ON.LOAD)

local get_state = function()
	return state
end

-- for Playlunky Nightly
if get_local_state then
	get_state = get_local_state
end

set_callback(function(ctx)
	local state = get_state()
	
	if state.screen ~= SCREEN.LEVEL or state.level < 5 or state.pause ~= 0 then
		return
	end

	local orb_count = tostring(#get_entities_by(ENT_TYPE.ITEM_FLOATING_ORB, MASK.ITEM, LAYER.FRONT))

	width32, _ = draw_text_size(options.font_size, orb_count)
	ctx:draw_text(-width32/2, 1, options.font_size, orb_count, rgba(243, 137, 215, 75))
end, ON.GUIFRAME)
