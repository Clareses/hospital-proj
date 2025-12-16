import 'package:flutter/material.dart';
import '../pages/doctor/home.dart';

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
