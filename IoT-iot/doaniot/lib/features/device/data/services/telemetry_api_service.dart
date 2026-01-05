import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doaniot/core/constants/api_constants.dart';
import 'package:doaniot/features/device/data/models/telemetry_model.dart';

class TelemetryApiService {
  Future<List<TelemetryModel>> getTelemetryByDevice(int deviceId) async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.telemetryByDeviceUrl(deviceId)));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TelemetryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load telemetry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching telemetry: $e');
    }
  }

  Future<TelemetryModel?> getLatestTelemetry(int deviceId) async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.telemetryLatestUrl(deviceId)));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TelemetryModel.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load latest telemetry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching latest telemetry: $e');
    }
  }

  Future<List<TelemetryModel>> getTelemetryRecent(int deviceId, {int hours = 24}) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.telemetryRecentUrl(deviceId)).replace(queryParameters: {'hours': hours.toString()}),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TelemetryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recent telemetry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recent telemetry: $e');
    }
  }

  Future<List<TelemetryModel>> getTelemetryByTemperatureRange(
    int deviceId,
    double minTemp,
    double maxTemp,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.telemetryTemperatureUrl(deviceId)).replace(
          queryParameters: {
            'minTemp': minTemp.toString(),
            'maxTemp': maxTemp.toString(),
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TelemetryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load telemetry by temperature: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching telemetry by temperature: $e');
    }
  }

  Future<List<TelemetryModel>> getTelemetryByHumidityRange(
    int deviceId,
    double minHumidity,
    double maxHumidity,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.telemetryHumidityUrl(deviceId)).replace(
          queryParameters: {
            'minHumidity': minHumidity.toString(),
            'maxHumidity': maxHumidity.toString(),
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TelemetryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load telemetry by humidity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching telemetry by humidity: $e');
    }
  }

  Future<List<TelemetryModel>> getTelemetryByMinPower(int deviceId, double minPower) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.telemetryPowerUrl(deviceId)).replace(
          queryParameters: {'minPower': minPower.toString()},
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TelemetryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load telemetry by power: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching telemetry by power: $e');
    }
  }
}

