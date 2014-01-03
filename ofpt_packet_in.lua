local Module = {}

local m = Module

m.oxm_class_desc = {
    [0x0000] = "OFPXMC_NXM_0",
    [0x0001] = "OFPXMC_NXM_1",
    [0x8000] = "OFPXMC_OPENFLOW_BASIC",
    [0xffff] = "OFPXMC_EXPERIMENTER",
}

m.oxm_field_desc = {
    [0] = "OFPXMT_OFB_IN_PORT",
    [1] = "OFPXMT_OFB_IN_PHY_PORT",
    [2] = "OFPXMT_OFB_METADATA",
    [3] = "OFPXMT_OFB_ETH_DST",
    [4] = "OFPXMT_OFB_ETH_SRC",
    [5] = "OFPXMT_OFB_ETH_TYPE",
    [6] = "OFPXMT_OFB_VLAN_VID",
    [7] = "OFPXMT_OFB_VLAN_PCP",
    [8] = "OFPXMT_OFB_IP_DSCP",
    [9] = "OFPXMT_OFB_IP_ECN",
    [10] = "OFPXMT_OFB_IP_PROTO",
    [11] = "OFPXMT_OFB_IPV4_SRC",
    [12] = "OFPXMT_OFB_IPV4_DST",
    [13] = "OFPXMT_OFB_TCP_SRC",
    [14] = "OFPXMT_OFB_TCP_DST",
    [15] = "OFPXMT_OFB_UDP_SRC",
    [16] = "OFPXMT_OFB_UDP_DST",
    [17] = "OFPXMT_OFB_SCTP_SRC",
    [18] = "OFPXMT_OFB_SCTP_DST",
    [19] = "OFPXMT_OFB_ICMPV4_TYPE",
    [20] = "OFPXMT_OFB_ICMPV4_CODE",
    [21] = "OFPXMT_OFB_ARP_OP",
    [22] = "OFPXMT_OFB_ARP_SPA",
    [23] = "OFPXMT_OFB_ARP_TPA",
    [24] = "OFPXMT_OFB_ARP_SHA",
    [25] = "OFPXMT_OFB_ARP_THA",
    [26] = "OFPXMT_OFB_IPV6_SRC",
    [27] = "OFPXMT_OFB_IPV6_DST",
    [28] = "OFPXMT_OFB_IPV6_FLABEL",
    [29] = "OFPXMT_OFB_ICMPV6_TYPE",
    [30] = "OFPXMT_OFB_ICMPV6_CODE",
    [31] = "OFPXMT_OFB_IPV6_ND_TARGET",
    [32] = "OFPXMT_OFB_IPV6_ND_SLL",
    [33] = "OFPXMT_OFB_IPV6_ND_TLL",
    [34] = "OFPXMT_OFB_MPLS_LABEL",
    [35] = "OFPXMT_OFB_MPLS_TC",
    [36] = "OFPXMT_OFP_MPLS_BOS",
    [37] = "OFPXMT_OFB_PBB_ISID",
    [38] = "OFPXMT_OFB_TUNNEL_ID",
    [39] = "OFPXMT_OFB_IPV6_EXTHDR",
}

m.reason_desc = {
    [0] = "OFPR_NO_MATCH",
    [1] = "OFPR_ACTION",
    [2] = "OFPR_INVALID_TTL",
}

m.type_desc = {
    [0] = "OFPMT_STANDARD",
    [1] = "OFPMT_OXM",
}

function m.appendFields(fds)
    fds.packetin_oxm_class        = ProtoField.uint32("ofp.packetin_oxm_class", "oxm_class", base.HEX, m.oxm_class_desc, 0xffff0000)
    fds.packetin_oxm_field        = ProtoField.uint32("ofp.packetin_oxm_field", "oxm_field", base.DEC, m.oxm_field_desc, 0x0000fe00)
    fds.packetin_oxm_hasmask      = ProtoField.uint32("ofp.packetin_oxm_hasmask", "oxm_hasmask", base.DEC, nil,        0x00000100)
    fds.packetin_oxm_length       = ProtoField.uint32("ofp.packetin_oxm_length", "oxm_length", base.DEC, nil,          0x000000ff)
end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs

    local packetin_tree = root_tree:add( buffer(start_ofs), "OFP Packet In")

    local buffer_id = buffer( ofs, 4 )
    ofs = ofs + 4

    local total_len = buffer( ofs, 2 )
    ofs = ofs + 2

    local reason = buffer( ofs , 1 )
    ofs = ofs + 1

    local table_id = buffer( ofs, 1 )
    ofs = ofs + 1

    local cookie = buffer( ofs, 8 )
    ofs = ofs + 8

    packetin_tree:add( buffer_id, "buffer_id:", buffer_id:uint() )
    packetin_tree:add( total_len, "total_len:", total_len:uint() )
    packetin_tree:add( reason, "reason:", m.reason_desc[ reason:uint() ], "(" .. reason:uint() .. ")" )
    packetin_tree:add( table_id, "table_id:", table_id:uint() )
    packetin_tree:add( cookie, "cookie:", tostring( cookie:uint64() ) )

    -- ofp_match
    local length_val = buffer( ofs + 2 , 2 ):uint()
    local match_tree = packetin_tree:add( buffer(ofs, length_val+4), "match (packet metadata)")

    local type_f = buffer( ofs, 2 )
    ofs = ofs + 2

    local length = buffer( ofs, 2 )
    ofs = ofs + 2

    match_tree:add( type_f, "type:", m.type_desc[ type_f:uint() ], "(" .. type_f:uint() .. ")" )
    match_tree:add( length, "length:", length_val )

    local value_tree = match_tree:add( buffer(ofs, length_val), string.format("value (%d bytes)", length_val) )

    local oxm_class = buffer( ofs, 4 )
    local oxm_field = buffer( ofs, 4 )
    local oxm_hasmask = buffer( ofs, 4 )
    local oxm_length = buffer( ofs, 4 )
    ofs = ofs + 4

    local oxm_length_val = oxm_length:bitfield(24, 8)

    value_tree:add( fields.packetin_oxm_class, oxm_class )
    value_tree:add( fields.packetin_oxm_field, oxm_field )
    value_tree:add( fields.packetin_oxm_hasmask, oxm_hasmask )
    value_tree:add( fields.packetin_oxm_length, oxm_length )

    local oxm_value = buffer( ofs, oxm_length_val )
    ofs = ofs + oxm_length_val

    value_tree:add( oxm_value, "oxm_value:", oxm_value:uint() )

    local oxm_pad = buffer( ofs, 4 )
    ofs = ofs + 4

    value_tree:add( oxm_pad, "oxm_pad:", tostring( oxm_pad:bytes() ) )

    local pad = buffer( ofs, 2 )
    ofs = ofs + 2

    packetin_tree:add(pad, "pad:", tostring( pad:bytes() ) )

    local eth_frame_tree = packetin_tree:add( buffer(ofs), "Ethernet Frame" )
    eth_frame_tree:append_text(" (" .. total_len:uint() .. " bytes)" )

    local eth_dissector = Dissector.get("eth")
    eth_dissector:call( buffer(ofs):tvb(), info, eth_frame_tree )  

    ofs = ofs + total_len:uint()
   
    packetin_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module