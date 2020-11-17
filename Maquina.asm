section .data
;                                       MEMORIA
    memoria: times 253 dd 0 
                       dd 0.0000000572 ; Constante para el calculo de temperatura.
                       dd 273.15       ; Constante de Conversion (Kelvin a Centigrados).
                       dd 10000.0      ; Número de píxeles de una imagen.
          
;   253 dd + 3 dd = 1k
;                                       REGISTROS
    myXmm0: dd 0  
    myXmm1: dd 0
    myXmm2: dd 0
    myXmm3: dd 0
    myXmm4: dd 0 
    myCR:   dd 0 ; Registro Contador (Counter Register)

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
;Carga los datos de memoria a registros myXmm
;Parámetro: %1 = registro destino
%macro cargarDatos 1
    mov rax, 0
    mov ebx, [myCR]
    vmovss xmm0, [memoria + ebx]
    vmovss [%1], xmm0
    
    ;Incrementa el contador
    mov eax, [myCR]
    add eax, 4
    mov dword [myCR], eax

%endmacro

%macro moverParaRetorno 1
    vmovss xmm0,[%1]
%endmacro

;******************************************************************************************************************
;                                              Metodo: almacenarEnMemoria
;
;Se mete en memoria todo lo que llega desde la cámara en un frame. Cuando hay otro frame, los nuevos datos le caen encima a estos.
;Requiere:
;             XMM0--> Coordenada X.
;             XMM1--> Coordenada Y.
;             XMM2--> Coordenada X2.
;             XMM3--> Coordenada Y2.
;             XMM4--> Coordenada Radiación.
;             XMM5--> Coordenada Píxeles A.
;             XMM6--> Coordenada Píxeles B.

global almacenarEnMemoria
almacenarEnMemoria:
    mov ebx, 0
    mov ebx, [myCR]
    
    movd [memoria + ebx], xmm0       ; Coordenada X
    movd [memoria + ebx + 4], xmm1   ; Coordenada Y
    movd [memoria + ebx + 8], xmm2   ; Coordenada X2
    movd [memoria + ebx + 12], xmm3  ; Coordenada Y2
    movd [memoria + ebx + 16], xmm4  ; Radiación
    movd [memoria + ebx + 20], xmm5  ; Pixeles A
    movd [memoria + ebx + 24], xmm6  ; Pixeles B

    incrementarContador 28           ; MyCR
    ret 

global ResetearContador
ResetearContador:

    mov dword[myCR], 0
    ret 



;******************************************************************************************************************
;                                              Metodo: calcularDistancia
global calcularDistancia
calcularDistancia:         

    push rbp
    mov rbp, rsp


    cargarDatos myXmm0  ; x1
    cargarDatos myXmm1  ; y1
    cargarDatos myXmm2  ; x2
    cargarDatos myXmm3  ; y2

    restar myXmm2, myXmm0       ; Se calcula la resta de la posicion de X_2 con respecto a X (X_2 - X)
    restar myXmm3, myXmm1       ; Se calcula la resta de la posicion de Y_2 con respecto a Y (Y_2 - Y)

    multiplicar myXmm2, myXmm2  ; Se eleva a la 2 los resultado anterios (X_2 - X)^2
    multiplicar myXmm3, myXmm3  ; (Y_2 - Y)^2

    sumar myXmm2, myXmm3        ; Se suman los dos resultados anteriores ( (X_2 - X)^2 + (Y_2 - Y)^2 )

    raizCuadrada myXmm2, myXmm2 ; Y por ultimo se calcula la raiz de lo anterior  (raiz ((x2-x)^2 + (y2-y)^2) )

    moverParaRetorno myXmm2

    mov rsp, rbp 
    pop rbp
    ret


;******************************************************************************************************************
;                                              Metodo: calcularTemperatura
global calcularTemperatura
calcularTemperatura:

    push rbp
    mov rbp, rsp

    cargarDatos myXmm0 ; Radiacion 

    dividir myXmm0, memoria+1012      ; Se divide la radiacion por la constante 0.0000000572 ( Radiacion / CONSTANTE ) 

    raizCuadrada myXmm0, myXmm0       ; Se Saca 2 veces la raiz cuadrada, que equivale a elevar el dato a la 1/4.( (Radiacion * CONSTANTE)^1/4 )
    raizCuadrada myXmm0, myXmm0

    restar myXmm0, memoria+1016       ; Se Resta 273.15 para pasarlo de Kelvin a Centigrados.

    moverParaRetorno myXmm0

    mov rsp, rbp 
    pop rbp
    ret


;******************************************************************************************************************
;                                              Metodo: calcularMascarilla
global calcularMascarilla
calcularMascarilla:        

    push rbp
    mov rbp, rsp

    cargarDatos myXmm0 ; Pixeles A.
    cargarDatos myXmm1 ; Pixeles B.

    restar myXmm0, myXmm1               ; Se restan las dos sumatorias (cada sumatoria representa la intensidad de los píxeles de una imagen)
    multiplicar  myXmm0, myXmm0         ; Se eleva al cuadrado el resultado
    dividir myXmm0, memoria+1020        ; Se divide entre 10000 (la cantidad de píxeles que tiene una imagen).
    
    moverParaRetorno myXmm0  

    mov rsp, rbp 
    pop rbp
    ret 
