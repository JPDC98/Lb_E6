const int buffer_size = 6;

char buf[buffer_size];
long byte0, byte1, byte2,byte00,byte01,byte02 = 0;
long totalCnt,totalCnt0 = 0;
float resultado,resultado0;
float tiempo = 28.22;
//String distancia;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while (!Serial) {}
  Serial2.begin(115200);
  while (!Serial2) {
  }
  pinMode(34,OUTPUT);
  digitalWrite(34,HIGH);
}

void loop() {
    digitalWrite(34,LOW);
    delay(0.001);
  if (Serial2.available() == buffer_size) {
    Serial2.readBytes(buf, buffer_size);
    byte0 = long(buf[0]);
    byte1 = long(buf[1]);
    byte2 = long(buf[2]);
    byte00 = long(buf[3]);
    byte01 = long(buf[4]);
    byte02 = long(buf[5]);
    
    totalCnt = byte2 << 16 | byte1 << 8 | byte0;
    totalCnt0 = byte02 << 16 | byte01 << 8 | byte00;
    //Serial.println("--------------------------");
    /*Serial.println(tiempo);
      Serial.println(String(byte0,BIN));
      Serial.println(String(byte1,BIN));
      Serial.println(String(byte2,BIN));
      Serial.println(String(totalCnt));
      Serial.println(String(totalCnt,BIN));
      
    */
    resultado= float((tiempo*totalCnt)/20000);
    resultado0= float((tiempo*totalCnt0)/20000);
    if (resultado >= 400) {
      Serial.print("Distancia S1 ");
      Serial.print("Out of range");
      Serial.println(" cm");
    }
    else {

      Serial.print("Distancia S1 ");
      Serial.print(resultado);
      Serial.println(" cm");

    }
    if (resultado0 >= 400) {
      Serial.print("Distancia S2 ");
      Serial.print("Out of range");
      Serial.println(" cm");
    }
    else {

      Serial.print("Distancia S2 ");
      Serial.print(resultado0);
      Serial.println(" cm");

    }
    
    //distancia=String(resultado);

    //Serial.println("--------------------------");
    Serial2.flush();
    byte0 = byte1 = byte2 = 0;

  }

  digitalWrite(34,HIGH);
  delay(200);

}
