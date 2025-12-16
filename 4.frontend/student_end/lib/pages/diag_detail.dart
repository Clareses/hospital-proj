import "package:flutter/material.dart";
import "package:student_end/utils/record.dart";

class HistoryDetailPage extends StatelessWidget {
  final HistoryRecord record;
  const HistoryDetailPage({super.key, required this.record});

  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'on_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  double getProgressValue(String status) {
    switch (status) {
      case 'completed':
        return 1.0;
      case 'cancelled':
        return 0.0;
      case 'on_progress':
        return 0.5;
      default:
        return 0.0;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'completed':
        return '完成';
      case 'cancelled':
        return '已取消';
      case 'on_progress':
        return '进行中';
      default:
        return '未知';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              record.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              record.time,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: getProgressValue(record.status),
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                color: getStatusColor(record.status),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              getStatusText(record.status),
              style:
                  TextStyle(fontSize: 16, color: getStatusColor(record.status)),
            ),
            const SizedBox(height: 20),
            const Text(
              '主诉',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              record.chiefComplaint,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '诊断',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              record.diagnosis,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '药物清单',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...record.medications.map((m) => Text(
                  '• $m',
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
