class Goal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  double currentAmount;
  final DateTime deadline;
  final String category;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.category,
  });

  double get progress {
    if (targetAmount == 0) return 0;
    return currentAmount / targetAmount;
  }

  double get remaining {
    return targetAmount - currentAmount;
  }

  int get daysLeft {
    return deadline.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline.toIso8601String(),
      'category': category,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline'] as String),
      category: json['category'] as String,
    );
  }
}
