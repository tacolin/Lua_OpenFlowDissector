do
    package.path = package.path .. ";Z:\\github\\open_flow_dissector\\?.lua"
    
    local ofp_proto = Proto("ofp", "SDN OpenFlow 1.3.1")
    ofp_proto.fields = {}

    local fds = ofp_proto.fields
    
    local ofp_hdr = require "ofp_header"
    local ofpt_hello = require "ofpt_hello"
    local ofpt_error = require "ofpt_error"
    local ofpt_feature_reply = require "ofpt_feature_reply"
    local ofpt_set_config = require "ofpt_set_config"
    local ofpt_packet_in = require "ofpt_packet_in"
    local ofpt_packet_out = require "ofpt_packet_out"
    local ofpt_multipart_req = require "ofpt_multipart_req"
    local ofpt_multipart_reply = require "ofpt_multipart_reply"

    ofp_hdr.appendFields(fds)
    ofpt_error.appendFields(fds)
    ofpt_hello.appendFields(fds)
    ofpt_set_config.appendFields(fds)
    ofpt_feature_reply.appendFields(fds)
    ofpt_packet_in.appendFields(fds)
    ofpt_packet_out.appendFields(fds)
    ofpt_multipart_req.appendFields(fds)
    ofpt_multipart_reply.appendFields(fds)

    ofp_proto.dissector = function(buffer, info, root_tree)

        local ofp_tree = root_tree:add(ofp_proto, buffer(0), "Open Flow Message")
        local offset = 0

        offset = ofp_hdr.dissect(buffer, info, ofp_tree, offset, fds)
        
        -- check TCP segment PDU or not
        if buffer:len() < ofp_hdr.length then
            info.desegment_len = DESEGMENT_ONE_MORE_SEGMENT
            return false
        end
        
        if (ofp_hdr.length - offset) > 0 then
            if ofp_hdr.type == 0 then --OFPT_HELLO
            
                offset = ofpt_hello.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 1 then -- OFPT_ERROR

                offset = ofpt_error.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 6 then -- OFPT_FEATURE_REPLY

                offset = ofpt_feature_reply.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 9 then -- OFPT_SET_CONFIG

                offset = ofpt_set_config.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 10 then -- OFPT_PACKET_IN

                offset = ofpt_packet_in.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 13 then -- OFPT_PACKET_OUT

                offset = ofpt_packet_out.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 18 then -- OFPT_MULTIPART_REQUEST

                offset = ofpt_multipart_req.dissect(buffer, info, ofp_tree, offset, fds)

            elseif ofp_hdr.type == 19 then -- OFPT_MULTIPART_REPLY

                offset = ofpt_multipart_reply.dissect(buffer, info, ofp_tree, offset, fds)

            else
                local payload = ofp_tree:add( buffer(offset, ofp_hdr.length - offset), "Unsupport Message Payload")
                payload:add_expert_info( PI_DEBUG, PI_NOTE, "Comming Soon ...")
            end

        else
--            ofp_tree:add_expert_info(PI_DEBUG, PI_NOTE, "This Message is old version ( < 1.3.1 )")
        end

        local cols_info = ofp_hdr.type_desc[ofp_hdr.type] .. " [xid=" .. ofp_hdr.xid .. "] "

        info.cols.protocol = "Open Flow 1.3.1"
        info.cols.info     = cols_info

    end

    local tcp_table = DissectorTable.get("tcp.port")
    tcp_table:add(6633, ofp_proto)

end
