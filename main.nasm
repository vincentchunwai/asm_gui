BITS 64
CPU x64

section .data
    msg db "Hello, World!", 0          ; The message to print
    msg_len equ $ - msg                ; Length of the message

section .bss
    hConsole resq 1                    ; Handle for the console

section .text
    global mainCRTStartup
    extern ExitProcess
    extern GetStdHandle
    extern WriteConsoleA

mainCRTStartup:
    xor rax, rax                       ; Clear rax

    ; Get the console handle
    mov rcx, -11                       ; STD_OUTPUT_HANDLE (-11)
    call GetStdHandle                  ; Get handle for stdout
    mov [rel hConsole], rax            ; Store the handle using RIP-relative addressing

    ; Call WriteConsoleA to print the message
    mov rcx, [rel hConsole]            ; Load the handle using RIP-relative addressing
    lea rdx, [rel msg]                 ; Load the address of the message
    mov r8, msg_len                    ; Load the length of the message
    xor r9, r9                         ; No special flags (NULL)
    call WriteConsoleA                 ; Write the message to the console

    ; Exit the program
    xor rcx, rcx                       ; Set exit code to 0
    call ExitProcess                   ; Exit the program