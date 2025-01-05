import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import '../models/dashboard_item.dart';
import '../models/notification_item.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1; // Default to Home
  List<DashboardItem> dashboardItems = [];
  List<NotificationItem> notificationItems = [];
  final List<String> dashboardPathStack = ["dashboard"];
  final List<String> notificationPathStack = ["notification"];

  @override
  void initState() {
    super.initState();
    _fetchDashboardItems(dashboardPathStack.last);
  }

  // Fetch Dashboard Items
  void _fetchDashboardItems(String path) async {
    try {
      final data = await DashboardService.getServices(path);
      debugPrint("called dashboard");
      setState(() {
        dashboardItems = data;
      });
    } catch (e) {
      debugPrint("Error fetching dashboard items: $e");
    }
  }

  // Fetch Notification Items
  void _fetchNotificationItems(String path) async {
    try {
      print("before at 44");
      final data = await DashboardService.getNotifications(path);
      print("called notification _fetchNotificationItems... $data");
      setState(() {
        notificationItems = data;
      });
    } catch (e) {
      debugPrint("Error fetching notification items: $e");
    }
  }

  // Logout Functionality
  void _logout() async {
    await AuthService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Navigation Handlers for Dashboard
  void _navigateToFolder(String path) {
    setState(() {
      dashboardPathStack.add(path);
      _fetchDashboardItems(path);
    });
  }

  void _goBackDashboard() {
    if (dashboardPathStack.length > 1) {
      setState(() {
        dashboardPathStack.removeLast();
        _fetchDashboardItems(dashboardPathStack.last);
      });
    }
  }

  void _goHomeDashboard() {
    setState(() {
      dashboardPathStack.clear();
      dashboardPathStack.add("dashboard");
      _fetchDashboardItems("dashboard");
    });
  }

  // Navigation Handlers for Notifications
  void _navigateToNotificationFolder(String path) {
    setState(() {
      notificationPathStack.add(path);
      _fetchNotificationItems(path);
    });
  }

  void _goBackNotification() {
    if (notificationPathStack.length > 1) {
      setState(() {
        notificationPathStack.removeLast();
        _fetchNotificationItems(notificationPathStack.last);
      });
    }
  }

  void _goHomeNotification() {
    setState(() {
      notificationPathStack.clear();
      notificationPathStack.add("notification");
      _fetchNotificationItems("notification");
    });
  }

  // Show Notification Detail
  void _showNotificationDetail(NotificationItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Notification Detail")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardPathStack.last),
        leading: dashboardPathStack.length > 1
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackDashboard,
        )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: _goHomeDashboard,
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
        itemCount: dashboardItems.length,
        itemBuilder: (context, index) {
          final item = dashboardItems[index];
          return GestureDetector(
            onTap: item.identifier == "folder"
                ? () => _navigateToFolder(item.serviceId)
                : null,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   "http://10.0.2.2:9001/images/${item.thumbnail}",
                  // ),
                  Text(item.serviceName),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotifications() {
    return Scaffold(
      appBar: AppBar(
        title: Text(notificationPathStack.last),
        leading: notificationPathStack.length > 1
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackNotification,
        )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: _goHomeNotification,
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
        itemCount: notificationItems.length,
        itemBuilder: (context, index) {
          final item = notificationItems[index];
          // return GestureDetector(
          //   onTap: () => _navigateToNotificationFolder(item.notificationsId),
          //         : () => _showNotificationDetail(item),
          //   child: Card(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         // Image.network(
          //         //   "http://10.0.2.2:9001/images/${item.thumbnail}",
          //         // ),
          //         Text(item.title),
          //       ],
          //     ),
          //   ),
          // );
          return GestureDetector(
            onTap: item.section == "notification"
                ? () => _navigateToNotificationFolder(item.notificationsId)
                : () => _showNotificationDetail(item),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Uncomment and replace with the appropriate image URL if needed.
                  // Image.network("http://10.0.2.2:9001/images/${item.thumbnail}"),
                  Text(item.title),
                ],
              ),
            ),
          );

        },
      ),
    );
  }

  Widget _buildOrders() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: const Center(
        child: Text("Orders feature coming soon!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [_buildNotifications(), _buildDashboard(), _buildOrders()];
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        // onTap: (index) {
        //   setState(() {
        //     _selectedIndex = index;
        //   });
        // },
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            _fetchNotificationItems(notificationPathStack.last);
          } else if (index == 1) {
            _fetchDashboardItems(dashboardPathStack.last);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
        ],
      ),
    );
  }
}
