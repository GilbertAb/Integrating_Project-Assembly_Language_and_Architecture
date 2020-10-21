section .data
    CONSTANTE: dd 0.0000000572
    CONSTANTE2: dd 273.15
    CONSTANTE3: dd 10000.0   ; Número de píxeles de una imagen


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

    vsubss xmm0, xmm2, xmm0  ; Se calcula la resta de la posicion de X_2 con respecto a X (X_2 - X)
    vsubss xmm1, xmm3, xmm1  ; Se calcula la resta de la posicion de Y_2 con respecto a Y (Y_2 - Y)

    vmulss xmm0, xmm0, xmm0  ; Se eleva a la 2 los resultado anterios (X_2 - X)^2
    vmulss xmm1, xmm1, xmm1  ; (Y_2 - Y)^2

    vaddss xmm0, xmm0, xmm1  ; Se suman los dos resultados anteriores ( (X_2 - X)^2 + (Y_2 - Y)^2 )

    vsqrtss xmm0, xmm0       ; Y por ultimo se calcula la raiz de lo anterior  (raiz ((x2-x)^2 + (y2-y)^2) )

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

    vsubss xmm0, xmm0, xmm1 ;Se restan las dos sumatorias (cada sumatoria representa la intensidad de los píxeles de una imagen)
    vmulss xmm0, xmm0, xmm0 ;Se eleva al cuadrado el resultado
    ;vdivss xmm0, xmm0, [CONSTANTE3]    se divide entre 10000 (la cantidad de píxeles que tiene una imagen).

    mov rsp, rbp 
    pop rbp
    ret 
