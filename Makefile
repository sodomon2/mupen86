#Makefile MUPEN64 for Linux

# 2016.03.03 modified from official Mupen64 package to build only the core image

CC		=gcc
CXX		=g++

#CFLAGS		=-DX86 -O3 -Wall -DEMU64_DEBUG
CFLAGS		=-DX86 -O3 -fexpensive-optimizations -fomit-frame-pointer -funroll-loops -ffast-math -fno-strict-aliasing -msse2 -Wall -pipe
#CFLAGS		=-DX86 -O3 -msse2 -Wall -g -pg
#CFLAGS		=-DX86 -Wall -pipe -g3 -DEMU64_DEBUG
#CFLAGS		=-DX86 -Wall -pipe -g -DEMU64_DEBUG -DCOMPARE_CORE
#CFLAGS		=-DX86 -Wall -pipe -g

LBITS := $(shell getconf LONG_BIT)
ifeq ($(LBITS),32)
CFLAGS += -DHAVE_RECOMPILER
endif

CXXFLAGS	=$(CFLAGS)

GL_PATH		=-I/usr/X11R6/include

OBJ		=main/rom.o \
		r4300/r4300.o \
		r4300/cop0.o \
		r4300/special.o \
		r4300/regimm.o \
		r4300/exception.o \
		memory/tlb.o \
		memory/memory.o \
		memory/dma.o \
		r4300/interupt.o \
		r4300/cop1.o \
		r4300/tlb.o \
		r4300/cop1_w.o \
		r4300/cop1_s.o \
		r4300/cop1_d.o \
		r4300/recomp.o \
		memory/pif.o \
		r4300/bc.o \
		r4300/cop1_l.o \
		r4300/pure_interp.o \
		r4300/compare_core.o \
		main/plugin.o \
		main/unzip.o \
		main/ioapi.o \
		memory/flashram.o \
		main/md5.o \
		main/mupenIniApi.o \
		main/savestates.o \
		r4300/profile.o \
		main/adler32.o

OBJ_X86         =r4300/x86/gr4300.o \
		r4300/x86/gcop0.o \
		r4300/x86/assemble.o \
		r4300/x86/gcop1.o \
		r4300/x86/gcop1_s.o \
		r4300/x86/gcop1_d.o \
		r4300/x86/gtlb.o \
		r4300/x86/gregimm.o \
		r4300/x86/gspecial.o \
		r4300/x86/gcop1_w.o \
		r4300/x86/debug.o \
		r4300/x86/rjump.o \
		r4300/x86/gbc.o \
		r4300/x86/gcop1_l.o \
		r4300/x86/regcache.o

OBJ_VCR		=main/vcr.o \
		main/vcr_compress.o \
		main/vcr_resample.o \
		main/gui_gtk/vcrcomp_dialog.o

OBJ_GTK_GUI	=main/gui_gtk/main_gtk.o \
		main/gui_gtk/translate.o \
		main/gui_gtk/messagebox.o \
		main/gui_gtk/aboutdialog.o \
		main/gui_gtk/configdialog.o \
		main/gui_gtk/support.o \
		main/gui_gtk/rombrowser.o \
		main/gui_gtk/romproperties.o \
		main/gui_gtk/config.o \
		main/gui_gtk/dirbrowser.o

OBJ_INPUT	=mupen64_input/main.o

OBJ_BLIGHT	=blight_input/plugin.o \
		blight_input/SDL_ttf.o \
		blight_input/arial.ttf.o \
		blight_input/configdialog_sdl.o \
		blight_input/pad.o

OBJ_RSPHLE	=rsp_hle/main.o \
		rsp_hle/disasm.o \
		rsp_hle/jpeg.o \
		rsp_hle/ucode3.o \
		rsp_hle/ucode2.o \
		rsp_hle/ucode1.o \
		rsp_hle/ucode3mp3.o

OBJ_DUMMY	=dummy_audio/audio.o

OBJ_AUDIO	=mupen64_audio/main.o

OBJ_JTTL	=jttl_audio/main.o

