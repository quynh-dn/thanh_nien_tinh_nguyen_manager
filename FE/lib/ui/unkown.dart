import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnkownPage extends StatelessWidget {
  const UnkownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Column(
        children: [
          const Text('Không tìm thấy trang này'),
          TextButton.icon(
              onPressed: () {
                context.go('/trang-chu');
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Quay lại trang chủ'))
        ],
      )),
    );
  }
}
