do

    local ofp_proto = Proto("ofp", "SDN OpenFlow 1.3.1")

    ofp_proto.fields = {}
    
    local fds = ofp_proto.fields
    
    local version_f_desc = {
        [1] = "1.0.x",
        [2] = "1.1.x",
        [3] = "1.2.x",
        [4] = "1.3.x",
    }
    
    fds.ofp_header_version = ProtoField.uint8("ofp.version", "version", base.DEC, version_f_desc)

    local type_f_desc = {
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

    fds.header_type    = ProtoField.uint8("ofp.type", "type", base.DEC, type_f_desc)
    fds.header_length  = ProtoField.uint16("ofp.length", "length", base.DEC)
    fds.header_xid     = ProtoField.uint32("ofp.xid", "xid", base.DEC)

    local hello_elem_type_desc = {
        [1] = "OFPHET_VERSIONBITMAP",
    }
    
    fds.hello_element_type = ProtoField.uint16("ofp.hello_elem_type", "type", base.DEC, hello_elem_type_desc)
    
    fds.hello_element_bitmap_1_0_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.0.x Supported", base.DEC, nil, 0x02)
    fds.hello_element_bitmap_1_1_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.1.x Supported", base.DEC, nil, 0x04)
    fds.hello_element_bitmap_1_2_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.2.x Supported", base.DEC, nil, 0x08)
    fds.hello_element_bitmap_1_3_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.3.x Supported", base.DEC, nil, 0x10)

    fds.feature_reply_flow_stats  = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_FLOW_STATS", base.DEC,    nil, 0x01)
    fds.feature_reply_table_stats = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_TABLE_STATS", base.DEC,   nil, 0x02)
    fds.feature_reply_port_stats  = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_PORT_STATS", base.DEC,    nil, 0x04)
    fds.feature_reply_group_stats = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_GROUP_STATS", base.DEC,   nil, 0x08)
    fds.feature_reply_ip_reasm    = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_IP_REASM", base.DEC,      nil, 0x20)
    fds.feature_reply_queue_stats = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_QUEUE_STATS", base.DEC,   nil, 0x40)
    fds.feature_reply_port_blocked = ProtoField.uint32("ofp.feature_reply_cap", "OFPC_PORT_BLOCKED", base.DEC, nil, 0x100)
    
    fds.multicast_reply_port_down = ProtoField.uint32("ofp.port_config", "OFPPC_PORT_DOWN", base.DEC, nil, 0x01)
    fds.multicast_reply_no_recv = ProtoField.uint32("ofp.port_config", "OFPPC_NO_RECV", base.DEC,     nil, 0x04)
    fds.multicast_reply_no_fwd = ProtoField.uint32("ofp.port_config", "OFPPC_NO_FWD", base.DEC,       nil, 0x20)
    fds.multicast_reply_no_packet_in = ProtoField.uint32("ofp.port_config", "OFPPC_NO_PACKET_IN", base.DEC, nil, 0x40)

    fds.multicast_reply_link_down   = ProtoField.uint32("ofp.port_state", "OFPPS_LINK_DOWN", base.DEC, nil, 0x01)
    fds.multicast_reply_blocked     = ProtoField.uint32("ofp.port_state", "OFPPS_BLOCKED", base.DEC,   nil, 0x02)
    fds.multicast_reply_live        = ProtoField.uint32("ofp.port_state", "OFPPS_LIVE", base.DEC,      nil, 0x04)
    
    fds.multicast_reply_10mb_hd     = ProtoField.uint32("ofp.port_features", "OFPPF_10MB_HD", base.DEC, nil, 0x01)
    fds.multicast_reply_10mb_fd     = ProtoField.uint32("ofp.port_features", "OFPPF_10MB_FD", base.DEC, nil, 0x02)
    fds.multicast_reply_100mb_hd    = ProtoField.uint32("ofp.port_features", "OFPPF_100MB_HD", base.DEC, nil, 0x04)
    fds.multicast_reply_100mb_fd    = ProtoField.uint32("ofp.port_features", "OFPPF_100MB_FD", base.DEC, nil, 0x08)
    fds.multicast_reply_1gb_hd      = ProtoField.uint32("ofp.port_features", "OFPPF_1GB_HD", base.DEC, nil, 0x10)
    fds.multicast_reply_1gb_fd      = ProtoField.uint32("ofp.port_features", "OFPPF_1GB_FD", base.DEC, nil, 0x20)
    fds.multicast_reply_10gb_fd     = ProtoField.uint32("ofp.port_features", "OFPPF_10GB_FD", base.DEC, nil, 0x40)
    fds.multicast_reply_40gb_fd     = ProtoField.uint32("ofp.port_features", "OFPPF_40GB_FD", base.DEC, nil, 0x80)
    fds.multicast_reply_100gb_fd    = ProtoField.uint32("ofp.port_features", "OFPPF_100GB_FD", base.DEC, nil, 0x100)
    fds.multicast_reply_1tb_fd      = ProtoField.uint32("ofp.port_features", "OFPPF_1TB_FD", base.DEC, nil, 0x200)
    fds.multicast_reply_other       = ProtoField.uint32("ofp.port_features", "OFPPF_OTHER", base.DEC, nil, 0x400)

    fds.multicast_reply_copper      = ProtoField.uint32("ofp.port_features", "OFPPF_COPPER", base.DEC, nil, 0x800) 
    fds.multicast_reply_fiber       = ProtoField.uint32("ofp.port_features", "OFPPF_FIBER", base.DEC, nil, 0x1000) 

    fds.multicast_reply_autoneg     = ProtoField.uint32("ofp.port_features", "OFPPF_AUTONEG", base.DEC, nil, 0x2000) 
    fds.multicast_reply_pause       = ProtoField.uint32("ofp.port_features", "OFPPF_PAUSE", base.DEC, nil, 0x4000) 
    fds.multicast_reply_pause_asym  = ProtoField.uint32("ofp.port_features", "OFPPF_PAUSE_ASYM", base.DEC, nil, 0x8000) 
    
    ofp_proto.dissector = function(buffer, info, root_tree)
    
        local offset = 0

        local ofp_version = buffer(offset, 1)
        offset = offset + 1

        local ofp_type = buffer(offset, 1)
        local ofp_type_val = ofp_type:uint()
        offset = offset + 1
        
        local ofp_length = buffer(offset, 2)
        local ofp_length_val = ofp_length:uint()
        offset = offset + 2
        
        local ofp_xid = buffer(offset, 4)
        offset = offset + 4
        
        local ofp_tree = root_tree:add(ofp_proto, buffer(0, ofp_length_val), "Open Flow Message (" .. type_f_desc[ofp_type:uint()] .. ")")
        local header_tree = ofp_tree:add(buffer(0, offset), "OFP Header")

        header_tree:add(fds.ofp_header_version, ofp_version)
        header_tree:add(fds.header_type , ofp_type)
        header_tree:add(fds.header_length , ofp_length)
        header_tree:add(fds.header_xid , ofp_xid)
       
        if (ofp_length_val - offset) > 0 then
            if ofp_type_val == 0 then --OFPT_HELLO

                local elem_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Hello Elements (" .. (ofp_length_val - offset) .. " bytes)")

                local elem_type = buffer(offset, 2)
                offset = offset + 2
                
                local elem_length = buffer(offset, 2)
                offset = offset + 2
                
                local elem_bitmap = buffer(offset, 4)
                offset = offset + 4
                
                elem_tree:add( fds.hello_element_type, elem_type)
                elem_tree:add( elem_length, "length:", elem_length:uint() )
                elem_tree:add( elem_bitmap, "supported versions:")
                elem_tree:add( fds.hello_element_bitmap_1_0_sup, elem_bitmap)
                elem_tree:add( fds.hello_element_bitmap_1_1_sup, elem_bitmap)
                elem_tree:add( fds.hello_element_bitmap_1_2_sup, elem_bitmap)
                elem_tree:add( fds.hello_element_bitmap_1_3_sup, elem_bitmap)

            elseif ofp_type_val == 1 then -- OFPT_ERROR
            
                local error_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Error Messages (" .. (ofp_length_val - offset) .. " bytes)")
                
                local error_type = buffer(offset, 2)
                local error_type_val = error_type:uint()
                offset = offset + 2
                
                local error_code = buffer(offset, 2)
                local error_code_val = error_code:uint()
                offset = offset + 2
                
                local error_data = buffer(offset, ofp_length_val - offset)
                offset = ofp_length_val
                
                local error_type_desc = {
                    [0] = "OFPET_HELLO_FAILED",
                    [1] = "OFPET_BAD_REQUEST",
                    [2] = "OFPET_BAD_ACTION",
                    [3] = "OFPET_BAD_INSTRUCTION",
                    [4] = "OFPET_BAD_MATCH = 4",
                    [5] = "OFPET_FLOW_MOD_FAILED",
                    [6] = "OFPET_GROUP_MOD_FAILED",
                    [7] = "OFPET_PORT_MOD_FAILED",
                    [8] = "OFPET_TABLE_MOD_FAILED",
                    [9] = "OFPET_QUEUE_OP_FAILED",
                    [10] = "OFPET_SWITCH_CONFIG_FAILED",
                    [11] = "OFPET_ROLE_REQUEST_FAILED",
                    [12] = "OFPET_METER_MOD_FAILED",
                    [13] = "OFPET_TABLE_FEATURES_FAILED",
                    [0xffff] = "OFPET_EXPERIMENTER = 0xffff",
                }                                
                
                error_tree:add( error_type, "type:", error_type_val, "("..error_type_desc[error_type_val]..")" )
                
                local error_code_desc = {
                    [0] = {
                        [0] = "OFPHFC_INCOMPATIBLE",
                        [1] = "OFPHFC_EPERM",
                    },
                }
                
                error_tree:add( error_code, "code:", error_code:uint(), "("..error_code_desc[error_type_val][error_code_val]..")" )
                error_tree:add( error_data, "data:", error_data:string() )
                
            elseif ofp_type_val == 6 then -- OFPT_FEATURE_REPLY
                
                local fea_reply_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Feature Reply (" .. (ofp_length_val - offset) .. " bytes)")
                
                local datapath_id = buffer( offset, 8 )
                offset = offset + 8
                
                local n_buffers = buffer( offset, 4 )
                offset = offset + 4
                
                local n_tables = buffer( offset, 1 )
                offset = offset + 1
                
                local auxiliary_id = buffer( offset, 1 )
                offset = offset + 1 
                
                local pad = buffer( offset, 2 )
                offset = offset + 2
                
                local capabilities = buffer( offset, 4 )
                offset = offset + 4
                
                local reserved = buffer( offset, 4 )
                offset = offset + 4
                
                fea_reply_tree:add( datapath_id, "datapath_id:",  tostring(datapath_id:uint64()) )
                fea_reply_tree:add( n_buffers, "n_buffers:", n_buffers:uint() )
                fea_reply_tree:add( n_tables, "n_tables:", n_tables:uint() )
                fea_reply_tree:add( auxiliary_id, "auxiliary_id:", auxiliary_id:uint() )
                fea_reply_tree:add( pad, "pad:", tostring( pad:bytes() ) )

                fea_reply_tree:add( capabilities, "capabilites:" )
                fea_reply_tree:add(fds.feature_reply_flow_stats, capabilities)
                fea_reply_tree:add(fds.feature_reply_table_stats , capabilities)
                fea_reply_tree:add(fds.feature_reply_port_stats, capabilities)  
                fea_reply_tree:add(fds.feature_reply_group_stats, capabilities) 
                fea_reply_tree:add(fds.feature_reply_ip_reasm, capabilities)    
                fea_reply_tree:add(fds.feature_reply_queue_stats, capabilities) 
                fea_reply_tree:add(fds.feature_reply_port_blocked, capabilities)

                fea_reply_tree:add( reserved, "reserved:", reserved:uint() )
                
            elseif ofp_type_val == 9 then -- OFPT_SET_CONFIG

                local set_cfg_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Set Config (" .. (ofp_length_val - offset) .. " bytes)")
                
                local flags = buffer( offset, 2 )
                offset = offset + 2
                
                local miss_send_len = buffer( offset, 2 )
                offset = offset + 2
                
                local flags_desc = {
                    [0] = "OFPC_FRAG_NORMAL",
                    [1] = "OFPC_FRAG_DROP",
                    [2] = "OFPC_FRAG_REASM",
                    [3] = "OFPC_FRAG_MASK",
                }
                
                set_cfg_tree:add( flags, "flags:", flags_desc[flags:uint()], "("..flags:uint()..")" )
                set_cfg_tree:add( miss_send_len, "miss_send_len:", miss_send_len:uint() )

            elseif ofp_type_val == 18 then -- OFPT_MULTIPART_REQUEST
            
                local multi_req_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Mutlipart Request (" .. (ofp_length_val - offset) .. " bytes)")
                
                local type_f = buffer( offset, 2 )
                offset = offset + 2
                
                local flags = buffer( offset, 2 )
                offset = offset + 2
                
                local pad = buffer( offset, 4 )
                offset = offset + 4
                
                --local body = buffer( offset, 1 )
                --offset = offset + 1

                type_desc = {
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
                
                flags_desc = {
                    [0] = "NONE",
                    [1] = "OFPMPF_REQ_MORE",
                }
                
                multi_req_tree:add( type_f, "type:", type_desc[type_f:uint()], "("..type_f:uint()..")" )
                multi_req_tree:add( flags, "flags:", flags_desc[flags:uint()], "("..flags:uint()..")")
                multi_req_tree:add( pad, "pad:", tostring( pad:bytes() ) )
                --multi_req_tree:add( body, "body", body:uint() )                

            elseif ofp_type_val == 19 then -- OFPT_MULTIPART_REPLY

                local multi_reply_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Mutlipart Reply (" .. (ofp_length_val - offset) .. " bytes)")
                
                local type_f = buffer( offset, 2 )
                local type_val = type_f:uint()
                offset = offset + 2
                
                local flags = buffer( offset, 2 )
                local flags_val = flags:uint()
                offset = offset + 2
                
                local pad = buffer( offset, 4 )
                offset = offset + 4
                
                type_desc = {
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
                
                flags_desc = {
                    [0] = "NONE",
                    [1] = "OFPMPF_REPLY_MORE",
                }
                
                multi_reply_tree:add( type_f, "type:", type_desc[type_val], "("..type_val..")" )
                multi_reply_tree:add( flags, "flags:", flags_desc[flags_val], "("..flags_val..")")
                multi_reply_tree:add( pad, "pad:", tostring( pad:bytes() ) )
                                    
                if type_val == 13 then -- OFPMP_PORT_DESCRIPTION
                
                    while ofp_length_val > offset do
                        
                        local port_no = buffer(offset, 4)
                        local port_no_val = port_no:uint()
                        offset = offset + 4
                        
                        local pad = buffer(offset, 4)
                        offset = offset + 4
                        
                        local hw_addr = buffer(offset, 6)
                        offset = offset + 6 
                        
                        local pad2 = buffer(offset, 2)
                        offset = offset + 2
                        
                        local name = buffer(offset, 16)
                        offset = offset + 16
                        
                        local config = buffer(offset, 4)
                        offset = offset + 4
                        
                        local state = buffer(offset, 4)
                        offset = offset + 4
                        
                        local curr = buffer(offset, 4)
                        offset = offset + 4
                        
                        local advertised = buffer(offset, 4)
                        offset = offset + 4
                        
                        local supported = buffer(offset, 4)
                        offset = offset + 4
                        
                        local peer = buffer(offset, 4)
                        offset = offset + 4
                        
                        local curr_speed = buffer(offset, 4)
                        offset = offset + 4
                        
                        local max_speed = buffer(offset, 4)
                        offset = offset + 4
                        
                        local port_no_desc = {
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

                        local port_desc_tree = multi_reply_tree:add( buffer(offset-64, 64), string.format("Port Description (%s)", name:string()) )
                        
                        port_desc_tree:add( port_no, "port_no:", port_no_desc[port_no_val], "("..port_no_val..")" )
                        port_desc_tree:add( pad, "pad:", tostring( pad:bytes() ) )
                        port_desc_tree:add( hw_addr, "hw_addr:", tostring( hw_addr:ether() ) )
                        port_desc_tree:add( pad2, "pad2:", tostring( pad2:bytes() ) )
                        port_desc_tree:add( name, "name:", name:string() )
                        
                        port_desc_tree:add( config, "config:" )
                        port_desc_tree:add(fds.multicast_reply_port_down, config)
                        port_desc_tree:add(fds.multicast_reply_no_recv, config)
                        port_desc_tree:add(fds.multicast_reply_no_fwd, config)
                        port_desc_tree:add(fds.multicast_reply_no_packet_in, config)
                        
                        port_desc_tree:add( state, "state:" )
                        port_desc_tree:add(fds.multicast_reply_link_down, state)
                        port_desc_tree:add(fds.multicast_reply_blocked, state)
                        port_desc_tree:add(fds.multicast_reply_live, state)

                        port_desc_tree:add( curr, "curr:" )
                        port_desc_tree:add(fds.multicast_reply_10mb_hd, curr)
                        port_desc_tree:add(fds.multicast_reply_10mb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_100mb_hd, curr)
                        port_desc_tree:add(fds.multicast_reply_100mb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_1gb_hd, curr)
                        port_desc_tree:add(fds.multicast_reply_1gb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_10gb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_40gb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_100gb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_1tb_fd, curr)
                        port_desc_tree:add(fds.multicast_reply_other, curr)
                        port_desc_tree:add(fds.multicast_reply_copper, curr)
                        port_desc_tree:add(fds.multicast_reply_fiber, curr)
                        port_desc_tree:add(fds.multicast_reply_autoneg, curr)
                        port_desc_tree:add(fds.multicast_reply_pause, curr)
                        port_desc_tree:add(fds.multicast_reply_pause_asym, curr)
                        
                        port_desc_tree:add( advertised, "advertised:" )
                        port_desc_tree:add(fds.multicast_reply_10mb_hd, advertised)
                        port_desc_tree:add(fds.multicast_reply_10mb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_100mb_hd, advertised)
                        port_desc_tree:add(fds.multicast_reply_100mb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_1gb_hd, advertised)
                        port_desc_tree:add(fds.multicast_reply_1gb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_10gb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_40gb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_100gb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_1tb_fd, advertised)
                        port_desc_tree:add(fds.multicast_reply_other, advertised)
                        port_desc_tree:add(fds.multicast_reply_copper, advertised)
                        port_desc_tree:add(fds.multicast_reply_fiber, advertised)
                        port_desc_tree:add(fds.multicast_reply_autoneg, advertised)
                        port_desc_tree:add(fds.multicast_reply_pause, advertised)
                        port_desc_tree:add(fds.multicast_reply_pause_asym, advertised)        

                        port_desc_tree:add( supported, "supported:" )
                        port_desc_tree:add(fds.multicast_reply_10mb_hd, supported)
                        port_desc_tree:add(fds.multicast_reply_10mb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_100mb_hd, supported)
                        port_desc_tree:add(fds.multicast_reply_100mb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_1gb_hd, supported)
                        port_desc_tree:add(fds.multicast_reply_1gb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_10gb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_40gb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_100gb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_1tb_fd, supported)
                        port_desc_tree:add(fds.multicast_reply_other, supported)
                        port_desc_tree:add(fds.multicast_reply_copper, supported)
                        port_desc_tree:add(fds.multicast_reply_fiber, supported)
                        port_desc_tree:add(fds.multicast_reply_autoneg, supported)
                        port_desc_tree:add(fds.multicast_reply_pause, supported)
                        port_desc_tree:add(fds.multicast_reply_pause_asym, supported)  

                        port_desc_tree:add( peer, "peer:" )
                        port_desc_tree:add(fds.multicast_reply_10mb_hd, peer)
                        port_desc_tree:add(fds.multicast_reply_10mb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_100mb_hd, peer)
                        port_desc_tree:add(fds.multicast_reply_100mb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_1gb_hd, peer)
                        port_desc_tree:add(fds.multicast_reply_1gb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_10gb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_40gb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_100gb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_1tb_fd, peer)
                        port_desc_tree:add(fds.multicast_reply_other, peer)
                        port_desc_tree:add(fds.multicast_reply_copper, peer)
                        port_desc_tree:add(fds.multicast_reply_fiber, peer)
                        port_desc_tree:add(fds.multicast_reply_autoneg, peer)
                        port_desc_tree:add(fds.multicast_reply_pause, peer)
                        port_desc_tree:add(fds.multicast_reply_pause_asym, peer)
                        
                        port_desc_tree:add(curr_speed, "curr_speed:", curr_speed:uint(), "kbps")
                        port_desc_tree:add(max_speed,  "max_speed:",  max_speed:uint(), "kbps")

                    end
                    
                end
                    
            else
                local payload = ofp_tree:add( buffer(offset, ofp_length_val - offset), "Unsupport Message Payload")
                payload:add_expert_info( PI_DEBUG, PI_NOTE, "Comming Soon ...")
            end
                            
        else
--            ofp_tree:add_expert_info(PI_DEBUG, PI_NOTE, "This Message is old version ( < 1.3.1 )")
        end

        local cols_info = type_f_desc[ofp_type:uint()] .. " [xid=" .. ofp_xid:uint() .. "] "
        
        info.cols.protocol = "Open Flow 1.3.1"
        info.cols.info     = cols_info
    end    
      
    local tcp_table = DissectorTable.get("tcp.port")
    tcp_table:add(6633, ofp_proto)
    
end
