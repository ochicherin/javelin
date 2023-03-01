package javelin;

public class javelin {
	public static native String[] listBLEDevices();
	public static native String getBLEDeviceName(String a_dev_id);
	public static native String[] listBLEDeviceServices(String a_dev_id);
	public static native String[] listBLEServiceCharacteristics(String a_dev_id, String a_service_uuid);
	public static native byte[] getBLECharacteristicValue(String a_dev_id, String a_service_uuid, String a_characterics_uuid);
	public static native boolean setBLECharacteristicValue(String a_dev_id, String a_service_uuid, String a_characterics_uuid, byte[] a_value);
	
	public static native boolean watchBLECharacteristicChanges(String a_dev_id, String a_service_uuid, String a_characterics_uuid);
	public static native boolean clearBLECharacteristicChanges(String a_dev_id, String a_service_uuid, String a_characterics_uuid);
	public static native byte[] waitForBLECharacteristicChanges(String a_dev_id, String a_service_uuid, String a_characterics_uuid,
			int a_timeout_ms);
	public static native boolean unWatchBLECharacteristicChanges(String a_dev_id, String a_service_uuid, String a_characterics_uuid);
	public static void init(){
		System.out.print("Load dlls ...");
//		System.loadLibrary("api-ms-win-core-synch-l1-2-0");
//		System.loadLibrary("api-ms-win-core-synch-l1-1-0");
		System.loadLibrary("api-ms-win-core-processthreads-l1-1-0");
		System.loadLibrary("api-ms-win-core-debug-l1-1-0");
		System.loadLibrary("api-ms-win-core-errorhandling-l1-1-0");
		System.loadLibrary("api-ms-win-core-string-l1-1-0");
		System.loadLibrary("api-ms-win-core-profile-l1-1-0");
		System.loadLibrary("api-ms-win-core-sysinfo-l1-1-0");
		System.loadLibrary("api-ms-win-core-interlocked-l1-1-0");
		System.loadLibrary("api-ms-win-core-winrt-l1-1-0");
		System.loadLibrary("api-ms-win-core-heap-l1-1-0");
		System.loadLibrary("api-ms-win-core-memory-l1-1-0");
		System.loadLibrary("api-ms-win-core-libraryloader-l1-2-0");
		System.loadLibrary("OLEAUT32");
		System.loadLibrary("ucrtbased");
		System.loadLibrary("concrt140_app");
		System.loadLibrary("vcruntime140_app");
		System.loadLibrary("msvcp140_app");
		System.loadLibrary("vcruntime140_1_app");
		System.loadLibrary("javelin");
		System.out.println(" done.");
	} 
}
