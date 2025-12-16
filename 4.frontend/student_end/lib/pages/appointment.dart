import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartment;
  final _chiefComplaintController = TextEditingController();
  DateTime? _selectedDate;
  int? _selectedHour;

  final List<String> _departments = [
    '心内科',
    '消化内科',
    '肾内科',
    '耳鼻喉科',
    '眼科',
  ];

  final List<int> _hours = List.generate(24, (index) => index);

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedHour == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请选择预约时间')),
        );
        return;
      }

      final appointmentInfo = '''
科室: $_selectedDepartment
主诉: ${_chiefComplaintController.text}
日期: ${_selectedDate!.toLocal().toString().split(' ')[0]}
时间: $_selectedHour:00
''';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('预约信息'),
          content: Text(appointmentInfo),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 科室选择
            Text(
              '选择科室',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.background,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDepartment,
                  hint: const Text('请选择科室'),
                  isExpanded: true,
                  items: _departments
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedDepartment = v),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 主诉填写
            Text(
              '主诉（请详细描述您的症状）',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.onBackground),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _chiefComplaintController,
              maxLines: 20,
              minLines: 20,
              decoration: InputDecoration(
                hintText: '请输入主诉内容',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.background,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              validator: (v) => v == null || v.isEmpty ? '请填写主诉内容' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(
                        '日期:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _pickDate,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(_selectedDate == null
                                ? '请选择日期'
                                : _selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(
                        '时间:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: colorScheme.background,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedHour,
                              hint: const Text('选择'),
                              isExpanded: true,
                              items: _hours
                                  .map((h) => DropdownMenuItem(
                                        value: h,
                                        child: Text('$h:00'),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedHour = v),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),

            const SizedBox(height: 32),

            // 提交按钮
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: colorScheme.primary,
              ),
              child: Text(
                '提交预约',
                style: TextStyle(fontSize: 16, color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
