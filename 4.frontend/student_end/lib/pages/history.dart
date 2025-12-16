import 'package:flutter/material.dart';
import 'package:student_end/pages/diag_detail.dart';
import 'package:student_end/utils/record.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final List<HistoryRecord> demoData = [
    HistoryRecord(
      title: '心内科复诊',
      time: '2025-12-14 14:00',
      status: 'completed',
      chiefComplaint: '胸闷气短',
      diagnosis: '心律不齐',
      medications: const ['阿司匹林', '美托洛尔'],
    ),
    HistoryRecord(
      title: '肾内科复诊',
      time: '2025-12-12 10:00',
      status: 'on_progress',
      chiefComplaint: '水肿',
      diagnosis: '慢性肾炎',
      medications: const ['利尿剂'],
    ),
    HistoryRecord(
      title: '消化内科复诊',
      time: '2025-11-20 09:00',
      status: 'cancelled',
      chiefComplaint: '腹痛',
      diagnosis: '胃炎',
      medications: const ['奥美拉唑'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: demoData.length,
      itemBuilder: (context, index) {
        return HistoryItemWidget(record: demoData[index]);
      },
    );
  }
}

class HistoryItemWidget extends StatelessWidget {
  final HistoryRecord record;
  const HistoryItemWidget({super.key, required this.record});

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          record.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              record.time,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: getProgressValue(record.status),
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      color: getStatusColor(record.status),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  getStatusText(record.status),
                  style: TextStyle(
                      fontSize: 13, color: getStatusColor(record.status)),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HistoryDetailPage(record: record),
            ),
          );
        },
      ),
    );
  }
}
