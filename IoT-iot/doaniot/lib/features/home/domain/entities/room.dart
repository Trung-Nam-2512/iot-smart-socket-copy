import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Room({
    required this.id,
    required this.name,
    this.imageUrl = '',
  });

  @override
  List<Object?> get props => [id, name, imageUrl];
}
