#include <iostream>
#include <fstream>
#include <vector>
#include <bits/stdc++.h> 
#include <unistd.h>

using namespace std;
//Defines
#define NC "\e[0m"
#define RED "\e[0;31m"
#define GRN "\e[0;32m"

//Metodos programados en ensamblador.
extern "C" float calcularDistancia();
extern "C" float calcularTemperatura();
extern "C" float calcularMascarilla();
extern "C" float almacenarEnMemoria(float, float, float, float, float, float, float);
extern "C" void ResetearContador();

//Funcion que recibe un string y devuelve un vector de los tokens, o sea cada caracter.
vector<float> Tokenizer(const string &line)
{
    //Vector float donde se guardaran los tokens.
    vector<float> tokens;
    stringstream check1(line);
    string intermediate; 
    while(getline(check1, intermediate, ' ')) 
    { 
        tokens.push_back(stof(intermediate)); 
    } 
    return tokens;
}

int main()
{
    //Abrir el archivo de los resultados.
    ofstream resultsFile;
    resultsFile.open("resultados.txt");
    
    ifstream myfile;
    //Abrir el archivo de los datos. Aqui se debe poner el nombre del archivo.
    myfile.open("datos.txt");
    
    //Variable string para contar la cantidad de lineas en el archivo.
    string line;
    //Variable para saber el numero de linea actual.
    int numeroLinea = 0;
    //Variable en que se guarda la cantidad de lineas del archivo.
    int numeroDeLineas = 0;

    //While que sirve para contar las lineas del archivo.
    while (getline(myfile, line))
    {
        ++numeroDeLineas;
    }
    //Cerrar el archivo.
    myfile.close();
	
    //Volver a abrir el archivo para empezar en la linea 1.
    myfile.open("datos.txt");

    //Parametros
    float param_1;
    float param_2;
    float param_3;
    float param_4;
    float param_5;
    float param_6;
    float param_7;

    //Variables para resultados
    float distancia;
    float temperatura;
    float mascarilla;

    //Variables para la simulacion de ingreso.
    srand(time(NULL));
    int randomNumber; //Numero aleatorio de ingreso.
    int randomEsperar; //Random de segundos a esperar para el siguiente ingreso.
    int cantidadPersonas = numeroDeLineas; //Cantidad de personas totales.
    int personasAnalizadas = 0; //Cantidad de personas analizadas hasta el momento.
    int numPersona=1;

    //Inicio del archivo
    resultsFile << "Si la distancia es menor a 2 metros, entonces no se cumple la medida de seguridad.\n";
    resultsFile << "Si la temperatura es mayor igual a 37.2 grados celsius, entonces no se cumple la medida de seguridad.\n";
    resultsFile << "Si no hay uso de mascarilla, entonces no se cumple la medida de seguridad.\n\n";
    resultsFile << "------------------------------------------------------------------\n";
    resultsFile << "|   Persona    |  Distancia   |  Temperatura  | Uso de mascarilla |\n";
    resultsFile << fixed << setprecision(2);

    //Empezar a simular el ingreso de personas
    while (personasAnalizadas<cantidadPersonas){
        //Sacar numero aleatorio entre 0 y 10, que sera la cantidad de personas que ingresan por ciclo.
        randomNumber = (rand() % 11);
        if(randomNumber+personasAnalizadas>100){
            randomNumber -= (randomNumber+personasAnalizadas) - 100;
        }    
        //Cantidad aleatoria de espera.
        randomEsperar = (rand() % 5) + 2;
        
        //Imprimir la cantidad de personas que ingresaron en un momento determinado (también le llamamos frame).
        printf(NC "");
        if(randomNumber != 1){
        cout << "\nIngresaron " << randomNumber << " personas." << endl; 
        }else{
        cout << "\nIngreso 1 persona." << endl; 
        }

        //For para procesar cada linea, o sea cada persona.
        for (int i = personasAnalizadas; i < (personasAnalizadas + randomNumber); i++)
        {
            
            getline(myfile, line); //Obtener la siguiente linea de datos.

            //Proceso que llama la funcion Tokenizer que convierte la linea en tokens de una manera thread safe y los pone el el vector tokens.
            vector<float> tokens = Tokenizer(line);   

            //Asignar los tokens a los parametros.
            param_1 = tokens.at(0); // Coordenada X
            param_2 = tokens.at(1); // Coordenada Y
            param_3 = tokens.at(2); // Coordenada X2
            param_4 = tokens.at(3); // Coordenada Y2
            param_5 = tokens.at(4); // Radio
            param_6 = tokens.at(5); // Pixel A
            param_7 = tokens.at(6); // Pixel B
            
            //Almacenar en memoria.
            almacenarEnMemoria(param_1, param_2, param_3, param_4, param_5, param_6, param_7);

        }

        ResetearContador();
        
        for (int i = personasAnalizadas; i < (personasAnalizadas + randomNumber); i++)
        {
            resultsFile << "------------------------------------------------------------------\n";
            
            resultsFile << "|\t" << i+1 << "\t|"; //Número de persona
                        
            distancia = calcularDistancia(); 
            
            temperatura = calcularTemperatura();
            
            mascarilla = calcularMascarilla();
            //Mostrar advertencias si los valores son mayores de los correctos.
            if(distancia < 2.0 || temperatura > 37.2 || mascarilla > 1.0){
                printf(NC " [");
                printf(RED "x");
                printf(NC "]");

                if(numPersona<10){
                    printf(NC " Persona  ");
                }else{

                    printf(NC " Persona ");
                }
                std::cout<<numPersona++;
                if(distancia >= 2.0){
                    printf(GRN " D");
                }else{
                    printf(RED " D");
                }
                if(temperatura < 37.2){
                    printf(GRN " T");
                }else{
                    printf(RED " T");
                }
                if(mascarilla <= 1.0){
                    printf(GRN " M");
                }else{
                    printf(RED " M");
                }
                
            }else{
                printf(NC " [");
                printf(GRN "a");
                printf(NC "]");

                if(numPersona<10){
                    printf(NC " Persona  ");
                }else{
                    printf(NC " Persona ");
                }
                std::cout<< numPersona++;
                printf(GRN " D T M ");
                
            }
            std::cout<<""<<std::endl;
            resultsFile << "    " << distancia << "m\t|";
            resultsFile << "    "<< temperatura<< "°\t|";

            if(mascarilla<1.1){
                resultsFile << "        Sí        |\n";
            }else{
                resultsFile << "        No        |\n";
            }

        }
        
        ResetearContador();
    
        //Esperar para la siguiente llegada de personas.
        sleep(randomEsperar);
        
        //Llevar la cuenta de las personas analizadas.
        personasAnalizadas += randomNumber;
        
    }
    //Cerrar los archivos.
    myfile.close();
    resultsFile.close();
    return 0;

}

