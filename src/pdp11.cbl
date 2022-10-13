
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
include "include/helper"
include "include/mem"
include "include/disasm"


////////////////////////////////////////////////////////////////

type Interrupt {
        int vec;
        int pri;

        constructor(int vec, int pri) {
            this.vec = vec;
            this.pri = pri;
        }
}

type Interrupts {
        Array vec;
        Array pri;

        constructor() {
            this.vec = Array();
            this.pri = Array();
        }
        Maybe<Interrupt> operator [](int idx);
        void insert(int idx, Interrupt intr);
        Maybe<Interrupt> pop(int idx);
}

Maybe<Interrupt> Interrupts::operator [](int idx) {
    Maybe<int> vec = this.vec[idx];
    Maybe<int> pri = this.pri[idx];
    if (vec.isEmpty() || pri.isEmpty()) {
        Text err;
        err << "Interrupts::get(";
        err.append_ref(idx);
        err << ") -> (array error).";
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
        err << ") (get() failed).";
        err.send_to_all();
    } else {
        this.vec.pop(idx);
        this.pri.pop(idx);
        return ret.get();
    }
}

////////////////

type Page {
    int par;
    int pdr;
    int addr;
    int len;
    int read; // bool
    int write; // bool
    int ed; // bool

    constructor(int par, int pdr, int addr, int len, int read, int write, int ed) {
        this.par = par;
        this.pdr = pdr;
        this.addr = addr;
        this.len = len;
        this.read = read;
        this.write = write;
        this.ed = ed;
    }
}

type Pages {
    int par[16];
    int pdr[16];
    int addr[16];
    int len[16];
    int read[16];
    int write[16];
    int ed[16];

    Maybe<Page> operator [](int idx) {
        if (idx > 0 && idx < 16) {
            int par = this.par[idx];
            int pdr = this.pdr[idx];
            int addr = this.addr[idx];
            int len = this.len[idx];
            int read = this.read[idx];
            int write = this.write[idx];
            int ed = this.ed[idx];
            Page page(par, pdr, addr, len, read, write, ed);
            return page;
        } else {
            Text err;
            err << "Pages::get(";
            err.append_ref(idx);
            err << ") -> (index error).";
            err.send_to_all();
        }
    }

    void set(int idx, Page page) {
        int par = page.par;
        int pdr = page.pdr;
        int addr = page.addr;
        int len = page.len;
        int read = page.read;
        int write = page.write;
        int ed = page.ed;
        if (idx > 0 && idx < 16) {
            this.par[idx] = par;
            this.pdr[idx] = pdr;
            this.addr[idx] = addr;
            this.len[idx] = len;
            this.read[idx] = read;
            this.write[idx] = write;
            this.ed[idx] = ed;
        } else {
            Text err;
            err << "Pages::set(";
            err.append_ref(idx);
            err << ", Page(";
            err.append_ref(par);
            err << ", ";
            err.append_ref(pdr);
            err << ", ";
            err.append_ref(addr);
            err << ", ";
            err.append_ref(len);
            err << ", ";
            err.append_ref(read);
            err << ", ";
            err.append_ref(write);
            err << ", ";
            err.append_ref(ed);
            err << ")) -> (index error).";
            err.send_to_all();
        }
    }
}

////////////////////////////////////////////////////////////////

int pr = 0;
int R[8](0, 0, 0, 0, 0, 0, 0, 0); // registers
int KSP; // kernel stack pointer
int USP; // user stack pointer
int PS; // processor status
int curPC; // address of current instruction
int ips;
int SR0;
int SR2;
int curuser; // bool
int prevuser; // bool
int LKS;
int clkcounter;
int waiting = 0; // boool
Interrupts interrupts;
Pages pages;




