# !UCDebug, ARM debugger for RISC OS.
# https://github.com/fuentesp/UCDebug
# Copyright (C) 2018  University of Cantabria
#
# !UCDebug was developed by the Computer Architecture and Technology
# Group at the University of Cantabria. A comprehensive list of authors
# can be found in the file AUTHORS.txt.
#
# You can reach the main developers at {fernando.vallejo, cristobal.camarero,
# pablo.fuentes}@unican.es.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

.PHONY: all clean

all: !UCDebug/!RunImage

FLAGS=-O2

HEADERS=CodeWin.h ConsWin.h DataWin.h FPRegsWin.h ibar.h Interpreter.h main.h RegsWin.h

ib.o: ibar.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o ib.o ibar.c

CWin.o: CodeWin.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o CWin.o CodeWin.c

DWin.o: DataWin.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o DWin.o DataWin.c

RWin.o: RegsWin.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o RWin.o RegsWin.c

FPWin.o: FPRegsWin.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o FPWin.o FPRegsWin.c

CoWin.o: ConsWin.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o CoWin.o ConsWin.c

In.o: Interpreter.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o In.o Interpreter.c

Dbg.o: Debug.c $(HEADERS)
	gcc $(FLAGS) -mfpu=vfp -c -IOSLib: -o Dbg.o Debug.c

Exec.o: ExecMod.s
	as -mfpu=vfpv2 -o Exec.o ExecMod.s

Hand.o:	Handler.s
	as -mfpu=vfpv2 -o Hand.o Handler.s

Aux.o:	Aux.s
	as -mfpu=vfpv2 -o Aux.o Aux.s

!UCDebug/!RunImage: ib.o CWin.o DWin.o RWin.o FPWin.o CoWin.o In.o Dbg.o Exec.o Hand.o Aux.o
	gcc -Wl,--no-warn-mismatch -mfpu=vfp -LOSLib: -lOSLib32 -o !UCDebug/!RunImage Dbg.o ib.o CoWin.o CWin.o DWin.o RWin.o FPWin.o In.o Exec.o Hand.o Aux.o

clean:
	remove !UCDebug.!RunImage
	remove o.Exec
	remove o.Hand
	remove o.Aux
	remove o.Dbg
	remove o.In
	remove o.CoWin
	remove o.FPWin
	remove o.RWin
	remove o.DWin
	remove o.CWin
	remove o.ib
