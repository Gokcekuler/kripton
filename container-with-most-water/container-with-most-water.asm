
; How to compile
; $ nasm -f elf64 file.asm && ld -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 \
; /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o file.o \
; /usr/lib/x86_64-linux-gnu/crtn.o -lc -o file

        extern printf

        SECTION .data
container:
        dq 1,3,44,2,44
container_lenght:
        dq 5

        SECTION .rodata
fmt:
        db "%d", 10, 0

        SECTION	.text

        global main
main:

        push rbp                       ; save rbp to stack (before function call)

        mov rdi, container
        mov rsi, [container_lenght]
        call max_area

        lea rdi, fmt                   ; first parameter of printf (format string)
        mov rsi, rax            ; second parameter of printf (first array item)
        xor rax, rax                   ; 0 xmm register used (assign 0 to rax)
        call printf                    ; Call printf C function
        pop rbp                        ; load rbp from stack after using printf

        xor rax, rax                   ; return with exit code 0
        ret


max_area:
        push rbp

        xor rax, rax             ; max = 0
        xor rdx, rdx                  ; left_index = 0
        dec rsi                 ; right_index

loop:
        mov rcx, qword [container+rdx*8]

        cmp rcx, [container+rsi*8]
        jl lesser

greater:
        mov rcx, qword [container+rsi*8]

        push rsi
        sub rsi, rdx
        imul rcx, rsi
        pop rsi

        dec rsi
        jmp possible_max

lesser:
        push rsi
        sub rsi, rdx
        imul rcx, rsi
        pop rsi

        inc rdx

possible_max:
        cmp rax, rcx
        jg continue

        mov rax, rcx
continue:


        cmp rdx, rsi
        jl loop

        pop rbp
        ret
