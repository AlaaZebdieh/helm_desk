import 'package:flutter/material.dart';

import '../../../../app/utils/extensions/context_extensions.dart';
import '../../../../app/widgets/app_dropdown.dart';

class TicketStatusDropdown extends StatefulWidget {
  final String value;
  final ValueChanged<String>? onChanged;

  const TicketStatusDropdown({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  State<TicketStatusDropdown> createState() => _TicketStatusDropdownState();
}

class _TicketStatusDropdownState extends State<TicketStatusDropdown> {
  late final ValueNotifier<String?> _selectedValue;

  static const _items = ['open', 'pending', 'solved'];

  @override
  void initState() {
    super.initState();
    _selectedValue = ValueNotifier(widget.value);
  }

  @override
  void didUpdateWidget(TicketStatusDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue.value = widget.value;
    }
  }

  @override
  void dispose() {
    _selectedValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppDropdown<String>(
        title: context.translate('status'),
        items: _items,
        selectedValue: _selectedValue,
        itemLabel: (item) => context.translate(item),
        isEnableChange: widget.onChanged != null,
        height: 44,
        borderRadius: 12,
        onChanged: widget.onChanged == null
            ? null
            : (value) {
                if (value != null) widget.onChanged!(value);
              },
      ),
    );
  }
}
