import 'package:flutter/material.dart';
import 'package:student_end/pages/diag_detail.dart';
import 'package:student_end/utils/api.dart';
import 'package:student_end/utils/global.dart';
import 'package:student_end/utils/record.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<HistoryRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadHistory();
  }

  Future<List<HistoryRecord>> _loadHistory() async {
    final token = Global().token; // 你自己的 token 管理
    final res = await Api.recordsHistory(token!);

    if (res['status'] != true) {
      throw Exception(res['msg'] ?? '加载失败');
    }

    final List list = res['data'];
    return list.map((e) => HistoryRecord.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryRecord>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '加载出错：${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final data = snapshot.data!;
        if (data.isEmpty) {
          return const Center(child: Text('暂无历史记录'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return HistoryItemWidget(record: data[index]);
          },
        );
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
          record.chiefComplaint,
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
