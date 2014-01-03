local Module = {}

local m = Module

function m.appendFields(fds)
    fds.feature_reply_flow_stats  = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_FLOW_STATS", base.DEC,    nil, 0x01)
    fds.feature_reply_table_stats = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_TABLE_STATS", base.DEC,   nil, 0x02)
    fds.feature_reply_port_stats  = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_PORT_STATS", base.DEC,    nil, 0x04)
    fds.feature_reply_group_stats = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_GROUP_STATS", base.DEC,   nil, 0x08)
    fds.feature_reply_ip_reasm    = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_IP_REASM", base.DEC,      nil, 0x20)
    fds.feature_reply_queue_stats = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_QUEUE_STATS", base.DEC,   nil, 0x40)
    fds.feature_reply_port_blocked = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_PORT_BLOCKED", base.DEC, nil, 0x100)
end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs

    local fea_reply_tree = root_tree:add( buffer(start_ofs), "OFP Feature Reply")

    local datapath_id = buffer( ofs, 8 )
    ofs = ofs + 8

    local n_buffers = buffer( ofs, 4 )
    ofs = ofs + 4

    local n_tables = buffer( ofs, 1 )
    ofs = ofs + 1

    local auxiliary_id = buffer( ofs, 1 )
    ofs = ofs + 1

    local pad = buffer( ofs, 2 )
    ofs = ofs + 2

    local capabilities = buffer( ofs, 4 )
    ofs = ofs + 4

    local reserved = buffer( ofs, 4 )
    ofs = ofs + 4

    fea_reply_tree:add( datapath_id, "datapath_id:",  tostring(datapath_id:uint64()) )
    fea_reply_tree:add( n_buffers, "n_buffers:", n_buffers:uint() )
    fea_reply_tree:add( n_tables, "n_tables:", n_tables:uint() )
    fea_reply_tree:add( auxiliary_id, "auxiliary_id:", auxiliary_id:uint() )
    fea_reply_tree:add( pad, "pad:", tostring( pad:bytes() ) )

    fea_reply_tree:add( capabilities, "capabilites:" )
    fea_reply_tree:add( fields.feature_reply_flow_stats, capabilities)
    fea_reply_tree:add( fields.feature_reply_table_stats , capabilities)
    fea_reply_tree:add( fields.feature_reply_port_stats, capabilities)
    fea_reply_tree:add( fields.feature_reply_group_stats, capabilities)
    fea_reply_tree:add( fields.feature_reply_ip_reasm, capabilities)
    fea_reply_tree:add( fields.feature_reply_queue_stats, capabilities)
    fea_reply_tree:add( fields.feature_reply_port_blocked, capabilities)

    fea_reply_tree:add( reserved, "reserved:", reserved:uint() )

    fea_reply_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )    
    
    return ofs
end

return Module