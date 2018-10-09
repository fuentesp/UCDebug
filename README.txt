!UCDebug, ARM debugger for RISC OS.
Copyright (C) 2018  University of Cantabria.

!UCDebug is an ARM debugger with a window-based interface that allows to run codes in a 
controlled manner, displaying the behavior and changes in the register set and memory. A
simple list of commands (and their syntax) can be found by typying "help" at the 
Console window of the debugger.

!UCDebug runs in a Raspberry Pi 1B+ under version 5.24 of RISC OS (released on 
16-April-2018). A working copy of the application is provided for ease of use. In order 
to compile, you need to run the  "compile" Obey file. !UCDebug has been compiled with GCC4
and requires OSLib and C shared libraries in order to compile (all available in the 
!Packman package manager). Depending on the medium employed to copy the files to the
Raspberry Pi, it may be necessary to set the file type for certain files (!Run as 'Obey',
!RunImage as 'ELF', !Sprites and !Sprites22 as 'Sprite').

!UCDebug works with ELF-format executables, and needs them to be linked to address 0x18000.
To obtain a !UCDebug-compatible executable from an assembly code, run the following lines:
	as -o file.o file.s
	ld -Ttext=18088 exec file.o

!UCDebug supports the use of VFPv2 floating-point instructions. To assemble an ARM source
code that uses these instructions, the [-mfpu=vfpv2] option needs to be used with the 'as'
command.

