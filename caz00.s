.data
    d: .space 1024
    nrComenzi: .space 4
    comanda: .space 4
    formatScanf: .asciz "%ld"
    afisareADD: .asciz "%d: (%d, %d)\n"
    comenziParsate: .long 0
    nrComenziAdd: .space 4
    nrComenziAddExecutate: .long 0
    idFisier: .space 4
    dimensiuneFisier: .space 4
    primulZero: .space 4
    sfarsitInterval: .space 4
    pozitieZero: .space 4
    ct: .space 4
    startIntervalGET: .long 0
    sfarsitIntervalGET: .long 0
    afisare: .asciz "(%d, %d)\n"

.text
.global main
main:
    lea d, %edi
    xor %ecx, %ecx
    jmp zero

zero:
    cmp $1000, %ecx
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
    jmp DEFRAG

citireNrComenziADD:
    push $nrComenziAdd
    push $formatScanf
    call scanf
    add $8, %esp
    jmp ADD  

ADD:
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
    jg restMare

rest0:
    mov %eax, dimensiuneFisier
    xor %ebx, %ebx
    xor %edx, %edx
    xor %ecx, %ecx
    jmp cautSpatiuLiber
restMare:
    add $1, %eax
    mov %eax, dimensiuneFisier
    xor %ebx, %ebx
    xor %edx, %edx
    xor %ecx, %ecx
    jmp cautSpatiuLiber

cautSpatiuLiber:
    cmpl $1000, %ecx
    jge ADD_eroare

    mov $0, %eax
    cmpb (%edi, %ecx), %al
    je retinemPrimulZero    
    inc %ecx
    jmp cautSpatiuLiber

retinemPrimulZero:
    movl %ecx, primulZero 
    inc %ecx
    jmp ZeroDisponibil

ZeroDisponibil:
   
    xor %eax, %eax
    cmpb (%edi, %ecx) , %al
    jne verificareADD
    movl %ecx, ct
    inc %ecx
    jmp ZeroDisponibil
   
verificareADD:
    movl ct, %ebx
    sub primulZero, %ebx
    cmpl dimensiuneFisier, %ebx
    jne adaugareInMemorie             
    jmp cautSpatiuLiber

adaugareInMemorie:
    movl primulZero, %ecx
    mov dimensiuneFisier, %edx
    addl primulZero, %edx
    sub $1, %edx
    movl %edx, sfarsitInterval
    xor %edx, %edx
    mov idFisier, %eax
    jmp adaugareInMemorieContinuare

adaugareInMemorieContinuare:
    movb %al, (%edi,%ecx)
    cmpl %ecx, sfarsitInterval
    je et_afisareADD
    inc %ecx
    cmp $1000, %ecx
    je ADD_eroare
    jmp adaugareInMemorieContinuare

ADD_eroare:
    movl $0, sfarsitInterval
    movl $0, primulZero
    jmp eroare_afisareADD

eroare_afisareADD:
    push sfarsitInterval
    push primulZero
    push $afisare
    call printf
    add $12, %esp
    jmp ADD

et_afisareADD:
    push sfarsitInterval
    push primulZero
    push idFisier
    push $afisareADD
    call printf
    add $16, %esp
    jmp ADD



GET:
    push $idFisier
    push $formatScanf
    call scanf  
    add $8, %esp
    movl idFisier, %eax
    xor %ecx, %ecx
    xor %ebx, %ebx
    jmp gasestePrimulID

gasestePrimulID:
    cmp $1000, %ecx
    je eroare_GET
    movb (%edi, %ecx),%bl   
    cmpb %bl, %al
    je seteazaStartInterval
    inc %ecx
    jmp gasestePrimulID

eroare_GET:
    movl $0, startIntervalGET
    movl $0, sfarsitIntervalGET
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
    push sfarsitIntervalGET
    push startIntervalGET
    push $afisare
    call printf
    add $12, %esp
    jmp parsareComenzi
    


REMOVE:
    jmp parsareComenzi

DEFRAG:
    jmp parsareComenzi

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
