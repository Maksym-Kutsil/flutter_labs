import 'package:flutter/material.dart';

class BootstrapLoader extends StatelessWidget {
  const BootstrapLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets_rounded, size: 64),
            SizedBox(height: 16),
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Preparing Smart Pet Bowl...'),
          ],
        ),
      ),
    );
  }
}
