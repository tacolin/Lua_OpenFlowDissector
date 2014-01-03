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
    [1] = "OFPMPF_REPLY_MORE",
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
    fds.multipart_reply_port_down   = ProtoField.uint32("ofp.port_config", "OFPPC_PORT_DOWN", base.DEC, nil, 0x01)
    fds.multipart_reply_no_recv     = ProtoField.uint32("ofp.port_config", "OFPPC_NO_RECV", base.DEC,     nil, 0x04)
    fds.multipart_reply_no_fwd      = ProtoField.uint32("ofp.port_config", "OFPPC_NO_FWD", base.DEC,       nil, 0x20)
    fds.multipart_reply_no_packet_in = ProtoField.uint32("ofp.port_config", "OFPPC_NO_PACKET_IN", base.DEC, nil, 0x40)

    fds.multipart_reply_link_down   = ProtoField.uint32("ofp.port_state", "OFPPS_LINK_DOWN", base.DEC, nil, 0x01)
    fds.multipart_reply_blocked     = ProtoField.uint32("ofp.port_state", "OFPPS_BLOCKED", base.DEC,   nil, 0x02)
    fds.multipart_reply_live        = ProtoField.uint32("ofp.port_state", "OFPPS_LIVE", base.DEC,      nil, 0x04)

    fds.multipart_reply_10mb_hd     = ProtoField.uint32("ofp.port_features", "OFPPF_10MB_HD", base.DEC, nil, 0x01)
    fds.multipart_reply_10mb_fd     = ProtoField.uint32("ofp.port_features", "OFPPF_10MB_FD", base.DEC, nil, 0x02)
    fds.multipart_reply_100mb_hd    = ProtoField.uint32("ofp.port_features", "OFPPF_100MB_HD", base.DEC, nil, 0x04)
    fds.multipart_reply_100mb_fd    = ProtoField.uint32("ofp.port_features", "OFPPF_100MB_FD", base.DEC, nil, 0x08)
    fds.multipart_reply_1gb_hd      = ProtoField.uint32("ofp.port_features", "OFPPF_1GB_HD", base.DEC, nil, 0x10)
    fds.multipart_reply_1gb_fd      = ProtoField.uint32("ofp.port_features", "OFPPF_1GB_FD", base.DEC, nil, 0x20)
    fds.multipart_reply_10gb_fd     = ProtoField.uint32("ofp.port_features", "OFPPF_10GB_FD", base.DEC, nil, 0x40)
    fds.multipart_reply_40gb_fd     = ProtoField.uint32("ofp.port_features", "OFPPF_40GB_FD", base.DEC, nil, 0x80)
    fds.multipart_reply_100gb_fd    = ProtoField.uint32("ofp.port_features", "OFPPF_100GB_FD", base.DEC, nil, 0x100)
    fds.multipart_reply_1tb_fd      = ProtoField.uint32("ofp.port_features", "OFPPF_1TB_FD", base.DEC, nil, 0x200)
    fds.multipart_reply_other       = ProtoField.uint32("ofp.port_features", "OFPPF_OTHER", base.DEC, nil, 0x400)

    fds.multipart_reply_copper      = ProtoField.uint32("ofp.port_features", "OFPPF_COPPER", base.DEC, nil, 0x800)
    fds.multipart_reply_fiber       = ProtoField.uint32("ofp.port_features", "OFPPF_FIBER", base.DEC, nil, 0x1000)

    fds.multipart_reply_autoneg     = ProtoField.uint32("ofp.port_features", "OFPPF_AUTONEG", base.DEC, nil, 0x2000)
    fds.multipart_reply_pause       = ProtoField.uint32("ofp.port_features", "OFPPF_PAUSE", base.DEC, nil, 0x4000)
    fds.multipart_reply_pause_asym  = ProtoField.uint32("ofp.port_features", "OFPPF_PAUSE_ASYM", base.DEC, nil, 0x8000)
