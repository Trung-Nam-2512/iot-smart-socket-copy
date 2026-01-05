class DeviceModel {
  final int? id;
  final String name;
  final String topic;

  DeviceModel({
    this.id,
    required this.name,
    required this.topic,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      topic: json['topic'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'topic': topic,
    };
  }
}

