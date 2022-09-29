
// This is a translation of Julius Schmidt's PDP-11 emulator in JavaScript.
// You can run that one in your browser: http://pdp11.aiju.de
// (c) 2011, Julius Schmidt, JavaScript implementation, MIT License
// (c) 2022, Ookiineko, ported to C, MIT License
// Version 6 Unix (in the disk image) is available under the four-clause BSD license.

#include <stddef.h>
#include <stdbool.h>
#include <stdio.h>

#include "../include/traps.h"
