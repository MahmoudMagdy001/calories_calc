import 'dart:convert';
import 'dart:io';

import 'package:cal_scanner/features/calories/data/models/food_item.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FoodService {
  String get _apiKey => dotenv.env['GROK_API_KEY'] ?? '';

  Future<Either<String, FoodItem>> detectFoodAndCalories(File imageFile) async {
    try {
      if (!imageFile.existsSync()) {
        return Left('File not found: ${imageFile.path}');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model':
              'meta-llama/llama-4-scout-17b-16e-instruct', // free vision model
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
                {
                  'type': 'text',
                  'text':
                      'Analyze this image and identify the food. '
                      'Estimate its calories, protein, carbs, and fat. '
                      'Return JSON only, no markdown, no explanation, in this exact format: '
                      '{"name": "food name", "calories": 100, "protein": 10, "carbs": 20, "fat": 5}',
                },
              ],
            },
          ],
          'max_tokens': 200,
        }),
      );

      if (response.statusCode != 200) {
        return Left('API error: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>;
      final firstChoice = choices[0] as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>;
      final output = message['content'] as String;

      final match = RegExp(r'\{.*\}', dotAll: true).firstMatch(output);
      if (match == null) {
        return Left('No valid JSON found in response: $output');
      }

      final foodData = jsonDecode(match.group(0)!) as Map<String, dynamic>;

      return Right(
        FoodItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: foodData['name'] as String,
          calories: (foodData['calories'] as num).toDouble(),
          protein: (foodData['protein'] as num).toDouble(),
          carbs: (foodData['carbs'] as num).toDouble(),
          fat: (foodData['fat'] as num).toDouble(),
          quantity: 100.0,
          timestamp: DateTime.now(),
        ),
      );
    } on Object catch (e) {
      return Left('Failed to detect food: $e');
    }
  }
}
