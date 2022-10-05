
#
# build rules
#

SRC_DIR := src

DPDFILE := $(SRC_DIR)/proj.dpd
DATAPACK := $(BUILD_DIR)/datapack.zip

SRCS := $(shell find $(SRC_DIR) -maxdepth 1 -type f -name '*.cbl' -printf '%p\n')
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

$(DATAPACK): $(OBJS)
		$(CC) $(LDFLAGS) $(OBJS) $(DPDFILE) -o $@
