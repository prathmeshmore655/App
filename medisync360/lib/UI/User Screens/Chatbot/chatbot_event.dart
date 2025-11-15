import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSymptomsEvent extends ChatbotEvent {}

class AddSymptomEvent extends ChatbotEvent {
  final String symptom;
  AddSymptomEvent(this.symptom);

  @override
  List<Object?> get props => [symptom];
}

class SubmitDiagnosisEvent extends ChatbotEvent {
  final int days;
  SubmitDiagnosisEvent(this.days);

  @override
  List<Object?> get props => [days];
}
