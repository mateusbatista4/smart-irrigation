#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <WiFi.h>

const char* ssid = "Rede da Familia Batista";
const char* password = "CassioLuisBatista001";


const char* serverName = "http://192.168.100.34:8000/pumps/";

unsigned long lastTime = 0;

unsigned long timerDelay = 2000;

String sensorReadings;
int pumpId;
bool pumpStatus;

void setup() {
  Serial.begin(115200);
  
  pinMode(15, OUTPUT);
  pinMode(16, OUTPUT);
  pinMode(17, OUTPUT);
  pinMode(18, OUTPUT);
  
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
  digitalWrite(15, LOW);
  digitalWrite(16, LOW);
  digitalWrite(17, LOW);
  digitalWrite(18, LOW);
  Serial.println("Timer set to 5 seconds (timerDelay variable), it will take 5 seconds before publishing the first reading.");
}

void loop() {
  //Send an HTTP POST request every 10 minutes
  if ((millis() - lastTime) > timerDelay) {
    //Check WiFi connection status
    if(WiFi.status()== WL_CONNECTED){
              
      sensorReadings = httpGETRequest(serverName);
     
      JSONVar myObject = JSON.parse(sensorReadings);
  
      // JSON.typeof(jsonVar) can be used to get the type of the var
      
      if (JSON.typeof(myObject) == "undefined") {
        Serial.println("Parsing input failed!");
        return;
      }
      
      JSONVar keys;
      
      for(int i = 0 ; i < 4; i++ ){
        keys = myObject[i].keys();
        pumpId = myObject[i][keys[0]];
        pumpStatus = myObject[i][keys[1]];
        Serial.println(i+1);
        Serial.print("id: ");
        Serial.println(pumpId);
        Serial.print("status: ");
        Serial.println(pumpStatus);
        if(pumpStatus){
          digitalWrite(14 + pumpId, LOW);
        } else{
          digitalWrite(14 + pumpId, HIGH);
        }
      }
    
      Serial.print("id: ");
      Serial.println(pumpId);
      Serial.print("status: ");
      Serial.println(pumpStatus);
      


    }
    else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}

String httpGETRequest(const char* serverName) {
  HTTPClient http;

  // Your IP address with path or Domain name with URL path 
  http.begin(serverName);

  // Send HTTP POST request
  int httpResponseCode = http.GET();

  String payload = "{}"; 

  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    payload = http.getString();
    
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  // Free resources
  http.end();

  return payload;
}
