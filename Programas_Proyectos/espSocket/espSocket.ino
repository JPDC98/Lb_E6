#include <ESP8266WiFi.h>
const char * ssid    ="xxxxxxxxxxx";
const char * password="xxxxxxxxxxxx";

const uint16_t port=5050;  //Puerto del servidor
const char * host="192.168.1.79";//Dirección del servidor

int HEADER= 8;
String DISCONNECT="!DISCONNECT";

char buff[8];

String msg="hello from esp32!";
String msg2="la prueba de que si funciona esta en tu corazon";

//-----------------------------------------------------------------------
int trigger = 5;
const int buffer_size = 6;

char buf[buffer_size];
long byte0, byte1, byte2,byte00,byte01,byte02 = 0;
long totalCnt,totalCnt0 = 0;
float resultado,resultado0;
float tiempo = 28.22;

String sensor1;
String sensor2;
String resultadoS;
String resultado0S;
//-----------------------------------------------------------------------


String lengthMessageClient(String longData);
void sendDataClient(String data0,String data1);


void setup() {
  Serial.begin(115200);
  while(!Serial){}
    //-------------------------------------
  pinMode(trigger,OUTPUT);
  digitalWrite(trigger,LOW);
  //------------------------------------
  
  WiFi.begin(ssid,password);
  while(WiFi.status()!=WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("Conectado");
  Serial.println(WiFi.localIP());

}




void loop() {
    sensor1=sensor2=resultadoS=resultado0S="";
    digitalWrite(trigger,LOW);
    delay(1);
    if(Serial.available()==buffer_size ) {
      Serial.readBytes(buf, buffer_size);
      byte0 = long(buf[0]);
      byte1 = long(buf[1]);
      byte2 = long(buf[2]);
      byte00 = long(buf[3]);
      byte01 = long(buf[4]);
      byte02 = long(buf[5]);
      
      totalCnt = byte2 << 16 | byte1 << 8 | byte0;
      totalCnt0 = byte02 << 16 | byte01 << 8 | byte00;
  
  
      resultado= float((tiempo*totalCnt)/20000);
      resultado0= float((tiempo*totalCnt0)/20000);
      resultadoS=String(resultado);
      resultado0S=String(resultado0);
      if (resultado >= 400) {
        sensor1="Distancia S1: Fuera de rango";
        Serial.println(sensor1);
                
        }
        else {
          sensor1="Distancia S1: ";
          sensor1.concat(resultadoS);
          sensor1.concat(" cm");
          Serial.println(sensor1);
    
        }
      if (resultado0 >= 400) {
        sensor2="Distancia S2: Fuera de rango";
        Serial.println(sensor2);
        }
        else {
          sensor2 = "Distancia S2: ";
          sensor2.concat(resultado0S);
          sensor2.concat(" cm");
          Serial.println(sensor2);
  
      }
    sendDataClient(sensor1,sensor2);
    //Serial.println("--------------------------");
    Serial.flush();
    byte0 = byte1 = byte2 = 0;

  }
  digitalWrite(trigger,HIGH);
  delay(200); 
}

String lengthMessageClient(String longData){//Realiza un 

  String lenData=String(int(longData.length()));
  int numero=HEADER-(lenData.length());
  for(int cnt=0;cnt<numero;cnt=cnt+1){  
    lenData.concat(" ");
  }
  return lenData;  
  }

void sendDataClient(String data0,String data1){
  String messageLength; 
  WiFiClient client;
  if(!client.connect(host,port)){
    Serial.println("Connection to host failed");
    delay(1000);
    return;
    }
   Serial.println("Connected to server successful");
   messageLength=lengthMessageClient(data0);
   client.print(messageLength);
   client.print(data0);
   messageLength=lengthMessageClient(data1);
   client.print(messageLength);
   client.print(data1);
   messageLength=lengthMessageClient(DISCONNECT);
   client.print(messageLength);
   client.print(DISCONNECT);
   
   client.stop();
   Serial.println("Disconnecting...");
   delay(300);
  
  }
