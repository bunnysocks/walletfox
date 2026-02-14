class AiSuggestion {
  final String name;
  final double monthlyCost;
  final String notes;

  AiSuggestion({
    required this.name,
    required this.monthlyCost,
    required this.notes
  });

  factory AiSuggestion.fromJson(Map<String, dynamic> json) {
    return AiSuggestion(name: json['name'] ?? '', monthlyCost: (json['monthlyCost'] ?? 0).toDouble(), notes: json['notes'] ?? '');
  }
}