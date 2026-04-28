import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/domain/models/app_user.dart';
import 'package:my_project/presentation/cubits/auth/auth_cubit.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({required this.user, super.key});

  final AppUser user;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.user.name,
  );
  late final TextEditingController _petNameController = TextEditingController(
    text: widget.user.petName,
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _petNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Your name'),
            validator: (value) => InputValidators.validateName(value ?? ''),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: widget.user.email,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _petNameController,
            decoration: const InputDecoration(labelText: 'Pet name'),
            validator: (value) => InputValidators.validateName(value ?? ''),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              child: Text(_isSaving ? 'Saving...' : 'Save profile'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isSaving = true);
    final updated = widget.user.copyWith(
      name: _nameController.text.trim(),
      petName: _petNameController.text.trim(),
    );
    await context.read<AuthCubit>().updateUser(updated);
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }
}