OBJ_SOFT_GFX	=mupen64_soft_gfx/main.o \
		mupen64_soft_gfx/rsp.o \
		mupen64_soft_gfx/vi_SDL.o \
		mupen64_soft_gfx/vi.o \
		mupen64_soft_gfx/rdp.o \
		mupen64_soft_gfx/tx.o \
		mupen64_soft_gfx/rs.o \
		mupen64_soft_gfx/tf.o \
		mupen64_soft_gfx/cc.o \
		mupen64_soft_gfx/bl.o

OBJ_GLN64	=glN64/glN64.o \
		glN64/Config_linux.o \
		glN64/OpenGL.o \
		glN64/N64.o \
		glN64/RSP.o \
		glN64/VI.o \
		glN64/Textures.o \
		glN64/FrameBuffer.o \
		glN64/Combiner.o \
		glN64/gDP.o \
		glN64/gSP.o \
		glN64/GBI.o \
		glN64/DepthBuffer.o \
		glN64/CRC.o \
		glN64/2xSAI.o \
		glN64/NV_register_combiners.o \
		glN64/texture_env.o \
		glN64/texture_env_combine.o \
		glN64/RDP.o \
		glN64/F3D.o \
		glN64/F3DEX.o \
		glN64/F3DEX2.o \
		glN64/L3D.o \
		glN64/L3DEX.o \
		glN64/L3DEX2.o \
		glN64/S2DEX.o \
		glN64/S2DEX2.o \
		glN64/F3DPD.o \
		glN64/F3DDKR.o \
		glN64/F3DWRUS.o

HEADER		=main/rom.h \
		r4300/r4300.h \
		r4300/ops.h \
		r4300/macros.h \
		r4300/exception.h \
		memory/memory.h \
		memory/tlb.h \
		memory/dma.h \
		r4300/interupt.h \
		r4300/recomp.h \
		memory/pif.h

LIB		=-lz -lm

ifneq ("$(shell grep GTK2 config.h)","\#define GTK2_SUPPORT 1")
GTK_FLAGS	=`gtk-config --cflags`
GTK_LIBS	=`gtk-config --libs`
GTHREAD_LIBS	=`gtk-config --libs gtk gthread`
else
GTK_FLAGS	=`pkg-config gtk+-2.0 --cflags` -D_GTK2
GTK_LIBS	=`pkg-config gtk+-2.0 --libs`
GTHREAD_LIBS	=`pkg-config gthread-2.0 --libs`
endif

PREFIX		=$(shell grep WITH_HOME config.h | cut -d '"' -f 2)
SHARE		="$(PREFIX)share/mupen64/"

all:	mupen64 mupen64_nogui

r4300/interupt.o:	r4300/interupt.c
			$(CC) $(CFLAGS) `sdl-config --cflags` -c -o $@ $<

main/main.o:	main/main.c
		$(CC) $(CFLAGS) -c -o $@ $< `sdl-config --cflags`

main/main_gtk.o:	main/main_gtk.c
			$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS) `sdl-config --cflags`

main/gui_gtk/main_gtk.o:	main/gui_gtk/main_gtk.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS) `sdl-config --cflags`

main/gui_gtk/translate.o:	main/gui_gtk/translate.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/messagebox.o:	main/gui_gtk/messagebox.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/aboutdialog.o:	main/gui_gtk/aboutdialog.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/configdialog.o:	main/gui_gtk/configdialog.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/support.o:		main/gui_gtk/support.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/rombrowser.o:	main/gui_gtk/rombrowser.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/romproperties.o:	main/gui_gtk/romproperties.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/config.o:		main/gui_gtk/config.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/dirbrowser.o:	main/gui_gtk/dirbrowser.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/gui_gtk/vcrcomp_dialog.o:	main/gui_gtk/vcrcomp_dialog.c
				$(CC) $(CFLAGS) -c -o $@ $< $(GTK_FLAGS)

main/vcr_compress.o:		main/vcr_compress.cpp
				$(CXX) $(CXXFLAGS) -c -o $@ $< `avifile-config --cflags`

