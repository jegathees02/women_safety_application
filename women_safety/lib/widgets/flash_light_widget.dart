// import 'package:flutter/material.dart';
// import 'package:torch_controller/torch_controller.dart';

// class FlashlightWidget extends StatefulWidget {
//   final bool isBlinking;

//   const FlashlightWidget({Key? key, required this.isBlinking}) : super(key: key);

//   @override
//   _FlashlightWidgetState createState() => _FlashlightWidgetState();
// }

// class _FlashlightWidgetState extends State<FlashlightWidget> {
//   final TorchController _torchController = TorchController();

//   @override
//   void didUpdateWidget(FlashlightWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     // Trigger the blink function when isBlinking is true
//     if (widget.isBlinking) {
//       _blinkTorch();
//     }
//   }

//   Future<void> _blinkTorch() async {
//     for (int i = 0; i < 5; i++) {
//     //   _torchController.turnOn(); // Turn on the torch
//         _torchController.toggle(intensity: 1);
//       await Future.delayed(const Duration(milliseconds: 500));
//       _torchController.toggle(intensity: 0); // Turn off the torch
//       await Future.delayed(const Duration(milliseconds: 500));
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // You can customize this widget further if needed
//   }
// }
