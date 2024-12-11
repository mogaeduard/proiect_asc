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
    sfarsitInterval: .long 0
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
    movl nrComenziAddExecutate, %ecx
    xor %ecx, %ecx
    movl %ecx, nrComenziAddExecutate
    jmp ADD

ADD:
    movl $0, startX
    movl $0, startY
    movl $0, endX
    movl $0, endY
    movl nrComenziAddExecutate, %ebx
    cmpl %ebx, nrComenziAdd
    je parsareComenzi
    inc %ebx
    movl %ebx, nrComenziAddExecutate

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
    movl %eax, dimensiuneFisier
    xor %ebx, %ebx
    xor %edx, %edx
    jmp cautSpatiuLiber

incrementareEcx:
    inc %ecx
    jmp cautSpatiuLiber

cautSpatiuLiber:
    cmpl $1048576, %ecx
    movl $0, startX
    movl $0, endX
    jge ADD_eroare
    movl $0, %eax
    cmpb (%edi, %ecx), %al
    je retinemPrimulZero
    inc %ecx
    jmp cautSpatiuLiber

retinemPrimulZero:

    mov %ecx, %eax
    xor %edx, %edx
    divl dimensiuneLinie
    movl %eax, startY
    movl $0, %eax
    movl %ecx, startX
    inc %ecx
    jmp ZeroDisponibil

ZeroDisponibil:
    movl $0, %eax
    cmpb (%edi, %ecx), %al
    
    jne verificareADD
    inc %ecx
    jmp ZeroDisponibil

verificareADD:
    xor %ebx, %ebx
    movl %ecx, %ebx
    subl startX, %ebx
    cmpl dimensiuneFisier, %ebx
    jge calculareFinalInterval
    jmp incrementareEcx

calculareFinalInterval:
    xor %ebx, %ebx
    movl dimensiuneFisier, %edx
    addl startX, %edx
    dec %edx
    movl %edx, sfarsitInterval
    xor %edx, %edx
    cmpl $1048576, %edx
    jge ADD_eroare
    jmp verificareLinie

verificareLinie:
    movl sfarsitInterval, %eax
    xor %edx, %edx
    divl dimensiuneLinie
    movl %edx, endX
    cmpl linieCurenta, %eax
    je adaugareInMemorie
    movl %eax, linieCurenta
    mull dimensiuneLinie
    mov %eax, %ecx
    xor %edx, %edx
    jmp cautSpatiuLiber

adaugareInMemorie:
    movl startX, %ecx
    mov idFisier, %eax
    movl endX, %edx
    cmpl $1024, %edx
    jge ADD_eroare
    xor %edx, %edx
    jmp adaugareInMemorieContinuare

adaugareInMemorieContinuare:
    cmpl $1048576, %ecx
    je ADD_eroare
    movb %al, (%edi,%ecx)
    cmpl sfarsitInterval,%ecx
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
    push startY
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
    movl %edx, startX
    xor %edx, %edx
    movl sfarsitInterval, %eax
    divl dimensiuneLinie
    movl %edx, endX
    movl %eax, endY
    xor %edx, %edx
    movl $0, %eax

    push endX
    push endY
    push startX
    push startY
    push idFisier
    push $afisareADD
    call printf
    add $20, %esp


    xor %ecx, %ecx
    jmp ADD

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
