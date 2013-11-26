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

    fds.ofp_header_type    = ProtoField.uint8("ofp.type", "type", base.DEC, type_f_desc)
    fds.ofp_header_length  = ProtoField.uint16("ofp.length", "length", base.DEC)
    fds.ofp_header_xid     = ProtoField.uint32("ofp.xid", "xid", base.DEC)

    local hello_elem_bitmaps_desc = {
        [0] = "False",
        [1] = "True",
    }

    local hello_elem_type_desc = {
        [1] = "OFPHET_VERSIONBITMAP",
    }
    
    fds.ofp_hello_elements_type = ProtoField.uint16("ofp.hello_elem_type", "type", base.DEC, hello_elem_type_desc)
    
    fds.ofp_hello_elements_bitmap_1_0_sup  = ProtoField.uint32("ofp.1_0_sup", "OFP Ver 1.0.x Supported", base.DEC, hello_elem_bitmaps_desc, 0x02)
    fds.ofp_hello_elements_bitmap_1_1_sup  = ProtoField.uint32("ofp.1_1_sup", "OFP Ver 1.1.x Supported", base.DEC, hello_elem_bitmaps_desc, 0x04)
    fds.ofp_hello_elements_bitmap_1_2_sup  = ProtoField.uint32("ofp.1_2_sup", "OFP Ver 1.2.x Supported", base.DEC, hello_elem_bitmaps_desc, 0x08)
    fds.ofp_hello_elements_bitmap_1_3_sup  = ProtoField.uint32("ofp.1_3_sup", "OFP Ver 1.3.x Supported", base.DEC, hello_elem_bitmaps_desc, 0x10)
    
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
        header_tree:add(fds.ofp_header_type , ofp_type)
        header_tree:add(fds.ofp_header_length , ofp_length)
        header_tree:add(fds.ofp_header_xid , ofp_xid)

        local err_msg = ""
        
        if (ofp_length_val - offset) > 0 then
            if ofp_type_val == 0 then -- OFPT_HELLO

                local elem_tree = ofp_tree:add( buffer(offset, ofp_length_val - offset), "OFP Hello Elements (" .. (ofp_length_val - offset) .. " bytes)")

                local elem_type = buffer(offset, 2)
                offset = offset + 2
                
                local elem_length = buffer(offset, 2)
                offset = offset + 2
                
                local elem_bitmap = buffer(offset, 4)
                offset = offset + 4
                
                elem_tree:add( fds.ofp_hello_elements_type, elem_type)
                elem_tree:add( elem_length, "length:", elem_length:uint() )
                elem_tree:add( fds.ofp_hello_elements_bitmap_1_0_sup, elem_bitmap)
                elem_tree:add( fds.ofp_hello_elements_bitmap_1_1_sup, elem_bitmap)
                elem_tree:add( fds.ofp_hello_elements_bitmap_1_2_sup, elem_bitmap)
                elem_tree:add( fds.ofp_hello_elements_bitmap_1_3_sup, elem_bitmap)

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
                
            else
                local payload = ofp_tree:add( buffer(offset, ofp_length_val - offset), "Unsupported Payload (Coming Soon ...)")
            end
                            
        else
            err_msg = "Decoded Failed"
        end

        local cols_info = type_f_desc[ofp_type:uint()] .. " [xid=" .. ofp_xid:uint() .. "] " .. err_msg 
        
        info.cols.protocol = "Open Flow 1.3.1"
        info.cols.info     = cols_info
    end    
    
    local tcp_table = DissectorTable.get("tcp.port")
    tcp_table:add(6633, ofp_proto)
    
end
