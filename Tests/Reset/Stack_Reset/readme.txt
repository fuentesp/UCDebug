Los programas modify_stacks y check_stacks componen un unico test.
Para realizar el test debemos ejecutar primero el programa modify_stacks y despues check_stacks (sin cerrar el depurador o cargar otro programa en medio).
El primer programa modifica los stacks de los modos supervisor, abort, undefined, interrupt y fast interrupt, y termina sin restaurar sus valores iniciales.
El segundo programa comprueba que los stacks de los modos previamente modificados en el programa anterior han recuperado su valor por defecto tras cargar un nuevo programa.
En caso de que el segundo programa detecte que alguno de los stacks no se ha reseteado imprimira por pantalla un mensaje de error especificando el primer stack que ha detectado que no ha retomado su valor por defecto.
