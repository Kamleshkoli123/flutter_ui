class DashboardItem {
  final String serviceId;
  final String path;
  final String serviceName;
  final String identifier;
  final List<String>? docs;
  final String thumbnail;
  final String? status;

  DashboardItem({
    required this.serviceId,
    required this.path,
    required this.serviceName,
    required this.identifier,
    this.docs,
    required this.thumbnail,
    this.status,
  });

  factory DashboardItem.fromJson(Map<String, dynamic> json) {
    return DashboardItem(
      serviceId: json["serviceId"],
      path: json["path"],
      serviceName: json["serviceName"],
      identifier: json["identifier"],
      docs: json["docs"] != null ? List<String>.from(json["docs"]) : null,
      thumbnail: json["thumbnail"],
      status: json["status"],
    );
  }
}
