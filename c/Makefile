#
# Programmed: Serg Mashkin
#

PROJ = test

OUT = out/Release


WAV_DIR = wave
GSM_DIR = wave/gsmlib

DEFS += 
CFLAGS += -Wa
LFLAGS = -lm
CC = $(CROSS_COMPILE)gcc $(CFLAGS) $(DEFS)
LD = $(CROSS_COMPILE)gcc $(LFLAGS)

all: $(OUT)/$(PROJ)

OBJS =  $(OUT)/test.o \
        $(OUT)/noise_remover.o \
        $(OUT)/utilites.o

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJS:%.o=%.d)
endif

$(OUT)/%.o: %.c
	$(CC) -c $< -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o $@

$(OUT)/$(PROJ): $(OBJS) Makefile
	$(LD) $(OBJS)  -o $@

install romfs:
	$(ROMFSINST) -d out/Release/$(PROJ) /usr/bin/$(PROJ)

clean:
	rm -f out/Debug/*
	rm -f out/Release/*

.PHONY: all compile install romfs clean
