# asm_gui

linking

```console
nasm -f win64 main2.nasm -o main2.obj
x86_64-w64-mingw32-gcc -nostdlib "-Wl,--subsystem,console" "-Wl,-e,_start" main2.obj -lkernel32 -o main2.exe