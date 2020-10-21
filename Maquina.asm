section .data
    CONSTANTE: dd 0.0000000572
    CONSTANTE2: dd 273.15
    CONSTANTE3: dd 10000.0


section .text
global calcularDistancia


;******************************************************************************************************************
;                                              Metodo: calcularDistancia
;    Requiere:
;             XMM0--> Coordenada X.
;             XMM1--> Coordenada Y.
;             XMM2--> Coordenada X2.
;             XMM3--> Coordenada Y2.

calcularDistancia:         

    push rbp
    mov rbp, rsp

    vsubss xmm0, xmm2, xmm0  ; x2-x
    vsubss xmm1, xmm3, xmm1  ; y2-x

    vmulss xmm0, xmm0, xmm0 ; (x2-x)^2
    vmulss xmm1, xmm1, xmm1 ; (y2-y)^2

    vaddss xmm0, xmm0, xmm1  ; ( (x2-x)^2 + (y2-y)^2 )

    vsqrtss xmm0, xmm0       ; raiz ( (x2-x)^2 + (y2-y)^2 )

    mov rsp, rbp 
    pop rbp
    ret


;******************************************************************************************************************
;                                              Metodo: calcularTemperatura
;    Requiere:
;             XMM0 --> Radiacion.

global calcularTemperatura
calcularTemperatura:       

    push rbp
    mov rbp, rsp

    ;vmulss xmm0, xmm0, [CONSTANTE]  ; ( Radiacion * CONSTANTE )
    vsqrtss xmm0, xmm0, xmm0
    vsqrtss xmm0, xmm0, xmm0
    ;vsubss xmm0, xmm0, [CONSTANTE2]


    mov rsp, rbp 
    pop rbp
    ret


;******************************************************************************************************************
;                                              Metodo: calcularMascarilla
;    Requiere:
;             XMM0 --> Sum. Pixeles A.
;             XMM1 --> Sum. Pixeles B.

global calcularMascarilla
calcularMascarilla:        

    push rbp
    mov rbp, rsp

    vsubss xmm0, xmm0, xmm1
    vmulss xmm0, xmm0, xmm0
    ;vdivss xmm0, xmm0, [CONSTANTE3]

    mov rsp, rbp 
    pop rbp
    ret 