import 'package:blr/models/service-model.dart';
import 'package:blr/services/api-fetch.dart';
import 'package:flutter/material.dart';
import 'dart:developer'; // Import for logging

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Service> services = [];
  List<Service> filteredServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    log("HomeScreen initialized");
    fetchServices();
    _searchController.addListener(_filterList);
  }

  Future<void> fetchServices() async {
    try {
      log("Fetching services...");
      List<Service> fetchedServices = await fetchAvailableServices();
      log("Services fetched successfully: ${fetchedServices.length} items");
      setState(() {
        services = fetchedServices;
        filteredServices = services;
        isLoading = false;
      });
      log("State updated with fetched services");
    } catch (e) {
      log("Error fetching services: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterList() {
    String query = _searchController.text.toLowerCase();
    log("Filtering list with query: $query");
    setState(() {
      filteredServices =
          services.where((service) {
            return service.serviceName.toLowerCase().contains(query) ||
                service.serviceDescription.toLowerCase().contains(query);
          }).toList();
    });
    log("Filtered list count: ${filteredServices.length}");
  }

  @override
  Widget build(BuildContext context) {
    log(
      "Building UI - isLoading: $isLoading, services count: ${services.length}",
    );
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.indigoAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search services...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  isLoading
                      ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : filteredServices.isEmpty
                      ? Center(
                        child: Text(
                          "No services found.",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                      : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredServices.length,
                        itemBuilder: (context, index) {
                          log(
                            "Building list item: ${filteredServices[index].serviceName}",
                          );
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black54,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                filteredServices[index].serviceName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                filteredServices[index].serviceId ==
                                        "LSA_ONLINE"
                                    ? "Real Estate Notarization"
                                    : filteredServices[index].serviceId ==
                                        "LSA_OFFLINE"
                                    ? "Real Estate Offline Notarization"
                                    : "ID: ${filteredServices[index].serviceId}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "\$${filteredServices[index].cost}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  log("App started");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
    ),
  );
}
