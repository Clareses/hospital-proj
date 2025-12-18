class HistoryRecord {
  final String title;
  final String time;
  final String status;
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

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    // 后端 progress -> 前端 status
    String status;
    switch (json['progress']) {
      case 'done':
        status = 'completed';
        break;
      case 'cancelled':
        status = 'cancelled';
        break;
      default:
        status = 'on_progress';
    }

    return HistoryRecord(
      title: json['name'] ?? json['department'] ?? '未知',
      time: json['time'] ?? '',
      status: status,
      chiefComplaint: json['complaint'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      medications: (json['drug'] as List<dynamic>? ?? [])
          .map((d) => d['name'].toString())
          .toList(),
    );
  }
}
