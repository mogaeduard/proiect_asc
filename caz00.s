.data
    d: .space 1024
    nrComenzi: .space 4
    comanda: .space 4
    formatScanf: .asciz "%d"
    afisareADD: .asciz "%d: (%d, %d)\n"
    comenziExecutate: .space 4

.text
.global main
main:
    lea d, %edi
    xor %ecx, %ecx
    jmp zero

zero:
    cmp $1024, %ecx
    jge citireNrComenzi
    movb $0, (%edi, %ecx)
    inc %ecx
    jmp zero

citireNrComenzi:
    push $nrComenzi
    push $formatScanf
    call scanf
    add $8, %esp
    xor %ecx, %ecx
    jmp parsareComenzi

parsareComenzi:
    cmpl %ecx, nrComenzi
    je et_exit
    inc %ecx
    xor %edx, %edx

    push %ecx
    push $comanda
    push $formatScanf
    call scanf
    add $8, %esp
    pop %ecx

    movl comanda, %edx
    cmp $1, %edx
    je ADD
    cmp $2, %edx
    je GET
    cmp $3, %edx
    je REMOVE
    jmp DEFRAG

ADD:
    jmp parsareComenzi

GET:
    jmp parsareComenzi

REMOVE:
    jmp parsareComenzi

DEFRAG:
    jmp parsareComenzi

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
