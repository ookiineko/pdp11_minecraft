
#
# build rules
#

PREFIX ?= /usr
CC := $(PREFIX)/bin/mcc
CFLAGS := -O1
LDFLAGS := $(CFLAGS)

BUILD_DIR := build

include src/Makefile

all: $(DATAPACK)

clean:
		rm -rf $(BUILD_DIR)

.PHONY: clean all

$(BUILD_DIR)/%.cbl.o : %.cbl
		@ mkdir -p $(dir $@)
		$(CC) -c $(CFLAGS) $< -o $@
