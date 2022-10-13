
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

int cursor_y;
int cursor_z;

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

macro vec3d _get_cons_pos() {
    return vec3d(14.0, 15.0, -16.0);
}

macro vec3i _get_cons_posi() {
    return vec3i(14, 15, -16);
}

macro vec3i _get_cons_size() {
    return vec3i(1, 16, 32);
}

////////////////////////////////////////////////////////////////

int TKS = 0;
int TPS = 0;
int keybuf = 0;

void clearterminal() {
    vec3d pos = _get_cons_pos();
    vec3i posi = _get_cons_posi();
    if (helper_cons.isEmpty()) {
        Text err;
        err << "clearterminal() (missing helper).";
        err.send_to_all();
        return;
    }
    Entity armstand = helper_cons.get();
    armstand.pos = pos;
    cursor_y = posi.y;
    cursor_z = posi.z;
    raw_command("fill 14 0 -16 14 15 15 minecraft:air"); // clear TTY text
    ////////////////////////////////
    TKS = 0;
    TPS = 128; // 1 << 7
}

void write_terminal_punc_p0(Entity armstand, int code) {
    if (code == 33) { // !
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"cs\",Color:15},{Pattern:\"ms\",Color:0},{Pattern:\"bo\",Color:0},{Pattern:\"bs\",Color:0}]}");
        }
    } else if (code == 34) { // "
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"tr\",Color:15},{Pattern:\"tl\",Color:15},{Pattern:\"cs\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 35) { // #
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"cr\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"sc\",Color:0},{Pattern:\"cs\",Color:0},{Pattern:\"pig\",Color:15},{Pattern:\"ss\",Color:0},{Pattern:\"bs\",Color:0},{Pattern:\"ts\",Color:0}]}");
        }
    } else if (code == 36) { // $
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"drs\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"bo\",Color:0},{Pattern:\"cs\",Color:0},{Pattern:\"cs\",Color:0},{Pattern:\"cs\",Color:15}]}");
        }
    } else if (code == 37) { // %
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"tl\",Color:15},{Pattern:\"br\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"mr\",Color:0},{Pattern:\"dls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 38) { // &
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"cr\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"br\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 39) { // '
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"ls\",Color:0},{Pattern:\"rs\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 40) { // (
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"drs\",Color:15},{Pattern:\"dls\",Color:15},{Pattern:\"vh\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 41) { // )
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"drs\",Color:15},{Pattern:\"dls\",Color:15},{Pattern:\"vhr\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else { // (code == 42) *
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"cr\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:0},{Pattern:\"bs\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void write_terminal_punc_p1(Entity armstand, int code) {
    if (code == 43) { // +
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"sc\",Color:15},{Pattern:\"bo\",Color:0},{Pattern:\"ts\",Color:0},{Pattern:\"bs\",Color:0}]}");
        }
    } else if (code == 44) { // ,
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"bts\",Color:0},{Pattern:\"cs\",Color:0},{Pattern:\"vhr\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 45) { // -
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ms\",Color:15},{Pattern:\"hhb\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 46) { // .
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bl\",Color:15},{Pattern:\"bo\",Color:0},{Pattern:\"ms\",Color:0},{Pattern:\"cs\",Color:0}]}");
        }
    } else { // (code == 47) /
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"dls\",Color:15},{Pattern:\"ld\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void write_terminal_0_9(Entity armstand, int code) {
    if (code == 48) { // 0
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"dls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 49) { // 1
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"cs\",Color:15},{Pattern:\"tl\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"bs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 50) { // 2
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"bs\",Color:15},{Pattern:\"dls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 51) { // 3
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 52) { // 4
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"hhb\",Color:0},{Pattern:\"rs\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 53) { // 5
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"ts\",Color:15},{Pattern:\"drs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 54) { // 6
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"hh\",Color:0},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 55) { // 7
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"dls\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 56) { // 8
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else { // (code == 57) 9
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"hhb\",Color:0},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"rs\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void write_terminal_punc_p2(Entity armstand, int code) {
    if (code == 58) { // :
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"tl\",Color:15},{Pattern:\"bl\",Color:15},{Pattern:\"bo\",Color:0},{Pattern:\"cs\",Color:0}]}");
        }
    } else if (code == 59) { // ;
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"tl\",Color:15},{Pattern:\"bts\",Color:0},{Pattern:\"cs\",Color:0},{Pattern:\"vhr\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 60) { // <
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"dls\",Color:15},{Pattern:\"drs\",Color:15},{Pattern:\"lud\",Color:0},{Pattern:\"ld\",Color:0},{Pattern:\"cbo\",Color:0}]}");
        }
    } else if (code == 61) { // =
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:black_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:0},{Pattern:\"bs\",Color:0},{Pattern:\"ms\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 62) { // >
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"dls\",Color:15},{Pattern:\"drs\",Color:15},{Pattern:\"rud\",Color:0},{Pattern:\"rd\",Color:0},{Pattern:\"cbo\",Color:0}]}");
        }
    } else if (code == 63) { // ?
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"dls\",Color:15},{Pattern:\"bs\",Color:0},{Pattern:\"bts\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"cbo\",Color:0},{Pattern:\"cbo\",Color:0}]}");
        }
    } else { // (code == 64) @
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"ts\",Color:0},{Pattern:\"bs\",Color:0},{Pattern:\"tts\",Color:15},{Pattern:\"bts\",Color:15},{Pattern:\"cs\",Color:0},{Pattern:\"cs\",Color:0},{Pattern:\"moj\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void writeterminal_Aa_Jj(Entity armstand, int code) {
    if (code == 65 || code == 97) { // A a
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"ls\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 66 || code == 98) { // B b
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:black_wall_banner[facing=west]{Patterns:[{Pattern:\"mr\",Color:0},{Pattern:\"rs\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"vh\",Color:15},{Pattern:\"ms\",Color:15},{Pattern:\"bo\",Color:0}]}");
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

void write_terminal_punc_p3(Entity armstand, int code) {
    if (code == 91) { // [
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ls\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"vhr\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 92) { // backslash
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"drs\",Color:15},{Pattern:\"rud\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 93) { // ]
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rs\",Color:15},{Pattern:\"ts\",Color:15},{Pattern:\"bs\",Color:15},{Pattern:\"vh\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 94) { // ^
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"mr\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 96) { // _
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"bs\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"bts\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else { // (code == 96) `
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"tl\",Color:15},{Pattern:\"lud\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    }
}

void write_terminal_punc_p4(Entity armstand, int code) {
    if (code == 123) { // {
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ld\",Color:15},{Pattern:\"lud\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"ls\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"bo\",Color:0},{Pattern:\"vhr\",Color:0}]}");
        }
    } else if (code == 124) { // |
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"sc\",Color:15},{Pattern:\"ls\",Color:0},{Pattern:\"rs\",Color:0},{Pattern:\"ss\",Color:0},{Pattern:\"ss\",Color:0},{Pattern:\"bo\",Color:0}]}");
        }
    } else if (code == 125) { // }
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"rud\",Color:15},{Pattern:\"rd\",Color:15},{Pattern:\"mr\",Color:0},{Pattern:\"rs\",Color:15},{Pattern:\"cbo\",Color:0},{Pattern:\"bo\",Color:0},{Pattern:\"vh\",Color:0}]}");
        }
    } else { // (code == 126) ~
        at (armstand) {
            raw_command("setblock ~ ~ ~ minecraft:white_wall_banner[facing=west]{Patterns:[{Pattern:\"ts\",Color:15},{Pattern:\"tts\",Color:0},{Pattern:\"flo\",Color:0}]}");
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
    if (msg < 32) // non-visible chars
        return;
    else if (msg == 32) { // space
        // do nothing
    } else if (msg < 43) // punctuations
        write_terminal_punc_p0(armstand, msg); // !..*
    else if (msg < 48) // punctuations
        write_terminal_punc_p1(armstand, msg); // +../
    else if (msg < 58) // numbers
        write_terminal_0_9(armstand, msg);  // 0..9
    else if (msg < 65) // punctuations
        write_terminal_punc_p2(armstand, msg); // :..@
    else if ( msg < 91) { // uppercase alphabets
        if (msg < 75) // A..J
            writeterminal_Aa_Jj(armstand, msg);
        else if (msg < 85) // K..T
            writeterminal_Kk_Tt(armstand, msg);
        else // U..Z
            writeterminal_Uu_Zz(armstand, msg);
    } else if (msg < 97) { // punctuations
        write_terminal_punc_p3(armstand, msg); // [..`
    } else if (msg < 123) { // lowercase alphabets
        if (msg < 107) // a..j
            writeterminal_Aa_Jj(armstand, msg);
        else if (msg < 117) // k..t
            writeterminal_Kk_Tt(armstand, msg);
        else // u..z
            writeterminal_Uu_Zz(armstand, msg);
    } else if (msg < 127) { // punctuations
        write_terminal_punc_p4(armstand, msg); // {..~
    } else {
        Text err;
        err << "writeterminal(";
        err.append_ref(msg);
        err << ") (non-ASCII).";
        err.send_to_all();
        return;
    }
    vec3i posi = _get_cons_posi();
    vec3i size = _get_cons_size();
    int max_z = posi.z + size.z - 1;
    int low_y = posi.y - size.y + 1;
    cursor_z += 1;
    if (cursor_z > max_z) {
        cursor_z = posi.z;
        if (cursor_y - 1 < low_y) {
            raw_command("clone 14 0 -16 14 14 15 14 1 -16");
            raw_command("fill 14 0 -16 14 0 15 minecraft:air");
        } else {
            cursor_y -= 1;
            armstand.pos += (0, -1, 0);
        }
        armstand.pos += (0, 0, -size.z);
    }
    armstand.pos += vec3i(0, 0, 1);
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
