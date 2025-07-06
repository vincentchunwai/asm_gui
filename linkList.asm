BITS 64
CPU x64

global start
extern VirtualAlloc
extern WriteFile
extern GetStdHandle
extern ExitProcess

struc node
    .value: resq 1
    .next: resq 1
endstruc

node_size equ 16

section .bss
    head: resq 1
    bytes_written: resq 1

section .data
    hello_string db "Hello, World!", 13, 10, 0
    string_len equ 15

section .text
default rel
start:
    ; Reserve shadow space for Windows calling convention
    sub rsp, 32
    
    ; Allocate memory for node
    mov rcx, 0          ; lpAddress
    mov rdx, node_size  ; dwSize
    mov r8, 0x3000      ; MEM_COMMIT | MEM_RESERVE
    mov r9, 0x4         ; PAGE_READWRITE
    call VirtualAlloc
    add rsp, 32
    
    test rax, rax
    jz allocation_failed
    mov [head], rax
    
    ; Initialize node
    lea rbx, [hello_string]
    mov [rax + node.value], rbx
    mov qword [rax + node.next], 0
    
    ; Get stdout handle
    sub rsp, 32
    mov rcx, -11
    call GetStdHandle
    add rsp, 32
    mov r8, rax
    
    ; Print from node
    mov rax, [head]
    mov rbx, [rax + node.value]
    
    sub rsp, 40  ; 32 for shadow space + 8 for 5th parameter
    mov rcx, r8  ; hFile (stdout handle)
    mov rdx, rbx ; lpBuffer (data to write)
    mov r8, string_len ; DWORD number of bytes to write
    lea r9, [bytes_written] ; LPDWORD pointer to bytes written
    mov qword [rsp + 32], 0  ; 5th parameter (overlapped)
    call WriteFile
    add rsp, 40
    
    ; Exit
    sub rsp, 32
    mov rcx, 0
    call ExitProcess

allocation_failed:
    sub rsp, 32
    mov rcx, 1
    call ExitProcess