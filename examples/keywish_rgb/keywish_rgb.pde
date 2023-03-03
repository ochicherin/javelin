/* Example for Keywish https://github.com/keywish/keywish-arduino-rfid-kit
     Lesson33-Mobile phone bluetooth dimming experiment
     Replacing the KeywishBot3.3.apk application
*/
import controlP5.*;
import javelin.*;

    String ble_device  = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-3c:a5:50:80:bc:8a"; // JDY-16
    String ble_service = "0000FFE0-0000-1000-8000-00805F9B34FB";
    String ble_char    = "0000FFE1-0000-1000-8000-00805F9B34FB";

ControlP5 cp5;

void setup(){
    size(330,360);
    cp5 = new ControlP5(this);
    cp5.setFont(createFont("Arial",12));
  
    javelin.init();
    System.out.println("Start scan devices ...");
    String l_devices[] = javelin.listBLEDevices();
    System.out.println("Device : "+ble_device);
    String l_name = javelin.getBLEDeviceName(ble_device);
    System.out.println("  Name: "+l_name);
    System.out.print("Scan device... ");
    String l_services[] = javelin.listBLEDeviceServices(ble_device);
    System.out.println(l_services.length+" services found.");
    System.out.print("Scan service... ");
    String l_chars[] = javelin.listBLEServiceCharacteristics(ble_device, ble_service);
    System.out.println(l_chars.length+" characteristics found.");
    frameRate(2);
    System.out.print("Characteristic watch...");
    boolean watchChanges = javelin.watchBLECharacteristicChanges(ble_device,ble_service,ble_char);
    if (watchChanges) {
        System.out.println(" enabled. Terminal ready for use.");
    } else {
        System.out.println(" disabled. Terminal cannot be used.");
        exit();
    }  

    cp5.addButton("ledRED").setCaptionLabel("Red").setPosition(10,10);
    cp5.addButton("ledGREEN").setCaptionLabel("Green").setPosition(90,10);
    cp5.addButton("ledBLUE").setCaptionLabel("Blue").setPosition(170,10);
    cp5.addButton("ledBLACK").setCaptionLabel("Black").setPosition(250,10);
    cp5.addColorWheel("colorPicker" , 10, 40, 310 );     
}

void colorPicker(int Col) {
    setColor(int(red(Col)),int(green(Col)),int(blue(Col)));
}

void sendData(byte[] l_bytes) {
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char, l_bytes);
}

/*
Keywish Penter-robot protocol
start_code  byte  ==0xAA
len         byte  length from "len" to "checksum lo"
type        byte  E_TYPE
addr        byte  
function    byte  E_CONTOROL_FUNC
data        byte* some bytes of data
checksum    byte  high byte of checksum (sum from len to checksum lo)
checksum    byte  low byte of checksum
end_code    byte  ==0x55
*/

void sendCommand(byte[] l_bytes) {
    int checksum = 0;
    for (int i=1;i<l_bytes.length-3;i++) checksum += l_bytes[i] & 0xFF;
    l_bytes[l_bytes.length-3] = (byte) ((checksum >> 8) & 0xFF);
    l_bytes[l_bytes.length-2] = (byte) (checksum & 0xFF);
    for (int i=0;i<l_bytes.length;i++) { 
        print(String.format("0x%02X ", l_bytes[i]));
    }    
    println("");
    sendData(l_bytes);
}

void setColor(int red,int green,int blue){
    byte pack[] = {(byte)0xAA,(byte)0x09,(byte)0x00,(byte)0x00,(byte)0x02,(byte)blue,(byte)green,(byte)red,0x00,0x00,0x55};
    sendCommand(pack);
}  

void playNote(float note) {
    byte pack[] = {(byte)0xAA,0x0A,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x55};
    int intBits =  Float.floatToIntBits(note);
    pack[8] = (byte) ((intBits >> 24) & 0xFF);
    pack[7] = (byte) ((intBits >> 16) & 0xFF);
    pack[6] = (byte) ((intBits >> 8)  & 0xFF);
    pack[5] = (byte) ((intBits)       & 0xFF);
    sendCommand(pack);
}

void ledRED(){
    setColor(255,0,0);
}

void ledGREEN(){
    setColor(0,255,0);
}

void ledBLUE(){
    setColor(0,0,255);
}

void ledBLACK(){
    setColor(0,0,0);
}

void draw(){
    background(240);
}
