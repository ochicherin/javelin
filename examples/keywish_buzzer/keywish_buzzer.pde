/* Example for Keywish https://github.com/keywish/keywish-arduino-rfid-kit
     Lesson32-Mobile phone bluetooth piano experiment
     Replacing the KeywishBot3.3.apk application
*/
import controlP5.*;
import javelin.*;

    String ble_device  = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-3c:a5:50:80:bc:8a"; // JDY-16
    String ble_service = "0000FFE0-0000-1000-8000-00805F9B34FB";
    String ble_char    = "0000FFE1-0000-1000-8000-00805F9B34FB";

ControlP5 cp5;

class note{
  public String name;
  public float tone;
  public boolean b;
  private note(String newname,float newtone,boolean newb){
    name=newname;
    tone=newtone;
    b=newb;
  }  
};

note notes[] = {  
 new note("note_C4",  261.63,true),
 new note("note_Db4", 277.18,false),
 new note("note_D4",  293.66,true),
 new note("note_Eb4", 311.13,false),
 new note("note_E4",  329.63,true),
 new note("note_F4",  349.23,true),
 new note("note_Gb4", 369.99,false),
 new note("note_G4",  392.00,true),
 new note("note_Ab4", 415.30,false),
 new note("note_A4",  440.00,true),
 new note("note_Bb4", 466.16,false),
 new note("note_B4",  493.88,true),
 new note("note_C5",  523.25,true),
 new note("note_Db5", 554.37,false),
 new note("note_D5",  587.33,true),
 new note("note_Eb5", 622.25,false),
 new note("note_E5",  659.26,true),
 new note("note_F5",  698.46,true),
 new note("note_Gb5", 739.99,false),
 new note("note_G5",  783.99,true),
 new note("note_Ab5", 830.61,false),
 new note("note_A5",  880.00,true),
 new note("note_Bb5", 932.33,false),
 new note("note_B5",  987.77,true),
 new note("note_C6", 1046.50,true),
 new note("note_Db6",1108.73,false),
 new note("note_D6", 1174.66,true),
 new note("note_Eb6",1244.51,false),
 new note("note_E6", 1318.51,true),
 new note("note_F6", 1396.91,true),
 new note("note_Gb6",1479.98,false),
 new note("note_G6", 1567.98,true),
 new note("note_Ab6",1661.22,false),
 new note("note_A6", 1760.00,true),
 new note("note_Bb6",1864.66,false),
 new note("note_B6", 1975.53,true)
};


void setup(){
    size(440,120);
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

    piano(10,10);

}

void piano(int xPos,int yPos){
    int p = 0; 
    for (int i=0;i<notes.length;i++) {
      if (notes[i].b) {
        cp5.addButton(notes[i].name)
           .setValue(notes[i].tone)
           .setCaptionLabel("")
           .setPosition(xPos+p*20,yPos)
           .setSize(19,100)
           .setColorBackground(color(255))
           .addCallback(new CallbackListener() {
              public void controlEvent(CallbackEvent event) {
                switch(event.getAction()) {
                  case(ControlP5.ACTION_PRESSED): 
                    println("start "+event.getController().getName()); 
                    playNote(event.getController().getValue());
                    break;
                  case(ControlP5.ACTION_RELEASED): 
                    println("stop "+event.getController().getName()); 
                    break;
                }
              }
            });
        p++;  
      }  
    }  
    p = 0; 
    for (int i=0;i<notes.length;i++) {
      if (!notes[i].b) {
        cp5.addButton(notes[i].name)
           .setValue(notes[i].tone)
           .setCaptionLabel("")
           .setPosition(xPos-10+p*20,yPos)
           .setSize(19,50)
           .setColorBackground(color(0))
           .addCallback(new CallbackListener() {
              public void controlEvent(CallbackEvent event) {
                switch(event.getAction()) {
                  case(ControlP5.ACTION_PRESSED): 
                    //println("start* "+event.getController().getName()); 
                    playNote(event.getController().getValue());
                    break;
                  case(ControlP5.ACTION_RELEASED): 
                    //println("stop* "+event.getController().getName()); 
                    break;
                }
              }
            });
      }  
     if (notes[i].b) {
        p++;  
      }  
    }  
}

void sendData(byte[] l_bytes) {
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char, l_bytes);
}

/*
Keywish Penter-robot protocol
start_code  byte  ==0xAA
len         byte  length from "len" to "checksum high"
type        byte  E_TYPE
addr        byte  
function    byte  E_CONTOROL_FUNC
data        byte* some bytes of data
checksum    byte  high byte of checksum (sum from len to checksum high)
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

void playNote(float note) {
    byte pack[] = {(byte)0xAA,0x0A,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x55};
    int intBits =  Float.floatToIntBits(note);
    pack[8] = (byte) ((intBits >> 24) & 0xFF);
    pack[7] = (byte) ((intBits >> 16) & 0xFF);
    pack[6] = (byte) ((intBits >> 8)  & 0xFF);
    pack[5] = (byte) ((intBits)       & 0xFF);
    sendCommand(pack);
}

void draw(){
  background(240);
}
