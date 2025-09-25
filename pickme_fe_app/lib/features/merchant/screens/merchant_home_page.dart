import 'package:flutter/material.dart';

class MerchantPage extends StatefulWidget {
  const MerchantPage({super.key});

  @override
  State<MerchantPage> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello, merchant!'))),
    );
  }
}
