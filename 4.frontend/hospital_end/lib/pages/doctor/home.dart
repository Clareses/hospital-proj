import 'package:flutter/material.dart';
import 'package:hospital_end/utils/api.dart';
import 'package:hospital_end/utils/global.dart';
import 'package:hospital_end/utils/models.dart';

enum PageType { current, history }

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  PageType _page = PageType.current;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopBar(),
          Expanded(
            child: Row(
              children: [
                Sidebar(
                  page: _page,
                  onSelect: (p) => setState(() => _page = p),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _page == PageType.current
                      ? const CurrentConsultationPage()
                      : const HistoryConsultationPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= Top Bar =================
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Text(
            Global().userName!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '日期：${DateTime.now().toString().split(' ').first}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ================= Sidebar =================
class Sidebar extends StatelessWidget {
  final PageType page;
  final ValueChanged<PageType> onSelect;

  const Sidebar({super.key, required this.page, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          _item(context, '当前问诊', PageType.current),
          _item(context, '历史问诊', PageType.history),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String text, PageType type) {
    final selected = page == type;
    return ListTile(
      selected: selected,
      title: Text(text),
      onTap: () => onSelect(type),
    );
  }
}

// ================= 当前问诊 =================
class CurrentConsultationPage extends StatefulWidget {
  const CurrentConsultationPage({super.key});

  @override
  State<CurrentConsultationPage> createState() =>
      _CurrentConsultationPageState();
}

class _CurrentConsultationPageState extends State<CurrentConsultationPage> {
  int? _selectedIndex;
  late Future<List<Map<String, dynamic>>> _futureRecords;

  @override
  void initState() {
    super.initState();
    _futureRecords = _loadRecords();
  }

  Future<List<Map<String, dynamic>>> _loadRecords() async {
    final res = await Api.recordsList(Global().token!);
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureRecords,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data!;

        return Row(
          children: [
            // ===== 左侧患者列表 =====
            SizedBox(
              width: 280,
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final item = records[index];
                  return ListTile(
                    title: Text(item['name']),
                    selected: _selectedIndex == index,
                    onTap: () => setState(() => _selectedIndex = index),
                  );
                },
              ),
            ),

            const VerticalDivider(width: 1),

            // ===== 右侧详情 =====
            Expanded(
              child: _selectedIndex == null
                  ? const Center(child: Text('请选择患者'))
                  : ConsultationDetail(
                      recordId: records[_selectedIndex!]['record_id'],
                      onSubmit: () {
                        setState(() {
                          records.removeAt(_selectedIndex!);
                          _selectedIndex = null;
                        });
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class ConsultationDetail extends StatelessWidget {
  final int recordId;
  final VoidCallback onSubmit;

  const ConsultationDetail({
    super.key,
    required this.recordId,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ===== 主诉 =====
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('主诉：',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: Api.getRecord(recordId, Global().token!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Text(snapshot.data!['complaint'] ?? '');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ===== 诊断表单 =====
          Expanded(
            child: DiagnosisForm(
              recordId: recordId,
              onSubmit: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class DiagnosisForm extends StatefulWidget {
  final int recordId;
  final VoidCallback onSubmit;

  const DiagnosisForm({
    super.key,
    required this.recordId,
    required this.onSubmit,
  });

  @override
  State<DiagnosisForm> createState() => _DiagnosisFormState();
}

class _DiagnosisFormState extends State<DiagnosisForm> {
  final _diagnosisCtrl = TextEditingController();
  final _countCtrl = TextEditingController();

  String? _selectedDrugId;

  late final Future<List<String>> _futureDrugs;

  @override
  void initState() {
    super.initState();
    _futureDrugs = _loadDrugs();
  }

  Future<List<String>> _loadDrugs() async {
    final res = await Api.drugList();
    List<String> ret = [];
    for (var item in res["data"]) {
      ret.add(item["name"]);
    }
    return ret;
  }

  Future<void> _submit(List<String> drugs) async {
    if (_selectedDrugId == null) return;

    final drug = drugs.firstWhere((d) => d == _selectedDrugId);

    final res = await Api.postRecord(
      Global().token!,
      widget.recordId,
      _diagnosisCtrl.text,
      [
        {
          'name': drug,
          'amount': 1,
        }
      ],
    );

    if (res['status'] == true) {
      widget.onSubmit();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('提交成功')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _futureDrugs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('加载药品失败：${snapshot.error}'),
            ),
          );
        }

        final drugs = snapshot.data!;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _diagnosisCtrl,
                  decoration: const InputDecoration(labelText: '诊断结论'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedDrugId,
                  decoration: const InputDecoration(labelText: '选择药品'),
                  items: drugs
                      .map(
                        (d) => DropdownMenuItem<String>(
                          value: d,
                          child: Text(d),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedDrugId = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _countCtrl,
                  decoration: const InputDecoration(labelText: '数量'),
                  keyboardType: TextInputType.number,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _submit(drugs),
                    child: const Text('提交诊断'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HistoryConsultationPage extends StatefulWidget {
  const HistoryConsultationPage({super.key});

  @override
  State<HistoryConsultationPage> createState() =>
      _HistoryConsultationPageState();
}

class _HistoryConsultationPageState extends State<HistoryConsultationPage> {
  late final Future<List<Map<String, dynamic>>> _futureHistory;

  String _keyword = '';
  Map<String, dynamic>? _selected;

  @override
  void initState() {
    super.initState();
    _futureHistory = _loadHistory();
  }

  Future<List<Map<String, dynamic>>> _loadHistory() async {
    final res = await Api.recordsHistory(Global().token!);
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('加载失败：${snapshot.error}'));
        }

        final all = snapshot.data!;
        final filtered =
            all.where((e) => (e['name'] as String).contains(_keyword)).toList();

        return Row(
          children: [
            // ================= 左侧列表 =================
            SizedBox(
              width: 280,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: '搜索患者',
                      ),
                      onChanged: (v) => setState(() => _keyword = v),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final item = filtered[i];
                        return ListTile(
                          title: Text(item['complaint']),
                          subtitle: Text(item['department'] ?? ''),
                          selected: _selected == item,
                          onTap: () => setState(() => _selected = item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const VerticalDivider(width: 1),

            // ================= 右侧详情 =================
            Expanded(
              child: _selected == null
                  ? const Center(child: Text('请选择历史记录'))
                  : _HistoryDetail(data: _selected!),
            ),
          ],
        );
      },
    );
  }
}

class _HistoryDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  const _HistoryDetail({required this.data});

  @override
  Widget build(BuildContext context) {
    final drugs = List<Map<String, dynamic>>.from(data['drug'] ?? []);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['complaint'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                '${data['department']}  ·  ${data['time']}',
                style: const TextStyle(color: Colors.black54),
              ),
              const Divider(height: 32),
              const Text(
                '主诉',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(data['complaint'] ?? ''),
              const SizedBox(height: 16),
              const Text(
                '诊断',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(data['diagnosis'] ?? ''),
              const SizedBox(height: 16),
              const Text(
                '用药',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              if (drugs.isEmpty)
                const Text('无')
              else
                ...drugs.map(
                  (d) => Text(
                    '• ${d['name']} × ${d['amount']}',
                  ),
                ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(data['progress']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
