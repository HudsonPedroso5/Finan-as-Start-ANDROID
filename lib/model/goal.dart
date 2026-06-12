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
}
