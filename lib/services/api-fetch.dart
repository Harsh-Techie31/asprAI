import 'dart:convert';
import 'dart:developer';
import 'package:blr/models/service-model.dart';
import 'package:http/http.dart' as http;

Future<List<Service>> fetchAvailableServices() async {
  log("API fetching started...");

  final response = await http.post(
    Uri.parse('https://api.thenotary.app/customer/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "email": "nandhakumar1411@gmail"
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);

    // Navigate to 'availableServices' -> 'services'
    List<dynamic> servicesData = jsonData['data']['availableServices']['services'];
    log("API fetch successful. Found ${servicesData.length} services.");

    return servicesData.map((service) {
      return Service(
        serviceName: service['serviceName'] ?? "Unknown Service",
        serviceId: service['serviceId'] ?? "Unknown ID",
        serviceDescription: service['description'] ?? "No Description",
        cost: (service['cost'] as int?) ?? 0,
      );
    }).toList();
  } else {
    log("API fetch failed with status code: ${response.statusCode}");
    throw Exception('Failed to load services');
  }
}
