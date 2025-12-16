class HistoryRecord {
  final String title;
  final String time;
  final String status; // 'completed', 'cancelled', 'on_progress'
  final String chiefComplaint;
  final String diagnosis;
  final List<String> medications;

  HistoryRecord({
    required this.title,
    required this.time,
    required this.status,
    required this.chiefComplaint,
    required this.diagnosis,
    required this.medications,
  });
}
