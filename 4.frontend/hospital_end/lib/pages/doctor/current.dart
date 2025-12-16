import 'package:flutter/material.dart';
import 'package:hospital_end/utils/models.dart';

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
          // 上部：主诉
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
          // 下部：表单
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
