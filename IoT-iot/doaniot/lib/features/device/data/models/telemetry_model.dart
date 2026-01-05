class TelemetryModel {
  final int? id;
  final int? deviceId;
  final String? payload;
  final double? voltage;
  final double? current;
  final double? power;
  final double? temperature;
  final double? humidity;
  final int? relay;
  final DateTime? timestamp;

  TelemetryModel({
    this.id,
    this.deviceId,
    this.payload,
    this.voltage,
    this.current,
    this.power,
    this.temperature,
    this.humidity,
    this.relay,
    this.timestamp,
  });

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      id: json['id'] as int?,
      deviceId: json['deviceId'] as int?,
      payload: json['payload'] as String?,
      voltage: json['voltage'] != null ? (json['voltage'] as num).toDouble() : null,
      current: json['current'] != null ? (json['current'] as num).toDouble() : null,
      power: json['power'] != null ? (json['power'] as num).toDouble() : null,
      temperature: json['temperature'] != null ? (json['temperature'] as num).toDouble() : null,
      humidity: json['humidity'] != null ? (json['humidity'] as num).toDouble() : null,
      relay: json['relay'] as int?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (deviceId != null) 'deviceId': deviceId,
      if (payload != null) 'payload': payload,
      if (voltage != null) 'voltage': voltage,
      if (current != null) 'current': current,
      if (power != null) 'power': power,
      if (temperature != null) 'temperature': temperature,
      if (humidity != null) 'humidity': humidity,
      if (relay != null) 'relay': relay,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    };
  }
}

