class UserData {
  final double weight;
  final double height;
  final int age;
  final String activityLevel;
  final String gender; // New gender field
  final String goal;
  final int estimatedCalories;
  final int proteinGoal;
  final int fatGoal;
  final int carbsGoal;

  UserData({
    required this.weight,
    required this.height,
    required this.age,
    required this.activityLevel,
    required this.gender, // Include gender
    required this.goal,
    required this.estimatedCalories,
    required this.proteinGoal,
    required this.fatGoal,
    required this.carbsGoal,
  });

  Map<String, dynamic> toJson() => {
    'weight': weight,
    'height': height,
    'age': age,
    'activityLevel': activityLevel,
    'gender': gender, // Save gender
    'goal': goal,
    'estimatedCalories': estimatedCalories,
    'proteinGoal': proteinGoal,
    'fatGoal': fatGoal,
    'carbsGoal': carbsGoal,
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    weight: (json['weight'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
    age: (json['age'] as num).toInt(),
    activityLevel: json['activityLevel'] as String,
    gender: json['gender'] as String, // Load gender
    goal: json['goal'] as String,
    estimatedCalories: (json['estimatedCalories'] as num).toInt(),
    proteinGoal: (json['proteinGoal'] as num).toInt(),
    fatGoal: (json['fatGoal'] as num).toInt(),
    carbsGoal: (json['carbsGoal'] as num).toInt(),
  );
}
