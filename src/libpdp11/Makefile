
#
# build rules
#

LIBPDP11_LDFLAGS := -shared
LIBPDP11_SRC_DIR = src/libpdp11

LIBPDP11_DPDFILE := $(LIBPDP11_SRC_DIR)/libpdp11.dpd
LIBPDP11_DATAPACK := $(BUILD_DIR)/libpdp11.zip

LIBPDP11_SRCS := $(shell find $(LIBPDP11_SRC_DIR) -maxdepth 1 -type f -name '*.c' -printf '%p\n')
LIBPDP11_OBJS := $(LIBPDP11_SRCS:%=$(BUILD_DIR)/%.o)

$(LIBPDP11_DATAPACK): $(LIBPDP11_OBJS)
		$(CC) $(LDFLAGS) $(LIBPDP11_LDFLAGS) $(LIBPDP11_OBJS) $(LIBPDP11_DPDFILE) -o $@
