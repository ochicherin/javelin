import javelin.*;

   String ble_device = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-ee:a4:21:1e:20:64"; // Portobellofit
// String ble_device = "BluetoothLE#BluetoothLE18:47:3d:1a:16:a6-3c:a5:50:80:bc:8a"; // JDY-16

void setup()
{
    javelin.init();
    System.out.println("Start scan ...");
    String l_devices[] = javelin.listBLEDevices();
    System.out.println("Scan done.");
    System.out.println("Device : "+ble_device);
    String l_name = javelin.getBLEDeviceName(ble_device);
    System.out.println("  Name: "+l_name);
    String l_services[] = javelin.listBLEDeviceServices(ble_device);
    if(l_services != null) {
        for(String l_service: l_services) {
            System.out.println("  Service: "+l_service);
            String l_chars[] = javelin.listBLEServiceCharacteristics(ble_device, l_service);
            if(l_chars != null) {
                for(String l_char: l_chars) {
                  System.out.println("    Characteristic: "+l_char);
                }
            }
        }
    }
    exit();
}

void draw(){
}
