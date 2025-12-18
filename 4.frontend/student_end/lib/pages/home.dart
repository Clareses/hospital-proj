import 'package:flutter/material.dart';
import 'package:student_end/pages/appointment.dart';
import 'package:student_end/pages/history.dart';
import 'package:student_end/pages/login.dart';
import 'package:student_end/utils/api.dart';
import 'package:student_end/utils/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentTitle = 'Home';

  final hospitalTips = """  同学：
    你好！欢迎使用福州大学校医院系统。
    近日温差较大，注意及时添衣保暖。如出现发热、咳嗽等症状，请及时就医。
    校医院将 24 小时守护你的健康。

    联系电话：123456
""";

  void _onSelect(String title) {
    setState(() {
      _currentTitle = title;
    });
    Navigator.pop(context); // 关闭 Drawer
  }

  Widget _buildBody() {
    final store = Global();

    switch (_currentTitle) {
      case 'Home':
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCurrentProgress(Api.current(store.token!)),
              const SizedBox(height: 16),
              buildHint(hospitalTips),
            ],
          ),
        );
      case 'History':
        return HistoryPage();
      case 'Appointment':
        return AppointmentPage(onfinish: () {
          setState(() {
            _currentTitle = 'Home';
          });
        });
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Global();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      drawer: buildDrawer(store, context),
      body: _buildBody(),
      backgroundColor: colorScheme.background,
    );
  }

  Widget buildCurrentProgress(Future<Map<String, dynamic>> ongoingFuture) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<Map<String, dynamic>>(
      future: ongoingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: colorScheme.surface,
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 0),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: colorScheme.surface,
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 0),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  '加载出错: ${snapshot.error}',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ),
          );
        }

        final ongoingEvent = snapshot.data!;

        print(ongoingEvent);

        if (ongoingEvent['status'] == false) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: colorScheme.surface,
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 0),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  '目前没有正在进行的事件噢',
                  style: TextStyle(
                      fontSize: 16, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          );
        }

        double progress = ongoingEvent['progress']! == "pending"
            ? 0
            : ongoingEvent['progress'] == "processing"
                ? 0.5
                : 1;

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: colorScheme.surface,
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '正在进行',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ongoingEvent['overview']! as String,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface),
                ),
                const SizedBox(height: 6),
                Text(
                  '预约时间: ${ongoingEvent['time']} | 科室: ${ongoingEvent['department']}',
                  style: TextStyle(
                      fontSize: 15, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: colorScheme.surfaceVariant,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          ongoingEvent['progress'],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Card buildHint(String hospitalTips) {
    final colorScheme = Theme.of(context).colorScheme;

    final store = Global();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '医院温馨提示',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      store.userName! + hospitalTips,
                      style:
                          TextStyle(fontSize: 16, color: colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer(Global store, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(store.userName ?? 'Unknown User'),
            accountEmail: Text(store.userId ?? ''),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
            decoration: BoxDecoration(color: colorScheme.primary),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => _onSelect('Home'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () => _onSelect('History'),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Appointment'),
            onTap: () => _onSelect('Appointment'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await store.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
