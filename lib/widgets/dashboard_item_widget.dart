import 'package:flutter/material.dart';
import '../models/dashboard_item.dart';

class DashboardItemWidget extends StatelessWidget {
  final DashboardItem item;
  final VoidCallback? onTap;

  const DashboardItemWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "http://localhost:9001/images/${item.thumbnail}",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              item.serviceName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
