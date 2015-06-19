#########################################
# Makefile for free-nross test programm #
#                                       #
# (c) Sergei Mashkin, 2015              #
#########################################

PROJ = free-nross

CROSS_COMPILE = 
OUT     = out
HEADERS =
CFLAGS  = -O0 -Wall -Werror
DEFS    = 

CFLAGS += -I.\
          -Iwave\
          -Iwave/gsmlib \
          -include "wave/gsmlib/_config.h"

LFLAGS = 

CC = $(CROSS_COMPILE)gcc $(CFLAGS) $(DEFS)
LD = $(CROSS_COMPILE)gcc $(LFLAGS)

all: $(OUT)/$(PROJ)

GSMLIB_OBJS = $(OUT)/code.o \
	$(OUT)/debug.o \
	$(OUT)/decode.o \
	$(OUT)/gsmadd.o \
	$(OUT)/gsm_create.o \
	$(OUT)/gsm_decode.o \
	$(OUT)/gsm_destroy.o \
	$(OUT)/gsm_encode.o \
	$(OUT)/gsm_explode.o \
	$(OUT)/gsm_implode.o \
	$(OUT)/gsm_option.o \
	$(OUT)/gsm_print.o \
	$(OUT)/long_term.o \
	$(OUT)/lpc.o \
	$(OUT)/preprocess.o \
	$(OUT)/rpe.o \
	$(OUT)/short_term.o \
	$(OUT)/table.o

WAVE_OBJS = $(GSMLIB_OBJS) \
	$(OUT)/g711super.o \
	$(OUT)/mylog.o \
	$(OUT)/wave.o

OBJS = $(WAVE_OBJS) \
	$(OUT)/noise_remover.o \
	$(OUT)/test.o

VPATH := wave wave/gsmlib

$(OUT)/%.o: %.c $(HEADERS)
	$(CC) -g -c $< -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o $@

$(OUT)/$(PROJ): $(OBJS) Makefile
	$(LD) $(OBJS) -o $@

clean:
	rm -f $(OUT)/*

.PHONY: all compile clean
