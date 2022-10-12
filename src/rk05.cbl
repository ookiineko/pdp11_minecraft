
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.

include "Events"
include "Game"
include "Entities"
include "Text"

include "include/chest"
include "include/intr"
include "include/mem"


////////////////////////////////////////////////////////////////

macro vec3i _get_disk_pos() {
    return vec3i(-43, 124, -43);
}

macro vec3i _get_disk_size() {
    return vec3i(55, 128, 55);
}

int _disk_read(Entity armstand, int addr) {
    vec3i disk_pos = _get_disk_pos();
    vec3i disk_size = _get_disk_size();
    return chest_flash_read(armstand, disk_pos, disk_size, addr);
}

void _disk_write(Entity armstand, int addr, int val) {
    vec3i disk_pos = _get_disk_pos();
    vec3i disk_size = _get_disk_size();
    chest_flash_write(armstand, disk_pos, disk_size, addr, val);
}

////////////////////////////////////////////////////////////////

int RKDS;
int RKER;
int RKCS;
int RKWC;
int RKBA;
int drive;
int sector;
int surface;
int cylinder;


int rkread16(int addr) {

}

void rknotready() {

}

void rkready() {

}

void rkerror(int code) {

}

void rkrwsec(int t) {

}

void rkgo() {

}

int rkwrite16(int addr, int val) {

}

void rkreset() {

}

void rkinit() {

}
