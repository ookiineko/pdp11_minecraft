
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
include "include/mem"
include "include/traps"
include "include/disasm"
include "include/bootrom"


type Interrupts {
        int vec[8];
        int pri[8];
        int intr_count;

        constructor();
        Maybe<Interrupt> get(int idx);
        void insert(int idx, Interrupt intr);
        Maybe<Interrupt> pop(int idx);
}

Interrupts::constructor() {
    this.intr_count = 0;
}

Maybe<Interrupt> Interrupts::get(int idx) {
    if (idx < 0 || idx >= this.intr_count) {
        Text err;
        err << "Interrupts::get(";
        err.append_ref(idx);
        err << ") invalid index";
        err.send_to_all();
    } else
        return Interrupt(this.vec[idx], this.pri[idx]);
}

void Interrupts::insert(int idx, Interrupt intr) {
    if (idx < 0 || idx > this.intr_count || this.intr_count >= 8) {
        Text err;
        err << "Interrupts::get(";
        err.append_ref(idx);
        err << ") invalid index or list is full";
        err.send_to_all();
        return;
    }
    int i;
    for (i = this.intr_count - 1; i >= idx; i--) {
        this.vec[i + 1] = this.vec[i];
        this.pri[i + 1] = this.pri[i];
    }
    this.vec[idx] = intr.vec;
    this.pri[idx] = intr.pri;
    this.intr_count++;
}

Maybe<Interrupt> Interrupts::pop(int idx) {
    Maybe<Interrupt> ret = this.get(idx);
    if (ret.isEmpty()) {
        Text err;
        err << "Interrupts::pop(";
        err.append_ref(idx);
        err << ") get() failed";
        err.send_to_all();
    } else {
        int i;
        for (i = idx; i < this.intr_count - 1; i++) {
            this.vec[i] = this.vec[i + 1];
            this.pri[i] = this.pri[i + 1];
        }
        this.intr_count--;
        return ret;
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
