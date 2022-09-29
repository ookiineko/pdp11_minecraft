
#
# build rules
#

PDP11_SRC_DIR = src

PDP11_DPDFILE := $(PDP11_SRC_DIR)/pdp11.dpd
PDP11_DATAPACK := $(BUILD_DIR)/pdp11.zip

PDP11_SRCS := $(shell find $(PDP11_SRC_DIR) -maxdepth 1 -type f -name '*.c' -printf '%p\n')
PDP11_OBJS := $(PDP11_SRCS:%=$(BUILD_DIR)/%.o)

all: $(PDP11_DATAPACK)

include src/libpdp11/Makefile

$(PDP11_DATAPACK): $(LIBPDP11_DATAPACK) $(PDP11_OBJS)
		$(CC) $(LDFLAGS) $(LIBPDP11_DATAPACK) $(PDP11_OBJS) $(PDP11_DPDFILE) -o $@
