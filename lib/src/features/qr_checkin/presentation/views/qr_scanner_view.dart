import 'package:flutter/material.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key, required this.gymId});
  final String gymId;

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
