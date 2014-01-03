local Module = {}

local m = Module

m.type_desc = {
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

m.code_desc = {
    [0] = {
        [0] = "OFPHFC_INCOMPATIBLE ",
        [1] = "OFPHFC_EPERM ",
    },
}

function m.appendFields(fds)
    fds.error_type = ProtoField.uint16("ofp.error_type", "type", base.DEC, m.type_desc)
    --fds.error_code = ProtoField.uint16("ofp.error_code", "code", base.DEC)
    fds.error_data = ProtoField.string("ofp.error_data", "data")
end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs
    
    local error_tree = root_tree:add( buffer(start_ofs), "OFP Error Message")

    local type = buffer(ofs, 2)
    ofs = ofs + 2

    local code = buffer(ofs, 2)
    ofs = ofs + 2

    local data = buffer(ofs)
    ofs = ofs + buffer(ofs):len()

    error_tree:add( fields.error_type, type)
    error_tree:add( code, string.format("code: %s(%d)", m.code_desc[type:uint()][code:uint()], code:uint()) )
    error_tree:add( fields.error_data, data)

    error_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module