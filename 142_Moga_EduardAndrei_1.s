.data
    d: .space 1048576
    nrComenzi: .space 4
    comanda: .space 4
    formatScanf: .asciz "%ld"
    comenziParsate: .long 0
    nrComenziAdd: .space 4
    nrComenziAddExecutate: .long 0
    idFisier: .space 4
    dimensiuneFisier: .space 4
    startX: .long 0
    startY: .long 0
    endX: .long 0
    endY: .long 0
    linieCurenta: .long 0
    dimensiuneLinie: .long 1024
    pozitieCurenta: .long 0
    afisareADD: .asciz "%d: ((%d, %d), (%d, %d))\n"

.text
.global main

main:
    lea d, %edi
    xor %ecx, %ecx
    jmp initMat

initMat:
    cmp $1048576, %ecx
    jge citireNrComenzi
    movb $0, (%edi, %ecx)
    inc %ecx
    jmp initMat

citireNrComenzi:
    push $nrComenzi
    push $formatScanf
    call scanf
    add $8, %esp
    xor %ecx, %ecx
    jmp parsareComenzi

parsareComenzi:
    movl comenziParsate, %ecx
    cmpl %ecx, nrComenzi
    je et_exit
    inc %ecx
    movl %ecx, comenziParsate
    xor %edx, %edx
    push $comanda
    push $formatScanf
    call scanf
    add $8, %esp
    movl comanda, %edx
    cmp $1, %edx
    je citireNrComenziADD

citireNrComenziADD:
    push $nrComenziAdd
    push $formatScanf
    call scanf
    add $8, %esp
    jmp ADD

ADD:
    movl $0, startX
    movl $0, startY
    movl $0, endX
    movl $0, endY
    movl nrComenziAddExecutate, %ecx
    cmpl %ecx, nrComenziAdd
    je parsareComenzi
    inc %ecx
    movl %ecx, nrComenziAddExecutate
    push $idFisier
    push $formatScanf
    call scanf
    add $8, %esp
    push $dimensiuneFisier
    push $formatScanf
    call scanf
    add $8, %esp
    jmp blocuriNecesare

blocuriNecesare:
    xor %ebx, %ebx
    xor %edx, %edx
    mov dimensiuneFisier, %eax
    mov $8, %ebx
    div %ebx
    cmp $0, %edx
    je rest0
    add $1, %eax
rest0:
    mov %eax, dimensiuneFisier
    xor %ebx, %ebx
    xor %edx, %edx
    
    jmp cautSpatiuLiber

cautSpatiuLiber:
    cmpl $1048576, %ecx
    jge ADD_eroare
    movl %ecx, pozitieCurenta
    movl pozitieCurenta, %eax
    xor %edx, %edx
    divl dimensiuneLinie
    movl %eax, linieCurenta
    xor %eax, %eax
    movb (%edi, %ecx), %al
    cmpb $0, %al
    je retinemPrimulZero
    inc %ecx
    jmp cautSpatiuLiber

retinemPrimulZero:
    movl %ecx, startX
    movl linieCurenta, %ecx
    movl startX, %ecx
    inc %ecx
    jmp ZeroDisponibil

ZeroDisponibil:
    xor %eax, %eax
    cmpl $1048576, %ecx
    jge ADD_eroare
    movb (%edi, %ecx), %al
    cmpb $0, %al
    je verificareADD
    inc %ecx
    jmp ZeroDisponibil

verificareADD:
    movl %ecx, %ebx
    sub startX, %ebx
    inc %ebx
    cmpl dimensiuneFisier, %ebx
    movl %ecx, endX
    je verificareLinie
    inc %ecx
    jmp ZeroDisponibil

verificareLinie:
    movl endX, %eax
    xor %edx, %edx
    divl dimensiuneLinie
    movl %eax, endY
    cmpl linieCurenta, %eax
    je adaugareInMemorie
    mull dimensiuneLinie
    mov %eax, %ecx
    jmp cautSpatiuLiber


adaugareInMemorie:
    movl startX, %ecx
    movl dimensiuneFisier, %edx
    addl startX, %edx
    sub $1, %edx
    movl %edx, endX
    xor %edx, %edx
    mov idFisier, %eax
    jmp adaugareInMemorieContinuare

adaugareInMemorieContinuare:
    cmpl $1048576, %ecx
    je ADD_eroare
    movb %al, (%edi,%ecx)
    cmpl endX,%ecx
    je et_afisareADD
    inc %ecx
    jmp adaugareInMemorieContinuare

ADD_eroare:
    movl $0, startX
    movl $0, startY
    movl $0, endX
    movl $0, endY
    jmp eroare_afisareADD

eroare_afisareADD:
    push endY
    push endX
    push startY
    push startX
    push idFisier
    push $afisareADD
    call printf
    add $20, %esp
    jmp ADD

et_afisareADD:
    xor %edx, %edx
    movl startX, %eax
    divl dimensiuneLinie
    movl %eax, startY
    movl %eax, endY
    movl %edx, startX
    xor %edx, %edx
    movl endX, %eax
    divl dimensiuneLinie
    movl %edx, endX
    xor %edx, %edx
    xor %eax, %eax

    push endX
    push endY
    push startX
    push startY
    push idFisier
    push $afisareADD
    call printf
    add $20, %esp
    movl endX, %ecx
    inc %ecx
    jmp ADD

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
