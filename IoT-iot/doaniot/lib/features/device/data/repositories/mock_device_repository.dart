import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/domain/repositories/device_repository.dart';

class MockDeviceRepository implements DeviceRepository {
  final List<Device> _connectedDevices = [
    Device(
      id: 'dev_1', 
      name: 'Smart Lamp', 
      type: 'light', 
      imageUrl: 'assets/den.png', 
      isOn: true,
      currentPower: 12.5,
      totalEnergy: 184.69,
      roomId: 'living_room',
    ),
    Device(
      id: 'dev_2', 
      name: 'Smart V1 CCTV', 
      type: 'camera', 
      imageUrl: 'assets/cam.png', 
      isOn: true,
      currentPower: 4.2,
      totalEnergy: 125.73,
      roomId: 'living_room',
    ),
     Device(
      id: 'dev_3', 
      name: 'Kitchen Light', 
      type: 'light', 
      imageUrl: 'assets/den.png', 
      isOn: false,
      currentPower: 0,
      totalEnergy: 45.2,
      roomId: 'kitchen',
    ),
    Device(
      id: 'dev_4', 
      name: 'Bedroom AC', 
      type: 'ac', 
      imageUrl: 'assets/dhoa.png', 
      isOn: true,
      currentPower: 850.0,
      totalEnergy: 320.5,
      roomId: 'bedroom',
    ),
  ];

  @override
  Future<void> addDevice(Device device, {String? wifiSsid, String? wifiPassword}) async {
    // Backend Friend: Implement the logic to send credentials to the device here.
    // E.g., Connect to Device's SoftAP -> Send credentials -> Wait for confirmation.
    
    await Future.delayed(const Duration(seconds: 3));
    print('Simulating adding device: ${device.name} with Wifi: $wifiSsid');
    _connectedDevices.add(device);
  }

  @override
  Future<List<Device>> getDevices() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulating a local cache or database
    return _connectedDevices;
  }

  @override
  Future<void> updateDeviceStatus(String deviceId, bool isOn) async {
    // Backend Friend: Call API to update status
    print('Toggle device $deviceId to $isOn');
  }
}
