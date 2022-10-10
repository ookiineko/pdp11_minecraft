
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.


include "Entities"

include "include/chest"


macro vec3i _get_mem_pos() {
    return vec3i(8, 124, -8);
}

macro vec3i _get_mem_size() {
    return vec3i(28, 128, 28);
}

int mem_read(Entity armstand, int addr) {
    vec3i mem_pos = _get_mem_pos();
    vec3i mem_size = _get_mem_size();
    return chest_flash_read(armstand, mem_pos, mem_size, addr);
}

void mem_write(Entity armstand, int addr, int val) {
    vec3i mem_pos = _get_mem_pos();
    vec3i mem_size = _get_mem_size();
    chest_flash_write(armstand, mem_pos, mem_size, addr, val);
}
