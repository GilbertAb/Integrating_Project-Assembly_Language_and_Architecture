#include <iostream>
#include <fstream>
#include <vector>
#include <bits/stdc++.h> 
using namespace std;

extern "C" float calcularDistancia(float, float, float, float);
extern "C" float calcularTemperatura(float);
extern "C" float calcularMascarilla(float, float);
extern "C" float almacenarEnMemoria(float, float, float, float, float, float, float);

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

    //For para procesar cada linea.
    for (int i = 0; i < numeroDeLineas; i++)
    {
        
        getline(myfile, line);
        cout << "*Persona numero " << i+1 << endl;
        //Proceso que llama la funcion Tokenizer que convierte la linea en tokens de una manera thread safe y los pone el el vector tokens.
        vector<float> tokens = Tokenizer(line);
	    
        param_1 = tokens.at(0); // Coordenada X
        param_2 = tokens.at(1); // Coordenada Y
        param_3 = tokens.at(2); // Coordenada X2
        param_4 = tokens.at(3); // Coordenada Y2
        param_5 = tokens.at(4); // Radio
        param_6 = tokens.at(5); // Pixel A
        param_7 = tokens.at(6); // Pixel B

        almacenarEnMemoria(param_1, param_2, param_3, param_4, param_5, param_6, param_7);

        resultado = calcularDistancia(param_1, param_2,param_3, param_4);
        cout << "Distancia: "<< resultado << endl;
        //Se guarda el resultado en el archivo.
        //cout << param_1 << endl; // Se imprime solo para verificar que el metodo sirva (Luego esto se eliminará)
        //cout << param_2 << endl;
        //cout << param_3 << endl;
        //cout << param_4 << endl;
        param_1 = tokens.at(4); // Radio
        resultado = calcularTemperatura(param_1);
	cout << "Temperatura: "<< resultado << endl;
       
        param_1 = tokens.at(5);  // Pixel A
        param_2 = tokens.at(6);  // Pixel B
        resultado = calcularMascarilla(param_1, param_2);
        cout << "Mascarilla: "<< resultado << endl;
        //Se guarda el resultado en el archivo.

        //cout << param_1 << endl;
        //cout << param_2 << endl;
	cout << " " << endl;
    }
   
    //Cerrar el archivo.
    myfile.close();
    return 0;

}

