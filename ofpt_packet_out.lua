local Module = {}

local m = Module

m.buffer_id_desc = {
    [0xffffffff] = "OFP_NO_BUFFER",
}

m.in_port_desc = {
    [0xffffff00] = "OFPP_MAX",
    [0xfffffff8] = "OFPP_IN_PORT",
    [0xfffffff9] = "OFPP_TABLE",
    [0xfffffffa] = "OFPP_NORMAL",
    [0xfffffffb] = "OFPP_FLOOD",
    [0xfffffffc] = "OFPP_ALL",
    [0xfffffffd] = "OFPP_CONTROLLER",
    [0xfffffffe] = "OFPP_LOCAL",
    [0xffffffff] = "OFPP_ANY",
}

m.action_type_desc = {
    [0]= "OFPAT_OUTPUT",
    [1]= "OFPAT_SET_VLAN_VID",
    [2]= "OFPAT_SET_VLAN_PCP",
    [3]= "OFPAT_STRIP_VLAN",
    [4]= "OFPAT_SET_DL_SRC",
    [5]= "OFPAT_SET_DL_DST",
    [6]= "OFPAT_SET_NW_SRC",
    [7]= "OFPAT_SET_NW_DST",
    [8]= "OFPAT_SET_TP_SRC",
    [9]= "OFPAT_SET_TP_DST",
    [0xffff] = "OFPAT_VENDOR",
}

m.port_no_desc = {
    [0xffffff00] = "OFPP_MAX",
    [0xfffffff8] = "OFPP_IN_PORT",
    [0xfffffff9] = "OFPP_TABLE",
    [0xfffffffa] = "OFPP_NORMAL",
    [0xfffffffb] = "OFPP_FLOOD",
    [0xfffffffc] = "OFPP_ALL",
    [0xfffffffd] = "OFPP_CONTROLLER",
    [0xfffffffe] = "OFPP_LOCAL",
    [0xffffffff] = "OFPP_ANY",
}

function m.appendFields(fds)

end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs

    local packetout_tree = root_tree:add( buffer(start_ofs), "OFP Packet Out" )

    local buffer_id = buffer( ofs, 4 )
    ofs = ofs + 4
    local buffer_id_val = buffer_id:uint()

    local in_port = buffer( ofs, 4 )
    ofs = ofs + 4
    local in_port_val = in_port:uint()

    local actions_len = buffer( ofs, 2 )
    ofs = ofs + 2

    local pad = buffer( ofs, 6 )
    ofs = ofs + 6

    packetout_tree:add( buffer_id, "buffer_id:", m.buffer_id_desc[buffer_id_val] , buffer_id_val )
    packetout_tree:add( in_port, "in_port:", m.in_port_desc[in_port_val], in_port_val )
    packetout_tree:add( actions_len, "actions_len:", actions_len:uint() )
    packetout_tree:add( pad, "pad:", tostring( pad:bytes() ) )

    -- actions
    local action_tree = packetout_tree:add( buffer(ofs), "action")

    local action_type = buffer( ofs, 2 )
    ofs = ofs + 2
    local action_type_val = action_type:uint()

    local action_len = buffer( ofs, 2 )
    ofs = ofs + 2

    action_tree:add(action_type, "action_type:", m.action_type_desc[ action_type_val ], "("..action_type_val..")" )
    
    action_tree:add(action_len, "action_len:", action_len:uint() )
    
    if action_type_val == 0 then
    
        local output_port = buffer( ofs, 4 )
        ofs = ofs + 4
        
        local output_max_len = buffer( ofs, 2 )
        ofs = ofs + 2
        
        local output_pad = buffer( ofs, 6 )
        ofs = ofs + 6

        action_tree:add(output_port, "port:", m.port_no_desc[output_port:uint()], string.format("(0x%x)", output_port:uint() ) )
        action_tree:add(output_max_len, "max_len:", output_max_len:uint() )
        action_tree:add(output_pad, "pad:", tostring( output_pad:bytes() ) )
    
    end               
    
    packetout_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module