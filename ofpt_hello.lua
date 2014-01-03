local Module = {}

local m = Module

m.element_type_desc = {
    [1] = "OFPHET_VERSIONBITMAP",
}

function m.appendFields(fds)
    fds.hello_element_type = ProtoField.uint16("ofp.hello_element_type", "type", base.DEC, m.element_type_desc)
    fds.hello_element_length = ProtoField.uint16("ofp.hello_element_length", "length", base.DEC)
    fds.hello_element_bitmap_1_0_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.0.x Supported", base.DEC, nil, 0x02)
    fds.hello_element_bitmap_1_1_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.1.x Supported", base.DEC, nil, 0x04)
    fds.hello_element_bitmap_1_2_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.2.x Supported", base.DEC, nil, 0x08)
    fds.hello_element_bitmap_1_3_sup  = ProtoField.uint32("ofp.hello_elem_bitmap", "1.3.x Supported", base.DEC, nil, 0x10)    
end

function m.dissect(buffer, info, root_tree, start_ofs, fields)

    local ofs = start_ofs
    local hello_tree = root_tree:add( buffer(start_ofs), "OFP Hello Message")

    local type = buffer(ofs, 2)
    ofs = ofs + 2

    local length = buffer(ofs, 2)
    ofs = ofs + 2

    local bitmap = buffer(ofs, 4)
    ofs = ofs + 4

    hello_tree:add( fields.hello_element_type, type)
    hello_tree:add( fields.hello_element_length, length )

    hello_tree:add( bitmap, "supported versions:")

    hello_tree:add( fields.hello_element_bitmap_1_0_sup, bitmap)
    hello_tree:add( fields.hello_element_bitmap_1_1_sup, bitmap)
    hello_tree:add( fields.hello_element_bitmap_1_2_sup, bitmap)
    hello_tree:add( fields.hello_element_bitmap_1_3_sup, bitmap)

    hello_tree:append_text(" (" .. ofs-start_ofs .. " bytes)" )
    
    return ofs
end

return Module