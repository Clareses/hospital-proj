import 'package:flutter/material.dart';

enum AdminPage { userManage, drugManage }

class AdminHomePage extends StatefulWidget {
  AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AdminPage _page = AdminPage.userManage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            page: _page,
            onSelect: (p) => setState(() => _page = p),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _page == AdminPage.userManage
                ? const UserManagePage()
                : const DrugManagePage(),
          ),
        ],
      ),
    );
  }
}

// ================= Sidebar =================
class AdminSidebar extends StatelessWidget {
  final AdminPage page;
  final ValueChanged<AdminPage> onSelect;

  const AdminSidebar({super.key, required this.page, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        children: [
          const SizedBox(height: 24),
          _item(context, '用户管理', AdminPage.userManage),
          _item(context, '药品管理', AdminPage.drugManage),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, AdminPage p) {
    return ListTile(
      selected: page == p,
      title: Text(title),
      onTap: () => onSelect(p),
    );
  }
}

// ================= 用户管理 =================
class UserManagePage extends StatefulWidget {
  const UserManagePage({super.key});

  @override
  State<UserManagePage> createState() => _UserManagePageState();
}

class _UserManagePageState extends State<UserManagePage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _dept = '内科';

  final List<Doctor> _doctors = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('医生管理',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: '医生姓名'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(labelText: '电话'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: _dept,
                      items: const ['内科', '外科', '儿科', '骨科']
                          .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setState(() => _dept = v!),
                      decoration: const InputDecoration(labelText: '科室'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _doctors.add(
                            Doctor(_nameCtrl.text, _phoneCtrl.text, _dept));
                        _nameCtrl.clear();
                        _phoneCtrl.clear();
                      });
                    },
                    child: const Text('添加医生'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView.separated(
                itemCount: _doctors.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final d = _doctors[i];
                  return ListTile(
                    title: Text('${d.name}（${d.department}）'),
                    subtitle: Text('电话：${d.phone}'),
                    trailing: TextButton(
                      onPressed: () => _resetPassword(context, d),
                      child: const Text('修改密码'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword(BuildContext context, Doctor d) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('修改 ${d.name} 的密码'),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: '新密码'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text('确认')),
        ],
      ),
    );
  }
}

// ================= 药品管理 =================
class DrugManagePage extends StatefulWidget {
  const DrugManagePage({super.key});

  @override
  State<DrugManagePage> createState() => _DrugManagePageState();
}

class _DrugManagePageState extends State<DrugManagePage> {
  final _nameCtrl = TextEditingController();
  final _countCtrl = TextEditingController();

  final List<Drug> _drugs = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('药品管理',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                children: [
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: '药品名称'),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: _countCtrl,
                      decoration: const InputDecoration(labelText: '数量'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _drugs.add(Drug(_nameCtrl.text,
                            int.tryParse(_countCtrl.text) ?? 0));
                        _nameCtrl.clear();
                        _countCtrl.clear();
                      });
                    },
                    child: const Text('添加药品'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView.separated(
                itemCount: _drugs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final d = _drugs[i];
                  return ListTile(
                    title: Text(d.name),
                    subtitle: Text('库存：${d.count}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editCount(context, d),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editCount(BuildContext context, Drug d) {
    final ctrl = TextEditingController(text: d.count.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('修改 ${d.name} 数量'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: '库存数量'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              setState(() => d.count = int.tryParse(ctrl.text) ?? d.count);
              Navigator.pop(context);
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}

// ================= Models =================
class Doctor {
  final String name;
  final String phone;
  final String department;

  Doctor(this.name, this.phone, this.department);
}

class Drug {
  final String name;
  int count;

  Drug(this.name, this.count);
}
