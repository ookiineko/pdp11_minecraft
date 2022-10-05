
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.

include "Events"
include "Game"
include "Text"

include "include/intr"
include "include/traps"


int TKS = 0;
int TPS = 0;
int keybuf = 0;

void clearterminal() {

}

void writeterminal(int &msg) {

}

void addchar(int c) {

}

void specialchar(int c) {

}

int getchar() {

}

int consread16(int a) {

}

void conswrite16(int a, int v) {

}
