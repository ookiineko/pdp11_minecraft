
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.

include "Text"
include "Entities"


macro int _chest_read_0(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[0].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_1(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[1].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_2(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[2].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_3(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[3].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_4(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[4].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_5(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[5].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_6(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[6].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_7(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[7].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_8(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[8].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

int _chest_read_0_to_8(Entity armstand, int slot) {
    _NBT var();
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));
    if (slot == 0) {
        at (armstand) {
            return _chest_read_0(var, here);
        }
    } else if (slot == 1) {
        at (armstand) {
            return _chest_read_1(var, here);
        }
    } else if (slot == 2) {
        at (armstand) {
            return _chest_read_2(var, here);
        }
    } else if (slot == 3) {
        at (armstand) {
            return _chest_read_3(var, here);
        }
    } else if (slot == 4) {
        at (armstand) {
            return _chest_read_4(var, here);
        }
    } else if (slot == 5) {
        at (armstand) {
            return _chest_read_5(var, here);
        }
    } else if (slot == 6) {
        at (armstand) {
            return _chest_read_6(var, here);
        }
    } else if (slot == 7) {
        at (armstand) {
            return _chest_read_7(var, here);
        }
    } else if (slot == 8) {
        at (armstand) {
            return _chest_read_8(var, here);
        }
    } else
        return -1;
}

macro int _chest_read_9(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[9].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_10(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[10].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_11(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[11].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_12(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[12].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_13(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[13].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_14(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[14].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_15(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[15].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_16(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[16].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_17(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[17].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

int _chest_read_9_to_17(Entity armstand, int slot) {
    _NBT var();
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));
    if (slot == 9) {
        at (armstand) {
            return _chest_read_9(var, here);
        }
    } else if (slot == 10) {
        at (armstand) {
            return _chest_read_10(var, here);
        }
    } else if (slot == 11) {
        at (armstand) {
            return _chest_read_11(var, here);
        }
    } else if (slot == 12) {
        at (armstand) {
            return _chest_read_12(var, here);
        }
    } else if (slot == 13) {
        at (armstand) {
            return _chest_read_13(var, here);
        }
    } else if (slot == 14) {
        at (armstand) {
            return _chest_read_14(var, here);
        }
    } else if (slot == 15) {
        at (armstand) {
            return _chest_read_15(var, here);
        }
    } else if (slot == 16) {
        at (armstand) {
            return _chest_read_16(var, here);
        }
    } else if (slot == 17) {
        at (armstand) {
            return _chest_read_17(var, here);
        }
    } else
        return -1;
}

macro int _chest_read_18(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[18].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_19(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[19].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_20(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[20].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_21(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[21].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_22(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[22].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_23(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[23].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_24(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[24].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_25(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[25].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

macro int _chest_read_26(_NBT var, _IRType here) {
    int val = 0;
    ir (var, here) {
        nbt_modify_var_from $arg0, set, $arg1, "Items[26].Count"
    }
    ir (val, _IRType("nbtsubpath", var, "", "i32")) {
        $arg0 = $arg1
    }
    return val - 1;
}

int _chest_read_18_to_26(Entity armstand, int slot) {
    _NBT var();
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));
    if (slot == 18) {
        at (armstand) {
            return _chest_read_18(var, here);
        }
    } else if (slot == 19) {
        at (armstand) {
            return _chest_read_19(var, here);
        }
    } else if (slot == 20) {
        at (armstand) {
            return _chest_read_20(var, here);
        }
    } else if (slot == 21) {
        at (armstand) {
            return _chest_read_21(var, here);
        }
    } else if (slot == 22) {
        at (armstand) {
            return _chest_read_22(var, here);
        }
    } else if (slot == 23) {
        at (armstand) {
            return _chest_read_23(var, here);
        }
    } else if (slot == 24) {
        at (armstand) {
            return _chest_read_24(var, here);
        }
    } else if (slot == 25) {
        at (armstand) {
            return _chest_read_25(var, here);
        }
    } else if (slot == 26) {
        at (armstand) {
            return _chest_read_26(var, here);
        }
    } else
        return -1;
}

macro void _chest_write_0(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[0].Count", set, $arg1
    }
}

macro void _chest_write_1(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[1].Count", set, $arg1
    }
}

macro void _chest_write_2(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[2].Count", set, $arg1
    }
}

macro void _chest_write_3(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[3].Count", set, $arg1
    }
}

macro void _chest_write_4(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[4].Count", set, $arg1
    }
}

macro void _chest_write_5(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[5].Count", set, $arg1
    }
}

macro void _chest_write_6(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[6].Count", set, $arg1
    }
}

macro void _chest_write_7(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[7].Count", set, $arg1
    }
}

macro void _chest_write_8(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[8].Count", set, $arg1
    }
}

void _chest_write_0_to_8(Entity armstand, int slot, int val) {
    int store = val + 1;
    _NBT var();
    ir (_IRType("nbtsubpath", var, "", "i32"), store) {
        $arg0 = $arg1
    }
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));
    if (slot == 0) {
        at (armstand) {
            _chest_write_0(here, var);
        }
    } else if (slot == 1) {
        at (armstand) {
            _chest_write_1(here, var);
        }
    } else if (slot == 2) {
        at (armstand) {
            _chest_write_2(here, var);
        }
    } else if (slot == 3) {
        at (armstand) {
            _chest_write_3(here, var);
        }
    } else if (slot == 4) {
        at (armstand) {
            _chest_write_4(here, var);
        }
    } else if (slot == 5) {
        at (armstand) {
            _chest_write_5(here, var);
        }
    } else if (slot == 6) {
        at (armstand) {
            _chest_write_6(here, var);
        }
    } else if (slot == 7) {
        at (armstand) {
            _chest_write_7(here, var);
        }
    } else if (slot == 8) {
        at (armstand) {
            _chest_write_8(here, var);
        }
    }
}

macro void _chest_write_9(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[9].Count", set, $arg1
    }
}

macro void _chest_write_10(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[10].Count", set, $arg1
    }
}

macro void _chest_write_11(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[11].Count", set, $arg1
    }
}

macro void _chest_write_12(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[12].Count", set, $arg1
    }
}

macro void _chest_write_13(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[13].Count", set, $arg1
    }
}

macro void _chest_write_14(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[14].Count", set, $arg1
    }
}

macro void _chest_write_15(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[15].Count", set, $arg1
    }
}

macro void _chest_write_16(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[16].Count", set, $arg1
    }
}

macro void _chest_write_17(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[17].Count", set, $arg1
    }
}

