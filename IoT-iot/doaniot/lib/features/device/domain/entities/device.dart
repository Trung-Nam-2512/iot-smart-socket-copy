import 'package:flutter/material.dart';
import 'package:doaniot/features/device/data/models/device_model.dart';
import 'package:doaniot/features/device/data/models/telemetry_model.dart';

class Device {
  final String id;
  final String name;
  final String type;
  final String imageUrl;
  final bool isOn;
  final double currentPower;
  final double totalEnergy;
  final String roomId;
  final DateTime? lastUpdated;
  final String? topic;
  final TelemetryModel? latestTelemetry;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    this.isOn = false,
    this.currentPower = 0.0,
    this.totalEnergy = 0.0,
    this.roomId = 'living_room',
    this.lastUpdated,
    this.topic,
    this.latestTelemetry,
  });

  factory Device.fromDeviceModel(DeviceModel model, {TelemetryModel? latestTelemetry}) {
    String deviceType = 'sensor';
    String imageUrl = 'assets/default.png';
    
    if (model.name.toLowerCase().contains('light') || model.name.toLowerCase().contains('lamp')) {
      deviceType = 'light';
      imageUrl = 'assets/den.png';
    } else if (model.name.toLowerCase().contains('camera') || model.name.toLowerCase().contains('cctv')) {
      deviceType = 'camera';
      imageUrl = 'assets/cam.png';
    } else if (model.name.toLowerCase().contains('ac') || model.name.toLowerCase().contains('air')) {
      deviceType = 'ac';
      imageUrl = 'assets/dhoa.png';
    } else if (model.name.toLowerCase().contains('fan')) {
      deviceType = 'fan';
      imageUrl = 'assets/den.png';
    }

    return Device(
      id: model.id?.toString() ?? '0',
      name: model.name,
      type: deviceType,
      imageUrl: imageUrl,
      isOn: latestTelemetry?.relay == 1,
      currentPower: latestTelemetry?.power ?? 0.0,
      totalEnergy: 0.0,
      roomId: 'living_room',
      lastUpdated: latestTelemetry?.timestamp,
      topic: model.topic,
      latestTelemetry: latestTelemetry,
    );
  }

  Device copyWith({
    String? id,
    String? name,
    String? type,
    String? imageUrl,
    bool? isOn,
    double? currentPower,
    double? totalEnergy,
    String? roomId,
    DateTime? lastUpdated,
    String? topic,
    TelemetryModel? latestTelemetry,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      isOn: isOn ?? this.isOn,
      currentPower: currentPower ?? this.currentPower,
      totalEnergy: totalEnergy ?? this.totalEnergy,
      roomId: roomId ?? this.roomId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      topic: topic ?? this.topic,
      latestTelemetry: latestTelemetry ?? this.latestTelemetry,
    );
  }
}
