import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisync360/Data/Repositories/chatbot_repository.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  
  final ChatbotRepository repository;

  ChatbotBloc(this.repository) : super(ChatbotInitial()) {
    on<LoadSymptomsEvent>(_onLoadSymptoms);
    on<AddSymptomEvent>(_onAddSymptom);
    on<SubmitDiagnosisEvent>(_onSubmitDiagnosis);
  }

  List<String> allSymptoms = [];
  List<String> selectedSymptoms = [];

  Future<void> _onLoadSymptoms(
      LoadSymptomsEvent event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoading());
    try {
      allSymptoms = await repository.fetchSymptoms();
      emit(ChatbotLoaded(allSymptoms: allSymptoms, selectedSymptoms: selectedSymptoms));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  void _onAddSymptom(AddSymptomEvent event, Emitter<ChatbotState> emit) {
    if (!selectedSymptoms.contains(event.symptom)) {
      selectedSymptoms.add(event.symptom);
    }
    emit(ChatbotLoaded(allSymptoms: allSymptoms, selectedSymptoms: selectedSymptoms));
  }

  Future<void> _onSubmitDiagnosis(
      SubmitDiagnosisEvent event, Emitter<ChatbotState> emit) async {
    emit(ChatbotDiagnosing());
    try {
      final result = await repository.diagnose(selectedSymptoms, event.days);
      emit(ChatbotDiagnosisResult(result));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }
}
