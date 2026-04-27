import 'package:flutter/material.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/domain/models/bowl_entry.dart';

class EntryEditorDialog extends StatefulWidget {
  const EntryEditorDialog({this.initialEntry, super.key});

  final BowlEntry? initialEntry;

  @override
  State<EntryEditorDialog> createState() => _EntryEditorDialogState();
}

class _EntryEditorDialogState extends State<EntryEditorDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _portionController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final initialEntry = widget.initialEntry;
    _titleController = TextEditingController(text: initialEntry?.title ?? '');
    _portionController = TextEditingController(
      text: initialEntry?.portionGrams.toString() ?? '',
    );
    _noteController = TextEditingController(text: initialEntry?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _portionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialEntry == null ? 'Add feeding entry' : 'Edit entry',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  return InputValidators.validateEntryTitle(value ?? '');
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _portionController,
                decoration: const InputDecoration(labelText: 'Portion (grams)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return InputValidators.validatePortion(value ?? '');
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final existingEntry = widget.initialEntry;
    final entry = BowlEntry(
      id: existingEntry?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      portionGrams: int.parse(_portionController.text.trim()),
      note: _noteController.text.trim(),
    );
    Navigator.of(context).pop(entry);
  }
}
