import 'package:doaniot/features/device/domain/entities/device.dart';

abstract class DeviceRepository {
  /// Fetches list of devices (e.g., from server).
  Future<List<Device>> getDevices();

  /// Adds a new device.
  /// [wifiSsid] and [wifiPassword] are used if the device needs to be configured via SoftAP/BLE.
  Future<void> addDevice(Device device, {String? wifiSsid, String? wifiPassword});

  /// Toggles device state (on/off).
  Future<void> updateDeviceStatus(String deviceId, bool isOn);
}
