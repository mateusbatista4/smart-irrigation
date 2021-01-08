#include <LiquidCrystal_I2C.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <WiFi.h>

const char* ssid = "Eclipse 2020";
const char* password = "99916622";
const char* serverName = "https://irrigation-uberlandia.herokuapp.com/pumps/";
unsigned long lastTime = 0;
unsigned long timerDelay = 1000;

int lcdColumns = 16;
int lcdRows = 2;
LiquidCrystal_I2C lcd(0x3F, lcdColumns, lcdRows);  

String sensorReadings;
int pumpId;
bool pumpStatus;
String pumpName;
int dotCounter = 0;
int lastStatus[4] = {0,0,0,0};



void setup() {
  Serial.begin(115200);
  pinMode(13, OUTPUT);
  pinMode(15, OUTPUT);
  pinMode(16, OUTPUT);
  pinMode(17, OUTPUT);
  pinMode(18, OUTPUT);

  lcd.init();
  lcd.backlight();
  
  lcd.print("Bem Vindx!");
  delay(5000);
  
  lcd.clear();
  
  WiFi.begin(ssid, password);
  lcd.print("Conectando a ");
  lcd.setCursor(0,1);
  lcd.print(ssid);
  //Serial.println("Connecting");
  
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    lcd.print(".");
    dotCounter++;
    
    if(dotCounter >= 4){
      lcd.clear();
      lcd.print("Conectando a ");
      lcd.setCursor(0,1);
      lcd.print(ssid);
      dotCounter = 0;
    }
  }
  lcd.clear();
 
  lcd.print("Conectado com ");
  lcd.setCursor(0,1);
  lcd.print(ssid);
  
  digitalWrite(13, HIGH);
  digitalWrite(15, HIGH);
  digitalWrite(16, HIGH);
  digitalWrite(17, HIGH);
  digitalWrite(18, HIGH);
  
  
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
        pumpName = myObject[i][keys[2]];
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
        lastStatus[i] = pumpStatus;
        
      }
      
      Serial.print("id: ");
      Serial.println(pumpId);
      Serial.print("status: ");
      Serial.println(pumpStatus);

    }
    else {
      lcd.clear();
      lcd.print("WiFi Desconectado...");
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
    digitalWrite(13, HIGH);
    payload = http.getString();
    
  }
  else {
    digitalWrite(13, LOW);
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  // Free resources
  http.end();

  return payload;
}