int bootrom[29](
    0042113,                        /* "KD" */
    0012706, 02000,                 /* MOV #boot_start, SP */
    0012700, 0000000,               /* MOV #unit, R0        ; unit number */
    0010003,                        /* MOV R0, R3 */
    0000303,                        /* SWAB R3 */
    0006303,                        /* ASL R3 */
    0006303,                        /* ASL R3 */
    0006303,                        /* ASL R3 */
    0006303,                        /* ASL R3 */
    0006303,                        /* ASL R3 */
    0012701, 0177412,               /* MOV #RKDA, R1        ; csr */
    0010311,                        /* MOV R3, (R1)         ; load da */
    0005041,                        /* CLR -(R1)            ; clear ba */
    0012741, 0177000,               /* MOV #-256.*2, -(R1)  ; load wc */
    0012741, 0000005,               /* MOV #READ+GO, -(R1)  ; read & go */
    0005002,                        /* CLR R2 */
    0005003,                        /* CLR R3 */
    0012704, 02020,                 /* MOV #START+20, R4 */
    0005005,                        /* CLR R5 */
    0105711,                        /* TSTB (R1) */
    0100376,                        /* BPL .-2 */
    0105011,                        /* CLRB (R1) */
    0005007                         /* CLR PC */
);

void switchmode(int newm /*bool*/) {

}

int physread16(int addr) {

}

int physread8(int addr) {

}

void physwrite8(int addr, int val) {

}

void physwrite16(int addr, int val) {

}

int decode(int addr, int w /*bool*/, int m) {

}

Page createpage(int par, int pdr) {
    int addr = par & 07777;
    int len = (pdr >> 8) & 0x7F;
    int read; // bool
    int write; // bool
    int ed; // bool
    if ((pdr & 2) == 2)
        read = 1;
    else
        read = 0;
    if ((pdr & 6) == 6)
        write = 1;
    else
        write = 0;
    if ((pdr & 8) == 8)
        ed = 1;
    else
        ed = 0;
    return Page(par, pdr, addr, len, read, write, ed);
}

int mmuread16(int addr) {

}

void mmuwrite16(int addr, int val) {

}

int read8(int addr) {

}

int read16(int addr) {

}

void write8(int addr, int val) {

}

void write16(int addr, int val) {

}

int fetch16() {

}

void push(int val) {

}

void pop(int val) {

}

void printstate() {

}

void interrupt(int vec, int pri) {

}

void handleinterrupt(int vec) {

}

macro void trapat(int vec, string msg) {

}

int aget(int v, int l) {

}

void memread(int a, int v, int l) {

}

void branch(int o) {

}

void step() {

}

void reset() {

}

void nsteps(int n) {

}

void run() {

}

void stop() {

}

////////////////////////////////////////////////////////////////

// call this once before running anything
void init() {
    raw_command("execute unless entity @e[tag=pdp11_cons_helper,limit=1] run summon armor_stand 0 1 0 {Tags:[\"pdp11_cons_helper\"],ArmorItems:[{id:\"minecraft:stone\",Count:1b}],NoAI:1b,Invisible:1b,Small:0b,NoGravity:1b,Marker:1b,Invulnerable:1b,NoBasePlate:1b}");
    raw_command("execute unless entity @e[tag=pdp11_mem_helper,limit=1] run summon armor_stand 0 1 0 {Tags:[\"pdp11_mem_helper\"],ArmorItems:[{id:\"minecraft:stone\",Count:1b}],NoAI:1b,Invisible:1b,Small:0b,NoGravity:1b,Marker:1b,Invulnerable:1b,NoBasePlate:1b}");
    raw_command("execute unless entity @e[tag=pdp11_rk05_helper,limit=1] run summon armor_stand 0 1 0 {Tags:[\"pdp11_rk05_helper\"],ArmorItems:[{id:\"minecraft:stone\",Count:1b}],NoAI:1b,Invisible:1b,Small:0b,NoGravity:1b,Marker:1b,Invulnerable:1b,NoBasePlate:1b}");
    get_helper_cons();
    get_helper_mem();
    get_helper_rk05();
    // TODO: port IPS and RK busy indicators
    reset();
    rkreset();
}

// call this before calling cleanup
void cleanup_before() {
    kill_helper_cons();
    kill_helper_mem();
    kill_helper_rk05();
}

////////////////////////////////////////////////////////////////
