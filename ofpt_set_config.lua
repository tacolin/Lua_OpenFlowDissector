local Module = {}

local m = Module

m.flags_desc = {
    [0] = "OFPC_FRAG_NORMAL",
    [1] = "OFPC_FRAG_DROP",
    [2] = "OFPC_FRAG_REASM",
    [3] = "OFPC_FRAG_MASK",
}

function m.appendFields(fds)

end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs

    local set_cfg_tree = root_tree:add( buffer(start_ofs), "OFP Set Config")

    local flags = buffer( ofs, 2 )
    ofs = ofs + 2

    local miss_send_len = buffer( ofs, 2 )
    ofs = ofs + 2

    set_cfg_tree:add( flags, "flags:", m.flags_desc[flags:uint()], "("..flags:uint()..")" )
    set_cfg_tree:add( miss_send_len, "miss_send_len:", miss_send_len:uint() )
    
    set_cfg_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module