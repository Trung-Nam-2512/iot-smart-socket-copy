import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doaniot/core/constants/api_constants.dart';
import 'package:doaniot/features/device/data/models/device_model.dart';

class DeviceApiService {
  Future<List<DeviceModel>> getDevices() async {
    try {
      final url = ApiConstants.devicesUrl;
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DeviceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load devices: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceModel> createDevice(DeviceModel device) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.devicesUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(device.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeviceModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create device: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating device: $e');
    }
  }

  Future<String> controlDevice(int deviceId, String payload) async {
    try {
      final url = ApiConstants.deviceControlUrl(deviceId);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'text/plain'},
        body: payload,
      );
      
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to control device: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> controlDeviceByTopic(String topic, String payload) async {
    try {
      final encodedTopic = Uri.encodeComponent(topic);
      final url = '${ApiConstants.baseUrl}/devices/control-by-topic?topic=$encodedTopic';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'text/plain'},
        body: payload,
      );
      
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to control device by topic: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

