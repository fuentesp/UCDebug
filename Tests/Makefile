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

all:  s001 s101 s201 s301 s401 s501 s601 s701 s801 s802 s803 mo001 mo002 mo101 mo102 mo201 mo202 mo301 mo302 mo401 mo402 r101 r102 r200 r201 r202 r203 r204 r205 r206 r301 r302

CC = ld -Ttext=18088

$(*:=.o): %.o
	$(CC) -o $(@) $(@.o)

#SWI tests
s001.o: SWI.001_exit_def/s
	as -o s001.o SWI.001_exit_def/s
s101.o: SWI.101_writec/s
	as -o s101.o SWI.101_writec/s
s201.o: SWI.201_write0/s
	as -o s201.o SWI.201_write0/s
s301.o: SWI.301_readc/s
	as -o s301.o SWI.301_readc/s
s401.o: SWI.401_enteros/s
	as -o s401.o SWI.401_enteros/s
s501.o: SWI.501_leaveos/s
	as -o s501.o SWI.501_leaveos/s
s601.o: SWI.601_convert_int/s
	as -o s601.o SWI.601_convert_int/s
s701.o: SWI.701_hardware/s
	as -o s701.o SWI.701_hardware/s
s801.o: SWI.801_claim_release/s
	as -o s801.o SWI.801_claim_release/s
s802.o: SWI.802_claim_without_release/s
	as -o s802.o SWI.802_claim_without_release/s
s803.o: SWI.803_release_without_claim/s
	as -o s803.o SWI.803_release_without_claim/s

#Mode tests
mo001.o: Modes.Enter.abt/s
	as -o mo001.o Modes.Enter.abt/s
mo002.o: Modes.Leave.abt/s
	as -o mo002.o Modes.Leave.abt/s
mo101.o: Modes.Enter.fiq/s
	as -o mo101.o Modes.Enter.fiq/s
mo102.o: Modes.Leave.fiq/s
	as -o mo102.o Modes.Leave.fiq/s
mo201.o: Modes.Enter.irq/s
	as -o mo201.o Modes.Enter.irq/s
mo202.o: Modes.Leave.irq/s
	as -o mo202.o Modes.Leave.irq/s
mo301.o: Modes.Enter.sys/s
	as -o mo301.o Modes.Enter.sys/s
mo302.o: Modes.Leave.sys/s
	as -o mo302.o Modes.Leave.sys/s
mo401.o: Modes.Enter.und/s
	as -o mo401.o Modes.Enter.und/s
mo402.o: Modes.Leave.und/s
	as -o mo402.o Modes.Leave.und/s

#Reset tests
r101.o: Reset.CPSR_Reset.modify_cpsr/s
	as -o r101.o Reset.CPSR_Reset.modify_cpsr/s
r102.o: Reset.CPSR_Reset.check_cpsr/s
	as -o r102.o Reset.CPSR_Reset.check_cpsr/s
r200.o: Reset.Mode_Reset.check_mode/s
	as -o r200.o Reset.Mode_Reset.check_mode/s
r201.o: Reset.Mode_Reset.sys/s
	as -o r201.o Reset.Mode_Reset.sys/s
r202.o: Reset.Mode_Reset.abt/s
	as -o r202.o Reset.Mode_Reset.abt/s
r203.o: Reset.Mode_Reset.svc/s
	as -o r203.o Reset.Mode_Reset.svc/s
r204.o: Reset.Mode_Reset.und/s
	as -o r204.o Reset.Mode_Reset.und/s
r205.o: Reset.Mode_Reset.irq/s
	as -o r205.o Reset.Mode_Reset.irq/s
r206.o: Reset.Mode_Reset.fiq/s
	as -o r206.o Reset.Mode_Reset.fiq/s
r301.o: Reset.Stack_Reset.modify_stacks/s
	as -o r301.o Reset.Stack_Reset.modify_stacks/s
r302.o: Reset.Stack_Reset.check_stacks/s
	as -o r302.o Reset.Stack_Reset.check_stacks/s

clean:
	wipe s*
	wipe mo*
	wipe r*
