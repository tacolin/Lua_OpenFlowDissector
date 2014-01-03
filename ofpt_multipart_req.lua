local Module = {}

local m = Module

m.type_desc = {
    [0] = "OFPMP_DESC",
    [1] = "OFPMP_FLOW",
    [2] = "OFPMP_AGGREGATE",
    [3] = "OFPMP_TABLE",
    [4] = "OFPMP_PORT_STATS",
    [5] = "OFPMP_QUEUE",
    [6] = "OFPMP_GROUP",
    [7] = "OFPMP_GROUP_DESC",
    [8] = "OFPMP_GROUP_FEATURES",
    [9] = "OFPMP_METER",
    [10] = "OFPMP_METER_CONFIG",
    [11] = "OFPMP_METER_FEATURES",
    [12] = "OFPMP_TABLE_FEATURES",
    [13] = "OFPMP_PORT_DESC",
    [0xffff] = "OFPMP_EXPERIMENTER",
}

m.flags_desc = {
    [0] = "NONE",
    [1] = "OFPMPF_REQ_MORE",
}

function m.appendFields(fds)

end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs

    local multi_req_tree = root_tree:add( buffer(start_ofs), "OFP Mutlipart Request")

    local type_f = buffer( ofs, 2 )
    ofs = ofs + 2

    local flags = buffer( ofs, 2 )
    ofs = ofs + 2

    local pad = buffer( ofs, 4 )
    ofs = ofs + 4

    multi_req_tree:add( type_f, "type:", m.type_desc[type_f:uint()], "("..type_f:uint()..")" )
    multi_req_tree:add( flags, "flags:", m.flags_desc[flags:uint()], "("..flags:uint()..")")
    multi_req_tree:add( pad, "pad:", tostring( pad:bytes() ) )
    
    multi_req_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module