# exec: first.o
CC = gcc

default: create

create:
	nasm -f win32 test.asm -o test.obj
	golink /fo test.exe test.obj /console kernel32.dll Msvcrt.dll
	test.exe "hallo"

clean:
	del *.o
	del *.exe

complete: 
	nasm -f win32 test.asm -o test.obj
	gcc test.obj -o test.exe
	test.exe