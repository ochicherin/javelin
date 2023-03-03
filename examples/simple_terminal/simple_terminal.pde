import javelin.*;

    boolean set_echo = true;
//  String ble_device  = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-ee:a4:21:1e:20:64"; // Portobellofit
    String ble_device  = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-3c:a5:50:80:bc:8a"; // JDY-16
    String ble_service = "0000FFE0-0000-1000-8000-00805F9B34FB";
    String ble_char    = "0000FFE1-0000-1000-8000-00805F9B34FB";

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
    frameRate(2);
    System.out.print("Characteristic watch...");
    boolean watchChanges = javelin.watchBLECharacteristicChanges(ble_device,ble_service,ble_char);
    if (watchChanges) {
        System.out.println(" enabled. Terminal ready for use.");
    } else {
        System.out.println(" disabled. Terminal cannot be used.");
        exit();
    }  
    printStr("*** Welcome to Simple Terminal ***\n");
}

void printStr(String Str) {
    byte[] l_bytes = Str.getBytes();
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char, l_bytes);
}

public static byte[] concat(byte[]... arrays) {
    int length = 0;
    for (byte[] array : arrays) {
        length += array.length;
    }
    byte[] result = new byte[length];
    int pos = 0;
    for (byte[] array : arrays) {
        System.arraycopy(array, 0, result, pos, array.length);
        pos += array.length;
    }
    return result;
}

void draw(){
    byte[] l_bytes = javelin.waitForBLECharacteristicChanges(ble_device,ble_service,ble_char, 10);
    if(l_bytes != null) {
        byte[] l_bytes2 = javelin.waitForBLECharacteristicChanges(ble_device,ble_service,ble_char, 0);
        while(l_bytes2 != null) {
            l_bytes = concat(l_bytes,l_bytes2);
            l_bytes2 = javelin.waitForBLECharacteristicChanges(ble_device,ble_service,ble_char, 0);
        }  
        //System.out.print("<"+l_bytes.length+">[");            
        for(byte l_byte : l_bytes) {
            System.out.write(l_byte);
            //System.out.print("<"+l_byte+">");
        }
        //System.out.print("]");            
      }
}

void keyPressed()
{
    byte[] l_bytes = {(byte) key}; 
    javelin.setBLECharacteristicValue(ble_device,ble_service,ble_char, l_bytes);
    if (set_echo) System.out.print(key);
}  
