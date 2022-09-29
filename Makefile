
#
# build rules
#

PREFIX ?= /usr
CC := $(PREFIX)/bin/mcc
CFLAGS := -O1
LDFLAGS := $(CFLAGS)

BUILD_DIR := build

include src/Makefile

clean:
		rm -rf $(BUILD_DIR)

.PHONY: clean all

$(BUILD_DIR)/%.c.o : %.c
		@ mkdir -p $(dir $@)
		$(CC) -c $(CFLAGS) $< -o $@
