section .data
;                                       MEMORIA
    memoria: times 253 dd 0 
                       dd 0.0000000572
                       dd 273.15
                       dd 10000.0
;   253 dd + 3 dd = 1k
;                                       REGISTROS
    myXmm0: dd 0  
    myXmm1: dd 0
    myXmm2: dd 0
    myXmm3: dd 0 
    myXmm4: dd 0 
    myCR:   dd 0; Contador

   CONSTANTE:  dd 0.0000000572  ; Constante para el calculo de temperatura.
   CONSTANTE2: dd 273.15        ; Constante de Conversion (Kelvin a Centigrados).
   CONSTANTE3: dd 10000.0       ; Número de píxeles de una imagen.

section .text

%macro sumar 2
    vmovss xmm0,[%1]
    vmovss xmm1,[%2]

    vaddss xmm0, xmm1
    vmovss [%1], xmm0

%endmacro 

%macro restar 2
    vmovss xmm0,[%1]
    vmovss xmm1,[%2]

    vsubss xmm0, xmm1
    vmovss [%1], xmm0

%endmacro 

%macro multiplicar 2

    vmovss xmm0,[%1]
    vmovss xmm1,[%2]

    vmulss xmm0, xmm1
    vmovss [%1], xmm0

%endmacro 

%macro dividir 2

    vmovss xmm0,[%1]
    vmovss xmm1,[%2]

    vdivss xmm0, xmm1
    vmovss [%1], xmm0

%endmacro 

%macro raizCuadrada 2

    vmovss xmm0,[%1]
    vmovss xmm1,[%2]

    vsqrtss xmm0, xmm1
    vmovss [%1], xmm0

%endmacro 

%macro incrementarContador 1

    mov rax, 0
    mov eax, [myCR]

    add eax, %1
    mov dword [myCR], eax

%endmacro

%macro cargarDatos 2
    mov rax, 0
    mov ebx, %2
    vmovss xmm0, [memoria + ebx]
    vmovss [%1], xmm0
    mov eax, [myCR]
    add eax, 4
    mov dword [myCR], eax

%endmacro



global almacenarEnMemoria
almacenarEnMemoria:
    mov ebx, 0
    mov ebx, [myCR]
    
    movd [memoria + ebx],    xmm0  ; Coordenada X
    movd [memoria + ebx + 4],  xmm1  ; Coordenada Y
    movd [memoria + ebx + 8],  xmm2  ; Coordenada X2
    movd [memoria + ebx + 12], xmm3  ; Coordenada Y2
    movd [memoria + ebx + 16], xmm4  ; Radio
    movd [memoria + ebx + 20], xmm5  ; Pixel A
    movd [memoria + ebx + 24], xmm6  ; Pixel B

    incrementarContador 28              ; MyCR
    ret 

global ResetearContador
ResetearContador:

    mov dword[myCR], 0
    ret 



;******************************************************************************************************************
;                                              Metodo: calcularDistancia
;    Requiere:
;             XMM0--> Coordenada X.
;             XMM1--> Coordenada Y.
;             XMM2--> Coordenada X2.
;             XMM3--> Coordenada Y2.
global calcularDistancia
calcularDistancia:         

    push rbp
    mov rbp, rsp


    cargarDatos myXmm0, [myCR]; x1
    cargarDatos myXmm1, [myCR]; y1
    cargarDatos myXmm2, [myCR]; x2
    cargarDatos myXmm3, [myCR]; y2

    restar myXmm2, myXmm0
    restar myXmm3, myXmm1

    multiplicar myXmm2, myXmm2
    multiplicar myXmm3, myXmm3

    sumar myXmm2, myXmm3

    raizCuadrada myXmm2, myXmm2

    vmovss xmm0, [myXmm2]


    ;vsubss xmm0, xmm2, xmm0  ; Se calcula la resta de la posicion de X_2 con respecto a X (X_2 - X)
    ;vsubss xmm1, xmm3, xmm1  ; Se calcula la resta de la posicion de Y_2 con respecto a Y (Y_2 - Y)

    ;vmulss xmm0, xmm0, xmm0  ; Se eleva a la 2 los resultado anterios (X_2 - X)^2
    ;vmulss xmm1, xmm1, xmm1  ; (Y_2 - Y)^2

    ;vaddss xmm0, xmm0, xmm1  ; Se suman los dos resultados anteriores ( (X_2 - X)^2 + (Y_2 - Y)^2 )

    ;vsqrtss xmm0, xmm0       ; Y por ultimo se calcula la raiz de lo anterior  (raiz ((x2-x)^2 + (y2-y)^2) )

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

    cargarDatos myXmm0, [myCR]      ; Radiacion 

    dividir myXmm0, CONSTANTE

    raizCuadrada myXmm0, myXmm0
    raizCuadrada myXmm0, myXmm0

    restar myXmm0, CONSTANTE2
   

    vmovss xmm0, [myXmm0]

    ;vdivss xmm0, xmm0, [CONSTANTE]  ; Se divide la radiacion por la constante 0.0000000572 ( Radiacion / CONSTANTE ) 
    ;vsqrtss xmm0, xmm0, xmm0  
    ;vsqrtss xmm0, xmm0, xmm0         ; Se Saca 2 veces la raiz cuadrada, que equivale a elevar el dato a la 1/4.( (Radiacion * CONSTANTE)^1/4 )
    ;vsubss xmm0, xmm0, [CONSTANTE2] ; Se Resta 273.15 para pasarlo de Kelvin a Centigrados


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

    cargarDatos myXmm0, [myCR]          ; Pixeles A.
    cargarDatos myXmm1, [myCR]          ; Pixeles B.

    restar myXmm0, myXmm1
    multiplicar  myXmm0, myXmm0
    dividir myXmm0, CONSTANTE3
    
    vmovss xmm0, [myXmm0]
    ;vsubss xmm0, xmm0, xmm1             ; Se restan las dos sumatorias (cada sumatoria representa la intensidad de los píxeles de una imagen)
    ;vmulss xmm0, xmm0, xmm0             ; Se eleva al cuadrado el resultado
    ;vdivss xmm0, xmm0, [CONSTANTE3]     ; se divide entre 10000 (la cantidad de píxeles que tiene una imagen).

    mov rsp, rbp 
    pop rbp
    ret 
