class Service {
  final String serviceName;
  final String serviceId;
  final String serviceDescription;
  final int cost;

  Service({
    required this.serviceName,
    required this.serviceId,
    required this.serviceDescription,
    required this.cost,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceName: json['service_name'] ?? "Unknown Service",
      serviceId: json['service_id'] ?? "Unknown ID",
      serviceDescription: json['service_description'] ?? "No Description",
      cost: (json['cost'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'service_id': serviceId,
      'service_description': serviceDescription,
      'cost': cost,
    };
  }
}
