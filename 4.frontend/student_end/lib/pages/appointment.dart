import 'package:flutter/material.dart';
import 'package:student_end/utils/api.dart';
import 'package:student_end/utils/global.dart';

class AppointmentPage extends StatefulWidget {
  final void Function() onfinish;

  const AppointmentPage({super.key, required this.onfinish});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _chiefComplaintController = TextEditingController();

  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _doctors = [];

  int? _selectedDepartmentId;
  int? _selectedDoctorId;

  DateTime? _selectedDate;
  int? _selectedHour;

  bool _loadingDepartments = true;
  bool _loadingDoctors = false;

  final List<int> _hours = List.generate(24, (i) => i);

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    super.dispose();
  }

  Future<void> _loadDepartments() async {
    try {
      final data = await Api.departments();
      setState(() {
        _departments = data;
        _loadingDepartments = false;
      });
    } catch (_) {
      setState(() => _loadingDepartments = false);
    }
  }

  Future<void> _loadDoctors(int departmentId) async {
    setState(() {
      _loadingDoctors = true;
      _doctors = [];
      _selectedDoctorId = null;
    });

    final data = await Api.doctorsByDepartment(departmentId);

    setState(() {
      _doctors = data;
      _loadingDoctors = false;
    });
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDepartmentId == null ||
        _selectedDoctorId == null ||
        _selectedDate == null ||
        _selectedHour == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请完整填写预约信息')));
      return;
    }

    final date =
        '${_selectedDate!.toIso8601String().split("T")[0]} ${_selectedHour!}:00';

    final res = await Api.addRecord(
      Global().token!,
      departmentId: _selectedDepartmentId!,
      doctorId: _selectedDoctorId!,
      complaint: _chiefComplaintController.text,
      date: date,
    );

    if (res['status'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('预约成功')));
      widget.onfinish();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('预约失败')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          /// 科室
          const Text('选择科室', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _loadingDepartments
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<int>(
                  value: _selectedDepartmentId,
                  items: _departments
                      .map((d) => DropdownMenuItem(
                            value: d['id'] as int,
                            child: Text(d['name']),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _selectedDepartmentId = v);
                    if (v != null) _loadDoctors(v);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '请选择科室',
                  ),
                ),

          const SizedBox(height: 16),

          /// 医生
          const Text('选择医生', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _loadingDoctors
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<int>(
                  value: _selectedDoctorId,
                  items: _doctors
                      .map((d) => DropdownMenuItem(
                            value: d['id'] as int,
                            child: Text(d['name']),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedDoctorId = v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '请选择医生',
                  ),
                ),

          const SizedBox(height: 16),

          /// 主诉
          const Text('主诉', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _chiefComplaintController,
            minLines: 6,
            maxLines: 6,
            validator: (v) => v == null || v.isEmpty ? '请输入主诉' : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '请描述症状',
            ),
          ),

          const SizedBox(height: 16),

          /// 日期 + 时间
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _pickDate,
                child: Text(_selectedDate == null
                    ? '选择日期'
                    : _selectedDate!.toString().split(' ')[0]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedHour,
                hint: const Text('时间'),
                items: _hours
                    .map(
                        (h) => DropdownMenuItem(value: h, child: Text('$h:00')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedHour = v),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          /// 提交
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('提交预约', style: TextStyle(color: colorScheme.onPrimary)),
          ),
        ]),
      ),
    );
  }
}
