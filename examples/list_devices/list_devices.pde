import javelin.*;

void setup()
{
  	javelin.init();
  	System.out.println("Start scan ...");
  	String l_devices[] = javelin.listBLEDevices();
  	if(l_devices != null)	{
    		System.out.println("Devices: ");
    		for(String l_device: l_devices)	{
      			System.out.print("Device : "+l_device);
      			String l_name = javelin.getBLEDeviceName(l_device);
      			System.out.println("  Name: "+l_name);
    		}
    }
  	System.out.println("Scan done.");
    exit();
}

void draw(){
}