void _chest_write_9_to_17(Entity armstand, int slot, int val) {
    int store = val + 1;
    _NBT var();
    ir (_IRType("nbtsubpath", var, "", "i32"), store) {
        $arg0 = $arg1
    }
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));
    if (slot == 9) {
        at (armstand) {
            _chest_write_9(here, var);
        }
    } else if (slot == 10) {
        at (armstand) {
            _chest_write_10(here, var);
        }
    } else if (slot == 11) {
        at (armstand) {
            _chest_write_11(here, var);
        }
    } else if (slot == 12) {
        at (armstand) {
            _chest_write_12(here, var);
        }
    } else if (slot == 13) {
        at (armstand) {
            _chest_write_13(here, var);
        }
    } else if (slot == 14) {
        at (armstand) {
            _chest_write_14(here, var);
        }
    } else if (slot == 15) {
        at (armstand) {
            _chest_write_15(here, var);
        }
    } else if (slot == 16) {
        at (armstand) {
            _chest_write_16(here, var);
        }
    } else if (slot == 17) {
        at (armstand) {
            _chest_write_17(here, var);
        }
    }
}

macro void _chest_write_18(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[18].Count", set, $arg1
    }
}

macro void _chest_write_19(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[19].Count", set, $arg1
    }
}

macro void _chest_write_20(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[20].Count", set, $arg1
    }
}

macro void _chest_write_21(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[21].Count", set, $arg1
    }
}

macro void _chest_write_22(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[22].Count", set, $arg1
    }
}

macro void _chest_write_23(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[23].Count", set, $arg1
    }
}

macro void _chest_write_24(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[24].Count", set, $arg1
    }
}

macro void _chest_write_25(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[25].Count", set, $arg1
    }
}

macro void _chest_write_26(_IRType here, _NBT var) {
    ir (here, var) {
        nbt_modify_from_var $arg0, "Items[26].Count", set, $arg1
    }
}

void _chest_write_18_to_26(Entity armstand, int slot, int val) {
    int store = val + 1;
    _NBT var();
    ir (_IRType("nbtsubpath", var, "", "i32"), store) {
        $arg0 = $arg1
    }
    _IRType here("block_pos", _IRType("rel_pos", 0), _IRType("rel_pos", 0), _IRType("rel_pos", 0));
    if (slot == 18) {
        at (armstand) {
            _chest_write_18(here, var);
        }
    } else if (slot == 19) {
        at (armstand) {
            _chest_write_19(here, var);
        }
    } else if (slot == 20) {
        at (armstand) {
            _chest_write_20(here, var);
        }
    } else if (slot == 21) {
        at (armstand) {
            _chest_write_21(here, var);
        }
    } else if (slot == 22) {
        at (armstand) {
            _chest_write_22(here, var);
        }
    } else if (slot == 23) {
        at (armstand) {
            _chest_write_23(here, var);
        }
    } else if (slot == 24) {
        at (armstand) {
            _chest_write_24(here, var);
        }
    } else if (slot == 25) {
        at (armstand) {
            _chest_write_25(here, var);
        }
    } else if (slot == 26) {
        at (armstand) {
            _chest_write_26(here, var);
        }
    }
}

