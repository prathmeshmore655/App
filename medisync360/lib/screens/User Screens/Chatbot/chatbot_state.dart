import 'package:equatable/equatable.dart';
import 'package:medisync360/models/chatbot_model.dart';

class ChatbotState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<String> allSymptoms;
  final List<String> selectedSymptoms;

  ChatbotLoaded({
    required this.allSymptoms,
    required this.selectedSymptoms,
  });

  @override
  List<Object?> get props => [allSymptoms, selectedSymptoms];
}

class ChatbotDiagnosing extends ChatbotState {}

class ChatbotDiagnosisResult extends ChatbotState {
  final DiagnosisResult result;
  ChatbotDiagnosisResult(this.result);

  @override
  List<Object?> get props => [result];
}

class ChatbotError extends ChatbotState {
  final String message;
  ChatbotError(this.message);

  @override
  List<Object?> get props => [message];
}
