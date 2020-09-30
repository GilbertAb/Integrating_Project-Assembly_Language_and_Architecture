# Proyecto Integrador de Arquitectura	y	Ensamblador

![Banner](logo.jpeg?raw=true)
=====

Nombre del equipo: 
=====
BGJ

Participantes: 
=====
* Bryan Umaña Morales B87997
* Eyson Jaffet Alfaro Venegas B90239
* Gilbert Márquez Aldana B94560

Descripcion breve del proyecto:
=====
Con el desarrollo de este proyecto se pretende diseñar una solución tecnológica que permita determinar en un espacio público el correcto seguimiento de las principales medidas de seguridad en el contexto de la pandemia por covid-19. Haremos uso del lenguaje ensamblador, ya que tanto la entrada de datos como la arquitectura serán simuladas. Se implementará una serie de cálculos para determinar si una persona cumple con las siguientes medidas: distanciamiento social, temperatura corporal y uso de mascarilla.



Descripcion detallada del proyecto:
=====
* Arquitectura:

   I.	Memoria principal: La máquina que diseñaremos contará con una memora total de 1KB donde se almacenará la información de cada persona.

   II.	Registros: Se utilizarán 6 registros de propósito general con un tamaño de 32 bits. Los cuales se utilizarán para realizar los cálculos de la distancia, la temperatura y las mascarillas.

   III.	Periféricos: Se necesitarán 2 cámaras que proporcionarán los datos requerido para realizar los cálculos de distancia, temperatura y máscaras.

   IV.	Limitaciones: Las cámaras solo podrán detectar como máximo 10 personas a la vez. 

* Implementación:

   I.	Entrada: Los datos de entrada serán tomados directamente de un archivo que contendrá la información suministrada por las cámaras.

   II.	Salida: La salida de los datos será por medio de la consola además de que dicha información se guardará en un archivo.

