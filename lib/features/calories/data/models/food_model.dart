import 'package:cal_scanner/features/calories/domain/entities/food.dart';

class FoodModel {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double quantity;
  final String? imageUrl;
  final DateTime timestamp;

  const FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.quantity,
    required this.timestamp,
    this.imageUrl,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
    id: json['id'] as String,
    name: json['name'] as String,
    calories: (json['calories'] as num).toDouble(),
    protein: (json['protein'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    fat: (json['fat'] as num).toDouble(),
    quantity: (json['quantity'] as num).toDouble(),
    imageUrl: json['imageUrl'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'quantity': quantity,
    'imageUrl': imageUrl,
    'timestamp': timestamp.toIso8601String(),
  };

  Food toDomain() => Food(
    id: id,
    name: name,
    calories: calories,
    protein: protein,
    carbs: carbs,
    fat: fat,
    quantity: quantity,
    imageUrl: imageUrl,
    timestamp: timestamp,
  );

  factory FoodModel.fromDomain(Food food) => FoodModel(
    id: food.id,
    name: food.name,
    calories: food.calories,
    protein: food.protein,
    carbs: food.carbs,
    fat: food.fat,
    quantity: food.quantity,
    imageUrl: food.imageUrl,
    timestamp: food.timestamp,
  );
}
