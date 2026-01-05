import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ApiConstants {
  static String get baseUrl {
    const String serverIp = '172.20.10.2';
    const String serverPort = '8080';
    const String apiPath = '/api/v2';
    
    if (kIsWeb) {
      return 'http://$serverIp:$serverPort$apiPath';
    } else if (!kIsWeb && Platform.isAndroid) {
      return 'http://$serverIp:$serverPort$apiPath';
    } else if (!kIsWeb && Platform.isIOS) {
      return 'http://$serverIp:$serverPort$apiPath';
    } else {
      return 'http://$serverIp:$serverPort$apiPath';
    }
  }
  
  
  static String get devicesUrl => '${baseUrl}/devices';
  static String deviceUrl(int id) => '${devicesUrl}/$id';
  static String deviceControlUrl(int id) => '${devicesUrl}/$id/control';
  
  static String get telemetryUrl => '${baseUrl}/telemetry';
  static String telemetryByDeviceUrl(int deviceId) => '${telemetryUrl}/$deviceId';
  static String telemetryLatestUrl(int deviceId) => '${telemetryUrl}/$deviceId/latest';
  static String telemetryRangeUrl(int deviceId) => '${telemetryUrl}/$deviceId/range';
  static String telemetryRecentUrl(int deviceId) => '${telemetryUrl}/$deviceId/recent';
  static String telemetryTemperatureUrl(int deviceId) => '${telemetryUrl}/$deviceId/temperature';
  static String telemetryHumidityUrl(int deviceId) => '${telemetryUrl}/$deviceId/humidity';
  static String telemetryPowerUrl(int deviceId) => '${telemetryUrl}/$deviceId/power';
}

