/* Read data from Portobello fit one tracker
*/
import java.util.Calendar;
import java.text.SimpleDateFormat;
import javelin.*;
/*
BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-ee:a4:21:1e:20:64
Name: Portobellofit
   Service: 00001800-0000-1000-8000-00805F9B34FB
   Characteristic: 00002A00-0000-1000-8000-00805F9B34FB
   Characteristic: 00002A01-0000-1000-8000-00805F9B34FB
   Characteristic: 00002A04-0000-1000-8000-00805F9B34FB
   Service: 00001801-0000-1000-8000-00805F9B34FB
   Characteristic: 00002A05-0000-1000-8000-00805F9B34FB
   Service: 00000AF0-0000-1000-8000-00805F9B34FB
   Characteristic: 00000AF6-0000-1000-8000-00805F9B34FB
     read write
   Characteristic: 00000AF7-0000-1000-8000-00805F9B34FB
     notity read
   Characteristic: 00000AF2-0000-1000-8000-00805F9B34FB
     notify read
   Characteristic: 00000AF1-0000-1000-8000-00805F9B34FB
     read write
*/
    boolean set_echo = true;
    String ble_device  = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-ee:a4:21:1e:20:64"; // Portobellofit
    String ble_service = "00000AF0-0000-1000-8000-00805F9B34FB";
    String ble_char6   = "00000AF6-0000-1000-8000-00805F9B34FB";
    String ble_char7   = "00000AF7-0000-1000-8000-00805F9B34FB";

void setup()
{
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
    frameRate(1);
    setDate();
}

void dumpBytes(byte[] l_bytes) {
    if(l_bytes != null) {
        System.out.print("<"+l_bytes.length+">");            
        for(byte l_byte : l_bytes) {
            System.out.print("|"+l_byte);
        }
        System.out.print("|");            
      }
}

void setDate() {
    byte[] l_bytes = {0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}; 
    Calendar c = Calendar.getInstance();
    l_bytes[2] = (byte) (c.get(Calendar.YEAR) & 0xFF);
    l_bytes[3] = (byte) (c.get(Calendar.YEAR) >> 8 & 0xFF);
    l_bytes[4] = (byte) (c.get(Calendar.MONTH)+1);
    l_bytes[5] = (byte) (c.get(Calendar.DAY_OF_MONTH));
    l_bytes[6] = (byte) (c.get(Calendar.HOUR_OF_DAY));
    l_bytes[7] = (byte) (c.get(Calendar.MINUTE));
    l_bytes[8] = (byte) (c.get(Calendar.SECOND));
    l_bytes[9] = (byte) ((c.get(Calendar.DAY_OF_WEEK)+5) % 7) ;
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char6, l_bytes);
    l_bytes = javelin.getBLECharacteristicValue(ble_device,ble_service,ble_char7);
}

void showHealth() {
    byte[] l_bytes = {0x02, (byte) 0xA0}; 
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char6, l_bytes);
    l_bytes = javelin.getBLECharacteristicValue(ble_device,ble_service,ble_char7);
    //dumpBytes(l_bytes);
    int v_steps    = (l_bytes[2] & 0xFF) | ( l_bytes[3] << 8);
    int v_calories = (l_bytes[6] & 0xFF) | ( l_bytes[7] << 8);
    int v_distance = (l_bytes[10] & 0xFF) | ( l_bytes[11] << 8);
    int v_unknown  = (l_bytes[14] & 0xFF) | ( l_bytes[15] << 8);
    int v_heart    = (l_bytes[18] & 0xFF);
    print(" Steps: "+v_steps+" Calories:"+v_calories+" Distance:"+v_distance+"m Unknown:"+v_unknown+" Heart:"+v_heart);
}

void showDate() {
    byte[] l_bytes = {0x02, (byte) 0x03}; 
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char6, l_bytes);
    l_bytes = javelin.getBLECharacteristicValue(ble_device,ble_service,ble_char7);
    //dumpBytes(l_bytes);
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
    c.set(Calendar.YEAR,(l_bytes[2] & 0xFF) | ( l_bytes[3] << 8));
    c.set(Calendar.MONTH, (l_bytes[4] & 0xFF)-1);
    c.set(Calendar.DAY_OF_MONTH, (l_bytes[5] & 0xFF));
    c.set(Calendar.HOUR_OF_DAY, (l_bytes[6] & 0xFF));
    c.set(Calendar.MINUTE, (l_bytes[7] & 0xFF));
    c.set(Calendar.SECOND, (l_bytes[8] & 0xFF));
    print(" "+sdf.format(c.getTime()));
    //print(" "+c.getTime());
}

void showStatus() {
    byte[] l_bytes = {0x02, (byte) 0x01}; 
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char6, l_bytes);
    l_bytes = javelin.getBLECharacteristicValue(ble_device,ble_service,ble_char7);
    //dumpBytes(l_bytes);
    int v_battery = (l_bytes[7] & 0xFF);
    print(" Battery:"+v_battery+"%");
}

void draw(){
    showDate();
    showStatus();
    showHealth();
    println("");
}
