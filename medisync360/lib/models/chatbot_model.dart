class DiagnosisResult {
  final String disease;
  final String description;
  final List<String> precautions;
  final bool consultDoctor;

  DiagnosisResult({
    required this.disease,
    required this.description,
    required this.precautions,
    required this.consultDoctor,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      disease: json['disease'],
      description: json['description'],
      precautions: List<String>.from(json['precautions'] ?? []),
      consultDoctor: json['consult_doctor'] ?? false,
    );
  }
}
