import 'package:flutter/material.dart';

Future<String?> showRenamePetDialog({
  required BuildContext context,
  required String initialName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _RenamePetDialog(initialName: initialName),
  );
}

class _RenamePetDialog extends StatefulWidget {
  const _RenamePetDialog({required this.initialName});

  final String initialName;

  @override
  State<_RenamePetDialog> createState() => _RenamePetDialogState();
}

class _RenamePetDialogState extends State<_RenamePetDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename pet'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Pet name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }
    Navigator.of(context).pop(value);
  }
}