end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs

    local multi_reply_tree = root_tree:add( buffer(start_ofs), "OFP Mutlipart Reply")

    local type_f = buffer( ofs, 2 )
    local type_val = type_f:uint()
    ofs = ofs + 2

    local flags = buffer( ofs, 2 )
    local flags_val = flags:uint()
    ofs = ofs + 2

    local pad = buffer( ofs, 4 )
    ofs = ofs + 4

    multi_reply_tree:add( type_f, "type:", m.type_desc[type_val], "("..type_val..")" )
    multi_reply_tree:add( flags, "flags:", m.flags_desc[flags_val], "("..flags_val..")")
    multi_reply_tree:add( pad, "pad:", tostring( pad:bytes() ) )

    if type_val == 13 then -- OFPMP_PORT_DESCRIPTION

        while buffer:len() > ofs do

            local port_no = buffer(ofs, 4)
            local port_no_val = port_no:uint()
            ofs = ofs + 4

            local pad = buffer(ofs, 4)
            ofs = ofs + 4

            local hw_addr = buffer(ofs, 6)
            ofs = ofs + 6

            local pad2 = buffer(ofs, 2)
            ofs = ofs + 2

            local name = buffer(ofs, 16)
            ofs = ofs + 16

            local config = buffer(ofs, 4)
            ofs = ofs + 4

            local state = buffer(ofs, 4)
            ofs = ofs + 4

            local curr = buffer(ofs, 4)
            ofs = ofs + 4

            local advertised = buffer(ofs, 4)
            ofs = ofs + 4

            local supported = buffer(ofs, 4)
            ofs = ofs + 4

            local peer = buffer(ofs, 4)
            ofs = ofs + 4

            local curr_speed = buffer(ofs, 4)
            ofs = ofs + 4

            local max_speed = buffer(ofs, 4)
            ofs = ofs + 4

            local port_desc_tree = multi_reply_tree:add( buffer(ofs-64, 64), string.format("Port Description (%s)", name:string()) )

            port_desc_tree:add( port_no, "port_no:", m.port_no_desc[port_no_val], "("..port_no_val..")" )
            port_desc_tree:add( pad, "pad:", tostring( pad:bytes() ) )
            port_desc_tree:add( hw_addr, "hw_addr:", tostring( hw_addr:ether() ) )
            port_desc_tree:add( pad2, "pad2:", tostring( pad2:bytes() ) )
            port_desc_tree:add( name, "name:", name:string() )

            port_desc_tree:add( config, "config:" )
            port_desc_tree:add(fields.multipart_reply_port_down, config)
            port_desc_tree:add(fields.multipart_reply_no_recv, config)
            port_desc_tree:add(fields.multipart_reply_no_fwd, config)
            port_desc_tree:add(fields.multipart_reply_no_packet_in, config)

            port_desc_tree:add( state, "state:" )
            port_desc_tree:add(fields.multipart_reply_link_down, state)
            port_desc_tree:add(fields.multipart_reply_blocked, state)
            port_desc_tree:add(fields.multipart_reply_live, state)

            port_desc_tree:add( curr, "curr:" )
            port_desc_tree:add(fields.multipart_reply_10mb_hd, curr)
            port_desc_tree:add(fields.multipart_reply_10mb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_100mb_hd, curr)
            port_desc_tree:add(fields.multipart_reply_100mb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_1gb_hd, curr)
            port_desc_tree:add(fields.multipart_reply_1gb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_10gb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_40gb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_100gb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_1tb_fd, curr)
            port_desc_tree:add(fields.multipart_reply_other, curr)
            port_desc_tree:add(fields.multipart_reply_copper, curr)
            port_desc_tree:add(fields.multipart_reply_fiber, curr)
            port_desc_tree:add(fields.multipart_reply_autoneg, curr)
            port_desc_tree:add(fields.multipart_reply_pause, curr)
            port_desc_tree:add(fields.multipart_reply_pause_asym, curr)

            port_desc_tree:add( advertised, "advertised:" )
            port_desc_tree:add(fields.multipart_reply_10mb_hd, advertised)
            port_desc_tree:add(fields.multipart_reply_10mb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_100mb_hd, advertised)
            port_desc_tree:add(fields.multipart_reply_100mb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_1gb_hd, advertised)
            port_desc_tree:add(fields.multipart_reply_1gb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_10gb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_40gb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_100gb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_1tb_fd, advertised)
            port_desc_tree:add(fields.multipart_reply_other, advertised)
            port_desc_tree:add(fields.multipart_reply_copper, advertised)
            port_desc_tree:add(fields.multipart_reply_fiber, advertised)
            port_desc_tree:add(fields.multipart_reply_autoneg, advertised)
            port_desc_tree:add(fields.multipart_reply_pause, advertised)
            port_desc_tree:add(fields.multipart_reply_pause_asym, advertised)

            port_desc_tree:add( supported, "supported:" )
            port_desc_tree:add(fields.multipart_reply_10mb_hd, supported)
            port_desc_tree:add(fields.multipart_reply_10mb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_100mb_hd, supported)
            port_desc_tree:add(fields.multipart_reply_100mb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_1gb_hd, supported)
            port_desc_tree:add(fields.multipart_reply_1gb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_10gb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_40gb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_100gb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_1tb_fd, supported)
            port_desc_tree:add(fields.multipart_reply_other, supported)
            port_desc_tree:add(fields.multipart_reply_copper, supported)
            port_desc_tree:add(fields.multipart_reply_fiber, supported)
            port_desc_tree:add(fields.multipart_reply_autoneg, supported)
            port_desc_tree:add(fields.multipart_reply_pause, supported)
            port_desc_tree:add(fields.multipart_reply_pause_asym, supported)

            port_desc_tree:add( peer, "peer:" )
            port_desc_tree:add(fields.multipart_reply_10mb_hd, peer)
            port_desc_tree:add(fields.multipart_reply_10mb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_100mb_hd, peer)
            port_desc_tree:add(fields.multipart_reply_100mb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_1gb_hd, peer)
            port_desc_tree:add(fields.multipart_reply_1gb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_10gb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_40gb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_100gb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_1tb_fd, peer)
            port_desc_tree:add(fields.multipart_reply_other, peer)
            port_desc_tree:add(fields.multipart_reply_copper, peer)
            port_desc_tree:add(fields.multipart_reply_fiber, peer)
            port_desc_tree:add(fields.multipart_reply_autoneg, peer)
            port_desc_tree:add(fields.multipart_reply_pause, peer)
            port_desc_tree:add(fields.multipart_reply_pause_asym, peer)

            port_desc_tree:add(curr_speed, "curr_speed:", curr_speed:uint(), "kbps")
            port_desc_tree:add(max_speed,  "max_speed:",  max_speed:uint(), "kbps")

        end

    end

    multi_reply_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module