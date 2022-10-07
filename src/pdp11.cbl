
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.

include "Events"
include "Game"
include "Text"

include "include/rk05"
include "include/cons"
include "include/intr"
include "include/array"
include "include/mem"
include "include/traps"
include "include/disasm"
include "include/bootrom"


type Interrupts {
        Array vec;
        Array pri;

        constructor();
        Maybe<Interrupt> operator [](int idx);
        void insert(int idx, Interrupt intr);
        Maybe<Interrupt> pop(int idx);
}

Interrupts::constructor() {
    this.vec = Array();
    this.pri = Array();
}

Maybe<Interrupt> Interrupts::operator [](int idx) {
    Maybe<int> vec = this.vec[idx];
    Maybe<int> pri = this.pri[idx];
    if (vec.isEmpty() || pri.isEmpty()) {
        Text err;
        err << "Interrupts::get(";
        err.append_ref(idx);
        err << ") -> array error.";
        err.send_to_all();
    } else
        return Interrupt(vec.get(), pri.get());
}

void Interrupts::insert(int idx, Interrupt intr) {
    this.vec.insert(idx, intr.vec);
    this.pri.insert(idx, intr.pri);
}

Maybe<Interrupt> Interrupts::pop(int idx) {
    Maybe<Interrupt> ret = this[idx];
    if (ret.isEmpty()) {
        Text err;
        err << "Interrupts::pop(";
        err.append_ref(idx);
        err << ") get() failed.";
        err.send_to_all();
    } else {
        this.vec.pop(idx);
        this.pri.pop(idx);
        return ret.get();
    }
}

Interrupts interrupts;

void interrupt(Interrupt intr) {

}

void run() {

}

void reset() {

}

void stop() {

}
