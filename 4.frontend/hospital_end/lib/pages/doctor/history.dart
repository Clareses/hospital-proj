import 'package:flutter/material.dart';
import 'package:hospital_end/utils/models.dart';

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
