TINYCCPATH = $(shell readlink -f tinycc)
RAYLIBPATH = $(shell readlink -f raylib)

export PATH := $(TINYCCPATH):$(PATH)
export C_INCLUDE_PATH := $(TINYCCPATH):$(TINYCCPATH)/include:$(RAYLIBPATH)/src:$(C_INCLUDE_PATH)
export LIBRARY_PATH := $(TINYCCPATH):$(RAYLIBPATH)/src:$(RAYLIBPATH)/src/external:$(LIBRARY_PATH)
export LD_LIBRARY_PATH := $(RAYLIBPATH)/src:$(LD_LIBRARY_PATH)

CCFLAGS = -Wall -std=c99 -D_DEFAULT_SOURCE -Wno-missing-braces -Wunused-result -O2 -DPLATFORM_DESKTOP
LDFLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -ltcc

.PHONY: replace-gcc-tcc tcc raylib raylib-examples setup
replace-gcc-tcc :
	sed -i -e 's/CC = gcc/CC = tcc/g' -e "s/AR = ar/AR = tcc -ar/g" raylib/src/Makefile raylib/examples/Makefile

tcc :
	cd $(TINYCCPATH) && $(MAKE)

raylib : replace-gcc-tcc tcc
	cd $(RAYLIBPATH)/src && $(MAKE) PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED

raylib-examples : raylib
	sed -i -e 's/LDLIBS += -latomic/# LDLIBS += -latomic/' raylib/examples/Makefile
	cd $(RAYLIBPATH)/examples && $(MAKE) PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED

core_2d_camera_platformer : core_2d_camera_platformer.c
	echo $(C_INCLUDE_PATH)
	tcc -o $@ $< $(CCFLAGS) $(LDFLAGS)

setup : raylib

run : core_2d_camera_platformer
	./core_2d_camera_platformer ./target.c
