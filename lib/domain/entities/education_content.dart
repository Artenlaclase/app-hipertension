import 'package:equatable/equatable.dart';

class EducationContent extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String body;
  final String category; // sodio, etiquetas, mitos, dash
  final int orderIndex;
  final String? imageUrl;
  final bool isRead;

  const EducationContent({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.category,
    required this.orderIndex,
    this.imageUrl,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        body,
        category,
        orderIndex,
        imageUrl,
        isRead,
      ];
}
