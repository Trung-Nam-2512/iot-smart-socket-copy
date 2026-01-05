import 'package:doaniot/features/device/domain/entities/device.dart';
import 'package:doaniot/features/device/domain/repositories/device_repository.dart';
import 'package:doaniot/features/device/data/services/device_api_service.dart';
import 'package:doaniot/features/device/data/services/telemetry_api_service.dart';
import 'package:doaniot/features/device/data/models/device_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceApiService _deviceApiService;
  final TelemetryApiService _telemetryApiService;

  DeviceRepositoryImpl({
    DeviceApiService? deviceApiService,
    TelemetryApiService? telemetryApiService,
  })  : _deviceApiService = deviceApiService ?? DeviceApiService(),
        _telemetryApiService = telemetryApiService ?? TelemetryApiService();

  @override
  Future<List<Device>> getDevices() async {
    try {
      final deviceModels = await _deviceApiService.getDevices();
      final devices = <Device>[];

      for (final model in deviceModels) {
        if (model.id != null) {
          try {
            final latestTelemetry = await _telemetryApiService.getLatestTelemetry(model.id!);
            final device = Device.fromDeviceModel(model, latestTelemetry: latestTelemetry);
            
            if (model.topic != null && 
                (model.topic == '/topic/qos0' || model.topic.startsWith('/topic/'))) {
              devices.add(device);
            } else if (model.topic == null || model.topic.isEmpty) {
              devices.add(device);
            }
          } catch (e) {
            final device = Device.fromDeviceModel(model);
            if (model.topic != null && 
                (model.topic == '/topic/qos0' || model.topic.startsWith('/topic/'))) {
              devices.add(device);
            } else if (model.topic == null || model.topic.isEmpty) {
              devices.add(device);
            }
          }
        }
      }

      return devices;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addDevice(Device device, {String? wifiSsid, String? wifiPassword}) async {
    try {
      final deviceModel = DeviceModel(
        name: device.name,
        topic: device.topic ?? '/topic/qos0',
      );
      await _deviceApiService.createDevice(deviceModel);
    } catch (e) {
      throw Exception('Failed to add device: $e');
    }
  }

  @override
  Future<void> updateDeviceStatus(String deviceId, bool isOn) async {
    try {
      final id = int.tryParse(deviceId);
      if (id == null || id == 0) {
        final payload = isOn ? '1' : '0';
        await _deviceApiService.controlDeviceByTopic('/topic/qos0', payload);
        return;
      }
      final payload = isOn ? '1' : '0';
      await _deviceApiService.controlDevice(id, payload);
    } catch (e) {
      rethrow;
    }
  }
}

