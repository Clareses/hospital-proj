import 'package:flutter/material.dart';
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
          const Text(
            '张医生  |  心内科',
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
  final List<Patient> _patients = List.generate(
    5,
    (i) => Patient('患者$i', 30 + i, '头痛、乏力'),
  );

  Patient? _selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧列表
        SizedBox(
          width: 280,
          child: ListView.builder(
            itemCount: _patients.length,
            itemBuilder: (context, index) {
              final p = _patients[index];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('年龄：${p.age}'),
                selected: _selected == p,
                onTap: () => setState(() => _selected = p),
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        // 右侧详情
        Expanded(
          child: _selected == null
              ? const Center(child: Text('请选择患者'))
              : ConsultationDetail(
                  patient: _selected!,
                  onSubmit: () {
                    setState(() {
                      _patients.remove(_selected);
                      _selected = null;
                    });
                  },
                ),
        ),
      ],
    );
  }
}

class ConsultationDetail extends StatelessWidget {
  final Patient patient;
  final VoidCallback onSubmit;

  const ConsultationDetail(
      {super.key, required this.patient, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('主诉：',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(patient.complaint)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: DiagnosisForm(onSubmit: onSubmit)),
        ],
      ),
    );
  }
}

class DiagnosisForm extends StatefulWidget {
  final VoidCallback onSubmit;
  const DiagnosisForm({super.key, required this.onSubmit});

  @override
  State<DiagnosisForm> createState() => _DiagnosisFormState();
}

class _DiagnosisFormState extends State<DiagnosisForm> {
  final _diagnosisCtrl = TextEditingController();
  String? _drug;
  final _countCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();

  final List<String> _drugs = ['阿司匹林', '布洛芬', '对乙酰氨基酚'];

  @override
  Widget build(BuildContext context) {
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
              value: _drug,
              items: _drugs
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _drug = v),
              decoration: const InputDecoration(labelText: '选择药品'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _countCtrl,
              decoration: const InputDecoration(labelText: '数量'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _remarkCtrl,
              decoration: const InputDecoration(labelText: '备注'),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: widget.onSubmit,
                child: const Text('提交诊断'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= 历史问诊 =================
class HistoryConsultationPage extends StatefulWidget {
  const HistoryConsultationPage({super.key});

  @override
  State<HistoryConsultationPage> createState() =>
      _HistoryConsultationPageState();
}

class _HistoryConsultationPageState extends State<HistoryConsultationPage> {
  final List<Patient> _all = List.generate(
    8,
    (i) => Patient('历史患者$i', 40 + i, '既往主诉'),
  );

  String _keyword = '';
  Patient? _selected;

  @override
  Widget build(BuildContext context) {
    final filtered = _all.where((p) => p.name.contains(_keyword)).toList();

    return Row(
      children: [
        SizedBox(
          width: 280,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: '搜索患者'),
                  onChanged: (v) => setState(() => _keyword = v),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    return ListTile(
                      title: Text(p.name),
                      onTap: () => setState(() => _selected = p),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selected == null
              ? const Center(child: Text('请选择历史记录'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('这里展示 ${_selected!.name} 的历史诊断详情'),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
