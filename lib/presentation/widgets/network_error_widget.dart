import 'package:flutter/material.dart';

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.white),
          ),
          const Spacer(),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }
}