mupen64_nogui:	$(OBJ) $(OBJ_X86) main/main.o main/gui_gtk/config.o
		$(CC) $^ $(LIB) -Wl,-export-dynamic -L/usr/X11R6/lib `sdl-config --libs` -lGL -lpthread -ldl -o $@
		strip --strip-all $@

ifneq ("$(shell grep VCR config.h)","\#define VCR_SUPPORT 1")

mupen64:	$(OBJ) $(OBJ_X86) $(OBJ_GTK_GUI)
		$(CC) $^ $(CFLAGS) $(LIB) -Wl,-export-dynamic $(GTK_LIBS) -L/usr/X11R6/lib `sdl-config --libs` -lGL -lpthread -ldl -o $@
		strip --strip-all $@

else

mupen64:	$(OBJ) $(OBJ_X86) $(OBJ_GTK_GUI) $(OBJ_VCR)
		$(CXX) $^ $(CFLAGS) $(LIB) -Wl,-export-dynamic $(GTK_LIBS) `avifile-config --libs` `sdl-config --libs` -L/usr/X11R6/lib -lGL -lpthread -ldl -o $@
		strip --strip-all $@
endif

mupen64_oldgui:	$(OBJ) $(OBJ_X86) main/main_gtk.o
		$(CC) $^ $(LIB) -Wl,-export-dynamic $(GTK_LIBS) `sdl-config --libs` -L/usr/X11R6/lib -lGL -lpthread -ldl -o $@
		strip --strip-all $@

plugins/mupen64_input.so: $(OBJ_INPUT)
			  $(CC) $^ -Wl,-Bsymbolic -shared $(GTK_LIBS) -o $@
			  strip --strip-all $@

plugins/blight_input.so: $(OBJ_BLIGHT)
			 $(CC) $^ -Wl,-Bsymbolic -shared `sdl-config --libs` `freetype-config --libs` -o $@
			 strip --strip-all $@

plugins/mupen64_hle_rsp_azimer.so: $(OBJ_RSPHLE)
				   $(CXX) $^ -Wl,-Bsymbolic -shared $(GTK_LIBS) -o $@
				   strip --strip-all $@

plugins/dummyaudio.so:	$(OBJ_DUMMY)
			$(CC) $^ -Wl,-Bsymbolic -shared -o $@
			strip --strip-all $@

plugins/mupen64_audio.so:	$(OBJ_AUDIO)
				$(CC) $(GTK_LIBS) -lpthread $^ -Wl,-Bsymbolic -shared -o $@
				strip --strip-all $@

plugins/jttl_audio.so:	$(OBJ_JTTL)
			$(CC) $^ -Wl,-Bsymbolic -shared `sdl-config --libs` $(GTK_LIBS) -o $@
			strip --strip-all $@

plugins/mupen64_soft_gfx.so:	$(OBJ_SOFT_GFX)
				$(CXX) `sdl-config --libs` $^ -Wl,-Bsymbolic -shared -o $@
				strip --strip-all $@

plugins/glN64.so:	$(OBJ_GLN64)
			$(CXX) $^ -Wl,-Bsymbolic -shared $(GTK_LIBS) $(GTHREAD_LIBS) `sdl-config --libs` -lGL -o $@
			strip --strip-all $@

install:
	cp mupen64 "$(PREFIX)bin"
	cp mupen64_nogui "$(PREFIX)bin"
	mkdir "$(SHARE)" | echo
	cp -rv mupen64.ini "$(SHARE)"
	cp -rv lang "$(SHARE)"
	cp -rv plugins "$(SHARE)"
	cp -rv doc "$(SHARE)"
	
clean:
	find . -name '*.o' -print0 | xargs -0r rm -f
#	rm mupen64 mupen64_nogui mupen64_dbg # Normally _dbg is not built, so cleaning it is an error.
	rm mupen64 mupen64_nogui

clean_o:
	find . -name '*.o' -print0 | xargs -0r rm -f

clean_jed:
	find . -name '*~' -print0 | xargs -0r rm -f

gprof:
	gprof mupen64_nogui > stat.txt
