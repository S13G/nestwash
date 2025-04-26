import 'package:flutter/material.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NestScaffold(
      title: 'support',
      showBackButton: true,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: []),
    );
  }
}
