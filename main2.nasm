BITS 64
CPU x64

global _start
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess

section .data
message: db "Hello, World!", 13, 0, 0 ; Windows-style newline and null terminator
message_len equ $ - message ; Length of the message

section .text
_start:

    ; Get handle to stdout
    mov rcx, -11         ; STD_OUTPUT_HANDLE (-11)
    call GetStdHandle
    mov r8, rax         ; Store the handle in r8

    ; Write to console
    mov rcx, r8         ; Console handle
    mov rdx, message    ; Buffer to write
    mov r8, message_len     ; Number of bytes to write
    mov r9, 0           ; Character written
    push 0              ; Reserved parameter
    call WriteConsoleA  ; 
    add rsp, 8          ; Clean up the stack

    ; Exit the program
    mov rcx, 0
    call ExitProcess    ; Exit code

