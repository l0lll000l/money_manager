class TransactionModel {
  final int? id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String icon;

  TransactionModel({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'icon': icon,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      icon: map['icon'],
    );
  }
}
