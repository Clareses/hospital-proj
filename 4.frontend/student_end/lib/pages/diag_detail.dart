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

  Widget _section(String title, Widget child) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('诊断'),
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 标题区
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 诊断标题
                    Text(
                      record.diagnosis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    /// 医生 / 科室名（小字）
                    Text(
                      '医生：${record.title}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      record.time,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 进度条
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
                      style: TextStyle(
                        fontSize: 15,
                        color: getStatusColor(record.status),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 主诉
            _section(
              '主诉',
              Text(
                record.chiefComplaint,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            /// 诊断说明
            _section(
              '诊断结果',
              Text(
                record.diagnosis,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            /// 药物
            _section(
              '药物清单',
              record.medications.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: record.medications
                          .map(
                            (m) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '• $m',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : const Text(
                      '无用药记录',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
