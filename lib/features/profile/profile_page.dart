import 'package:flutter/material.dart';
import 'package:my_project/application/services/auth_service.dart';
import 'package:my_project/core/validation/input_validators.dart';
import 'package:my_project/domain/models/app_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.authService,
    required this.user,
    super.key,
  });

  final AuthService authService;
  final AppUser user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _petNameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _petNameController = TextEditingController(text: widget.user.petName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _petNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Your name'),
                    validator: (value) {
                      return InputValidators.validateName(value ?? '');
                    },
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
                    validator: (value) {
                      return InputValidators.validateName(value ?? '');
                    },
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
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() {
      _isSaving = true;
    });
    final updatedUser = widget.user.copyWith(
      name: _nameController.text.trim(),
      petName: _petNameController.text.trim(),
    );
    await widget.authService.updateUser(updatedUser);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(updatedUser);
  }
}
