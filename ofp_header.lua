local Module = {}

local m = Module

m.version_desc = {
    [1] = "1.0.x",
    [2] = "1.1.x",
    [3] = "1.2.x",
    [4] = "1.3.x",
}

m.type_desc = {
    -- Immutable messages
    [0] = "OFPT_HELLO",
    [1] = "OFPT_ERROR",
    [2] = "OFPT_ECHO_REQUEST",
    [3] = "OFPT_ECHO_REPLY",
    [4] = "OFPT_EXPERIMENTER",

    -- Switch configuration messages
    [5] = "OFPT_FEATURES_REQUEST",
    [6] = "OFPT_FEATURES_REPLY",
    [7] = "OFPT_GET_CONFIG_REQUEST",
    [8] = "OFPT_GET_CONFIG_REPLY",
    [9] = "OFPT_SET_CONFIG",

    -- Asynchronous messages
    [10] = "OFPT_PACKET_IN",
    [11] = "OFPT_FLOW_REMOVED",
    [12] = "OFPT_PORT_STATUS",

    -- Controller command messages
    [13] = "OFPT_PACKET_OUT",
    [14] = "OFPT_FLOW_MOD",
    [15] = "OFPT_GROUP_MOD",
    [16] = "OFPT_PORT_MOD",
    [17] = "OFPT_TABLE_MOD",

    -- Multipart messages
    [18] = "OFPT_MULTIPART_REQUEST",
    [19] = "OFPT_MULTIPART_REPLY",

    -- Barrier messages
    [20] = "OFPT_BARRIER_REQUEST",
    [21] = "OFPT_BARRIER_REPLY",

    -- Queue Configuration messages
    [22] = "OFPT_QUEUE_GET_CONFIG_REQUEST",
    [23] = "OFPT_QUEUE_GET_CONFIG_REPLY",

    -- Controller role change request messages
    [24] = "OFPT_ROLE_REQUEST",
    [25] = "OFPT_ROLE_REPLY",

    -- Asynchronous message configuration
    [26] = "OFPT_GET_ASYNC_REQUEST",
    [27] = "OFPT_GET_ASYNC_REPLY",
    [28] = "OFPT_SET_ASYNC",

    -- Meters and rate limiters configuration messages
    [29] = "OFPT_METER_MOD",
}

function m.appendFields(fds)
    fds.hdr_version = ProtoField.uint8("ofp.hdr_version", "version", base.DEC, m.version_desc)
    fds.hdr_type    = ProtoField.uint8("ofp.hdr_type", "type", base.DEC, m.type_desc)
    fds.hdr_length  = ProtoField.uint16("ofp.hdr_length", "length", base.DEC)
    fds.hdr_xid     = ProtoField.uint32("ofp.hdr_xid", "xid", base.DEC)
end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs
    
    local version = buffer(ofs,1)
    ofs=ofs+1
    
    local type = buffer(ofs,1)
    ofs=ofs+1
    
    local length = buffer(ofs,2)
    ofs=ofs+2
    
    local xid = buffer(ofs,4)
    ofs=ofs+4

    m.type      = type:uint()
    m.length    = length:uint()
    m.xid       = xid:uint()
    
    local hdr_tree = root_tree:add( buffer(start_ofs, ofs-start_ofs), "OFP Header (" .. ofs-start_ofs .. " bytes)" )

    hdr_tree:add(fields.hdr_version,    version)
    hdr_tree:add(fields.hdr_type,       type)
    hdr_tree:add(fields.hdr_length,     length)
    hdr_tree:add(fields.hdr_xid,        xid)
        
    root_tree:append_text( " (".. m.type_desc[type:uint()] ..")" )  
        
    return ofs
end

return Module