
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.


include "Text"
include "Game"
include "Entities"

include "include/chest"


////////////////////////////////////////////////////////////////

Maybe<Entity> helper_mem;

macro Maybe<Entity> _get_helper_mem() {
    return (filter (e in Game.entities) {
        e.has_tag("pdp11_mem_helper");
    }).first();
}

void get_helper_mem() {
    helper_mem = _get_helper_mem();
}

void kill_helper_mem() {
    if (!helper_mem.isEmpty())
        helper_mem.get().kill();
}

macro vec3i _get_mem_pos() {
    return vec3i(15, 124, 15);
}

macro vec3i _get_mem_size() {
    return vec3i(28, 128, 28);
}

int mem_read(int addr) {
    if (helper_mem.isEmpty()) {
        Text err;
        err << "mem_read(";
        err.append_ref(addr);
        err << ") -> (missing helper).";
        err.send_to_all();
        return -1;
    }
    vec3i mem_pos = _get_mem_pos();
    vec3i mem_size = _get_mem_size();
    return chest_flash_read(helper_mem.get(), mem_pos, mem_size, addr);
}

void mem_write(int addr, int val) {
    if (helper_mem.isEmpty()) {
        Text err;
        err << "mem_write(";
        err.append_ref(addr);
        err << ", ";
        err.append_ref(val);
        err << ") (missing helper).";
        err.send_to_all();
        return;
    }
    vec3i mem_pos = _get_mem_pos();
    vec3i mem_size = _get_mem_size();
    chest_flash_write(helper_mem.get(), mem_pos, mem_size, addr, val);
}

////////////////////////////////////////////////////////////////
