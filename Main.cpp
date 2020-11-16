#include <iostream>
#include <fstream>
#include <vector>
#include <bits/stdc++.h> 
#include <unistd.h>
using namespace std;

extern "C" float calcularDistancia();
extern "C" float calcularTemperatura();
extern "C" float calcularMascarilla();
extern "C" float almacenarEnMemoria(float, float, float, float, float, float, float);
extern "C" void ResetearContador();

vector<float> Tokenizer(const string &line)
{
    //Vector float donde se guardaran los tokens.
    vector<float> tokens;
    
    stringstream check1(line);

    string intermediate; 

    while(getline(check1, intermediate, ' ')) 
    { 
        //Stoi para string a int, stof para string a float, stod para string a double
        tokens.push_back(stof(intermediate)); 
    } 

    return tokens;
}

int main()
{
    ifstream myfile;
    //Abrir el archivo. Aqui se debe poner el nombre del archivo.
    myfile.open("datos.txt");
    
    //Variable string para contar la cantidad de lineas en el archivo.
    string line;
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
    float resultado;
    int numroPersona;

    //Variables para la simulacion de ingreso.
    srand(time(NULL));
    int randomNumber; //Numero aleatorio de ingreso.
    int randomEsperar; //Random de segundos a esperar para el siguiente ingreso.
    int cantidadPersonas = numeroDeLineas; //Cantidad de personas totales.
    int personasAnalizadas = 0; //Cantidad de personas analizadas hasta el momento.
    int cp = 1;
    while (personasAnalizadas<cantidadPersonas){
        //Obtener los numeros aleatorios.
        randomNumber = (rand() % 11);
        if(randomNumber+personasAnalizadas>100){
            randomNumber -= (randomNumber+personasAnalizadas) - 100;
        }    
        randomEsperar = (rand() % 5) + 2;
        
        //Imprimir la cantidad que ingresaron.
        if(randomNumber != 1){
        cout << "Ingresaron " << randomNumber << " personas." << endl; 
        }else{
        cout << "Ingreso 1 persona." << endl; 
        }

        //For para procesar cada linea.
        for (int i = personasAnalizadas; i < (personasAnalizadas + randomNumber); i++)
        {
            
            getline(myfile, line); //Obtener la siguiente linea de datos.
            //Imprimir el numero de persona analizada.
            cout << "*Persona numero " << i+1 << " analizada."<< endl;

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

            //Se guarda el resultado en el archivo.
        }
        ResetearContador();
        float resultado = 0.0;  
        for (int i = personasAnalizadas; i < (personasAnalizadas + randomNumber); i++)
        {
            std::cout<<"PERSONA: "<< cp <<std::endl;
            std::cout<<"CalcularDistancia"<<std::endl;
            resultado = calcularDistancia();
            std::cout<<resultado<<std::endl;
            std::cout<<"calcularTemperatura"<<std::endl;
            resultado = calcularTemperatura();
            std::cout<<resultado<<std::endl;
            std::cout<<"calcularMascarilla"<<std::endl;
            resultado = calcularMascarilla();
            std::cout<<resultado<<std::endl;

            std::cout<<std::endl;
            std::cout<<std::endl;
            std::cout<<std::endl;

            cp++;

        }
        ResetearContador();
    
        //Esperar para la siguiente llegada de personas.
        //sleep(randomEsperar);
        //Llevar la cuenta de las personas analizadas.
        personasAnalizadas += randomNumber;
        
        cout << " " << endl;
    }
    //Cerrar el archivo.
    myfile.close();
    return 0;

}

