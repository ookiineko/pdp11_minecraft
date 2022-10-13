
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to CBL, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.

include "Events"
include "Game"
include "Entities"
include "Text"

include "include/intr"


////////////////////////////////////////////////////////////////

Maybe<Entity> helper_cons;

macro Maybe<Entity> _get_helper_cons() {
    return (filter (e in Game.entities) {
        e.has_tag("pdp11_cons_helper");
    }).first();
}

void get_helper_cons() {
    helper_cons = _get_helper_cons();
}

void kill_helper_cons() {
    if (!helper_cons.isEmpty())
        helper_cons.get().kill();
}

////////////////////////////////////////////////////////////////

int TKS = 0;
int TPS = 0;
int keybuf = 0;

void clearterminal() {

}

void writeterminal_Aa_Jj(Entity armstand, int code) {
    if (code == 65 || code == 97) { // A a
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 66 || code == 98) { // B b
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 67 || code == 99) { // C c
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"ms\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 68 || code == 100) { // D d
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 69 || code == 101) { // E e
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 70 || code == 102) { // F f
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ms\",Color:15},{Pattern:\"rs\",Color:0},{Pattern:\"ts\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 71 || code == 103) { // G g
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"hh\",Color:0},{Pattern:\"bs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 72 || code == 104) { // H h
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:black_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:0},{Pattern:\"bs\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 73 || code == 105) { // I i
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"cs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else { // (code == 74 || code == 106) J j
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"hh\",Color:0},{Pattern:\"bs\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void writeterminal_Kk_Tt(Entity armstand, int code) {
    if (code == 75 || code == 107) { // K k
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"drs\",Color:15},{Pattern:\"hh\",Color:0},{Pattern:\"dls\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 76 || code == 108) { // L l
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 77 || code == 109) { // M m
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"tt\",Color:15},{Pattern:\"tts\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 78 || code == 110) { // N n
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"tt\",Color:0},{Pattern:\"drs\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 79 || code == 111) { // O o
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 80 || code == 112) { // P p
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"hhb\",Color:0},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 81 || code == 113) { // Q q
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:black_wall_banner[facing=west]{Patterns:[{Pattern:\"mr\",Color:0},{Pattern:\"rs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"br\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 82 || code == 114) { // R r
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"hh\",Color:15},{Pattern:\"cs\",Color:0},{Pattern:\"ts\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"drs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 83 || code == 115) { // S s
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:black_wall_banner[facing=west]{Patterns:[{Pattern:\"mr\",Color:0},{Pattern:\"ms\",Color:0},{Pattern:\"drs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else { // (code == 84 || code == 116) T t
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"cs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void writeterminal_Uu_Zz(Entity armstand, int code) {
    if (code == 85 || code == 117) { // U u
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 86 || code == 118) { // V v
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"dls\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"bt\",Color:0},{Pattern:\"dls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 87 || code == 119) { // W w
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bt\",Color:15},{Pattern:\"bts\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 88 || code == 120) { // X x
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"cr\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 89 || code == 121) { // Y y
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"drs\",Color:15},{Pattern:\"hhb\",Color:0},{Pattern:\"dls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else { // (code == 90 || code == 122) { Z z
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"dls\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void writeterminal(int msg) {
    if (helper_cons.isEmpty()) {
        Text err;
        err << "writetermnial(";
        err.append_ref(msg);
        err << ") (missing helper).";
        err.send_to_all();
        return;
    }
    Entity armstand = helper_cons.get();
    if ((msg > 64 && msg < 91) || (msg > 96 && msg < 123)) { // alphabets
        if (msg < 75 || (msg > 96 && msg < 107)) // Aa..Jj
            writeterminal_Aa_Jj(armstand, msg);
        else if (msg < 85 || (msg > 106 && msg < 117)) // Kk..Tt
            writeterminal_Kk_Tt(armstand, msg);
        else // Uu..Zz
            writeterminal_Uu_Zz(armstand, msg);
    } else {
        Text err;
        err << "writeterminal(";
        err.append_ref(msg);
        err << ") (not implmented).";
        err.send_to_all();
    }
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
