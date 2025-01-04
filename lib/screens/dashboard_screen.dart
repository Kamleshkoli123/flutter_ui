import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import '../models/dashboard_item.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashboardItem> items = [];
  final List<String> pathStack = ["dashboard"]; // Stack to manage paths

  @override
  void initState() {
    super.initState();
    fetchDashboardItems(pathStack.last); // Always fetch the last path in the stack
  }

  void fetchDashboardItems(String path) async {
    try {
      final data = await DashboardService.getServices(path);
      setState(() {
        items = data;
      });
    } catch (e) {
      debugPrint("Error fetching dashboard items: $e");
    }
  }

  void _logout() async {
    await AuthService.logout(); // Clear token from storage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToFolder(String path) {
    setState(() {
      pathStack.add(path);
      fetchDashboardItems(path);
    });
  }

  void _goBack() {
    if (pathStack.length > 1) {
      setState(() {
        pathStack.removeLast();
        fetchDashboardItems(pathStack.last);
      });
    }
  }

  void _goHome() {
    setState(() {
      pathStack.clear();
      pathStack.add("dashboard");
      fetchDashboardItems("dashboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pathStack.last),
        leading: pathStack.length > 1
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: _goHome,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: item.identifier == "folder"
                ? () => _navigateToFolder(item.serviceId)
                : null,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "http://10.0.2.2:9001/images/${item.thumbnail}",
                  ),
                  Text(item.serviceName),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
