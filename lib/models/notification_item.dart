class NotificationItem {
  final String notificationsId;
  final String section;
  final String title;
  final String description;
  final String thumbnail;
  // final String status;

  NotificationItem({
    required this.notificationsId,
    required this.section,
    required this.title,
    required this.description,
    required this.thumbnail,
    // required this.status,
  });

  // Factory constructor to create a NotificationItem from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationsId: json['notificationsId'],
      section: json['section'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      // status: json['status'],
    );
  }

  // Method to convert a NotificationItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationsId': notificationsId,
      'section': section,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      // 'status': status,
    };
  }
}
