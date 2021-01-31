gvimfullscreen.dll: gvimfullscreen.c
	cl /LD user32.lib Gdi32.lib legacy_stdio_definitions.lib gvimfullscreen.c

clean:
	del *.obj
	del *.dll
	del *.exp
	del *.lib
