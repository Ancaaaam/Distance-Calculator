%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global road
    extern printf

road:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]      ; points
    mov ecx, [ebp + 12]     ; len
    mov ebx, [ebp + 16]     ; distances
    xor edx,edx
    ;;in edx punem pozitia la care ne aflam in eax

calculate:
    ;;in ecx se afla coorodonata x a elem cu indicele edx din eax
    ;;in ebx se afla coordonata x a elem de dupa ecx
    movzx ecx, word [eax+edx*point_size]
    movzx ebx, word [eax+edx*point_size+point_size]
    cmp ecx,ebx
    je make_distance_y
    jmp make_distance_x

;;diferenta dintre coordonatele x
make_distance_x:
    cmp ecx,ebx
    jl ebx_ecx
    sub ecx,ebx
    ;;repunem in ebx vectorul de distante ca sa adaugam ecx
    mov  ebx, [ebp + 16]
    mov dword [ebx+edx*4], ecx
    jmp test_end

;;diferenta dintre coordonatele y
make_distance_y:
    movzx ecx, word [eax+edx*point_size+point.y]
    movzx ebx, word [eax+edx*point_size+point_size+point.y]
    cmp ecx,ebx
    jl ebx_ecx
    sub ecx,ebx
    mov  ebx, [ebp + 16]
    mov dword [ebx+edx*4], ecx
    jmp test_end

;;diferenta dintre ebx si ecx si adaugare in vectorul de distante
ebx_ecx:
    sub ebx,ecx
    mov ecx,ebx
    mov ebx, [ebp + 16]
    mov dword [ebx+edx*4], ecx
    jmp test_end

test_end:
   add edx,1
   mov ecx, [ebp+12]
   sub ecx,edx
   cmp ecx,1
   je finish
   mov ecx, [ebp+12]
   inc ecx
   loop calculate

;;se termina programul
finish:
    ;;nothing here

    popa
    leave
    ret