macro int _chest_read(Entity armstand, int slot) {
    if (slot < 9) {
        return _chest_read_0_to_8(armstand, slot);
    } else if (slot < 18) {
        return _chest_read_9_to_17(armstand, slot);
    } else {
        return _chest_read_18_to_26(armstand, slot);
    }
}

macro void _chest_write(Entity armstand, int slot, int val) {
    if (slot < 9) {
        _chest_write_0_to_8(armstand, slot, val);
    } else if (slot < 18) {
        _chest_write_9_to_17(armstand, slot, val);
    } else {
        _chest_write_18_to_26(armstand, slot, val);
    }
}

int chest_flash_read(Entity armstand, vec3i flash_pos, vec3i flash_size, int addr) {
    int flash_slice = flash_size.x * flash_size.z * 27;
    if (addr < 0 || addr > (flash_slice * flash_size.y / 5 - 1)) {
        Text err;
        err << "chest[";
        err.append_ref(addr);
        err << "] -> (illegal op).";
        err.send_to_all();
        return -1;
    }
    armstand.pos = vec3d(0.0, 0.0, 0.0);
    int flash_row = flash_size.x * 27;
    int max_x = flash_size.x + flash_pos.x - 1;
    int max_y = flash_size.y + flash_pos.y - 1;
    int max_z = flash_size.z + flash_pos.z - 1;
    int slots = addr * 5;
    int y = (slots / flash_slice) + flash_pos.y;
    armstand.pos += vec3i(0, y, 0);
    int m = slots % flash_slice;
    int z = (m / flash_row) + flash_pos.z;
    armstand.pos += vec3i(0, 0, z);
    m = m % flash_row;
    int x = (m / 27) + flash_pos.x;
    armstand.pos += vec3i(x, 0, 0);
    m = m % 27;
    int byte = 0;
    int s;
    int slot_count;
    for (slot_count = 0; slot_count < 5; slot_count++) {
        s = _chest_read(armstand, m);
        if (s < 0) {
            Text err;
            err << "chest[";
            err.append_ref(addr);
            err << "] -> (cannot read).";
            err.send_to_all();
            return -1;
        }
        byte += s;
        m += 1;
        if (m > 26) {
            m = 0;
            x += 1;
            if (x > max_x) {
                x = flash_pos.x;
                z += 1;
                if (z > max_z) {
                    if (y + 1 > max_y)
                        break;
                    else {
                        armstand.pos += vec3i(0, 1, -flash_size.z);
                        z = flash_pos.z;
                        y += 1;
                    }
                }
                armstand.pos += vec3i(-flash_size.x, 0, 1);
            }
            armstand.pos += vec3i(1, 0, 0);
        }
    }
    if (byte > 0xff) {
        Text err;
        err << "chest[";
        err.append_ref(addr);
        err << "] -> (bad data).";
        err.send_to_all();
        return -1;
    }
    return byte;
}

void chest_flash_write(Entity armstand, vec3i flash_pos, vec3i flash_size, int addr, int val) {
    int flash_slice = flash_size.x * flash_size.z * 27;
    if (addr < 0 || addr > (flash_slice * flash_size.y / 5 - 1) || val < 0 || val > 0xff) {
        Text err;
        err << "chest[";
        err.append_ref(addr);
        err << "] = ";
        err.append_ref(val);
        err << " (illegal op).";
        err.send_to_all();
        return;
    }
    armstand.pos = vec3d(0.0, 0.0, 0.0);
    int flash_row = flash_size.x * 27;
    int max_x = flash_size.x + flash_pos.x - 1;
    int max_y = flash_size.y + flash_pos.y - 1;
    int max_z = flash_size.z + flash_pos.z - 1;
    int slots = addr * 5;
    int y = (slots / flash_slice) + flash_pos.y;
    armstand.pos += vec3i(0, y, 0);
    int m = slots % flash_slice;
    int z = (m / flash_row) + flash_pos.z;
    armstand.pos += vec3i(0, 0, z);
    m = m % flash_row;
    int x = (m / 27) + flash_pos.x;
    armstand.pos += vec3i(x, 0, 0);
    m = m % 27;
    int byte = val;
    int s;
    int slot_count;
    for (slot_count = 0; slot_count < 5; slot_count++) {
        if (byte > 63)
            s = 63;
        else
            s = byte;
        byte -= s;
        _chest_write(armstand, m, s);
        m += 1;
        if (m > 26) {
            m = 0;
            x += 1;
            if (x > max_x) {
                x = flash_pos.x;
                z += 1;
                if (z > max_z) {
                    if (y + 1 > max_y)
                        return;
                    else {
                        armstand.pos += vec3i(0, 1, -flash_size.z);
                        z = flash_pos.z;
                        y += 1;
                    }
                }
                armstand.pos += vec3i(-flash_size.x, 0, 1);
            }
            armstand.pos += vec3i(1, 0, 0);
        }
    }
}
