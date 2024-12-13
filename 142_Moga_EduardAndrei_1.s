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
    startIntervalGET: .long 0
    sfarsitIntervalGET: .long 0
    afisare: .asciz "((%d, %d), (%d, %d))\n"
    afisareADD: .asciz "%d: ((%d, %d), (%d, %d))\n"
    startIntervalAfisare: .long 0
    sfarsitIntervalAfisare: .long 0
    finalInterval: .long 0
    ID: .long 0

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
    cmp $2, %edx
    je GET
    cmp $3, %edx
    je REMOVE
    cmp $4, %edx
    je DEFRAG

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
    add $24, %esp

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
    add $24, %esp

    xor %ecx, %ecx
    jmp ADD

GET:
    movl $0, startX
    movl $0, startY
    movl $0, endX
    movl $0, endY
    xor %eax, %eax
    xor %ebx, %ebx
    xor %ecx, %ecx
    xor %edx, %edx
    push $idFisier
    push $formatScanf
    call scanf  
    add $8, %esp
    movl idFisier, %eax
    xor %ecx, %ecx
    xor %ebx, %ebx
    jmp gasestePrimulID

gasestePrimulID:
    cmp $1048576, %ecx
    je eroare_GET
    movb (%edi, %ecx),%bl   
    cmpb %bl, %al
    je seteazaStartInterval
    inc %ecx
    jmp gasestePrimulID

eroare_GET:
    movl $0, startX
    movl $0, startY
    movl $0, endX
    movl $0, endY
    push endX
    push endY
    push startX
    push startY
    push $afisare
    call printf
    add $20, %esp
    xor %ecx, %ecx
    jmp parsareComenzi
    jmp afisare_GET

seteazaStartInterval:
    movl %ecx, startIntervalGET
    jmp parcurgereDrive
    parcurgereDrive:
    xor %ebx, %ebx
    movb (%edi, %ecx), %bl
    cmpb %bl, %al
    jne seteazaSfarsitInterval
    inc %ecx
    jmp parcurgereDrive

seteazaSfarsitInterval:
    sub $1, %ecx
    movl %ecx, sfarsitIntervalGET
    jmp afisare_GET
    
afisare_GET:
    xor %edx, %edx
    movl startIntervalGET, %eax
    divl dimensiuneLinie
    movl %eax, startY
    movl %edx, startX
    xor %edx, %edx
    movl sfarsitIntervalGET, %eax
    divl dimensiuneLinie
    movl %edx, endX
    movl %eax, endY
    xor %edx, %edx
    movl $0, %eax


    push endX
    push endY
    push startX
    push startY
    push $afisare
    call printf
    add $20, %esp
    xor %ecx, %ecx
    jmp parsareComenzi



REMOVE:
    movl $0, startX
    movl $0, startY
    movl $0, endX
    movl $0, endY
    push $idFisier
    push $formatScanf
    call scanf  
    add $8, %esp
    movl idFisier, %eax
    xor %ecx, %ecx
    xor %ebx, %ebx
    jmp gasestePrimulIDRemove

gasestePrimulIDRemove:
    movb (%edi, %ecx),%bl   
    cmpb %bl, %al
    je IncepRemove
    inc %ecx
    jmp gasestePrimulIDRemove

IncepRemove:
    xor %ebx, %ebx
    movb (%edi, %ecx), %bl
    cmpb %bl, %al
    jne afisareMemorieStart
    xor %ebx, %ebx
    movb %bl, (%edi, %ecx)
    inc %ecx
    jmp IncepRemove

afisareMemorieStart:
    xor %eax, %eax
    xor %ebx, %ebx
    xor %ecx, %ecx
    jmp et_startIntervalAfisare

et_startIntervalAfisare:
    cmp $1048576, %ecx
    je parsareComenzi
    mov $0, %eax
    movb (%edi, %ecx), %al
    cmp $0, %eax
    jne setStartInterval
    inc %ecx
    jmp et_startIntervalAfisare

setStartInterval:
    movl %eax, ID
    movl %ecx, startIntervalAfisare 
    jmp parcurgereInterval

parcurgereInterval:
    movb (%edi, %ecx) , %bl
    cmpb %al, %bl
    jne setFinInterval
    inc %ecx
    jmp parcurgereInterval

setFinInterval:
    dec %ecx
    movl %ecx, finalInterval
    jmp afisareInterval

afisareInterval:
    xor %edx, %edx
    movl startIntervalAfisare, %eax
    divl dimensiuneLinie
    movl %eax, startY
    movl %edx, startX
    xor %edx, %edx
    movl finalInterval, %eax
    divl dimensiuneLinie
    movl %edx, endX
    movl %eax, endY
    xor %edx, %edx
    movl $0, %eax

    push %ecx

    push endX
    push endY
    push startX
    push startY
    push ID
    push $afisareADD
    call printf
    add $24, %esp

    xor %ecx, %ecx

    pop %ecx
    inc %ecx
    jmp et_startIntervalAfisare

DEFRAG:
    jmp parsareComenzi
    # 2 variante
    # 1. iti iei un vector care retine {id1, dimensiune1, id2, dimensiune2, ...} si il bagi in alta matrice, apoi copiezi matricea auxiliara in aia principala
    # 2. parcurgi matricea element cu element si cand gasesti cv diferit retii dimensiunea si il bagi ca in add in matricea auxiliara (important atunci cand bagi un nou fisier este ca ecx sa fie ultima poz+1, nu 0)

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
