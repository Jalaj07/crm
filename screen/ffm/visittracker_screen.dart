import 'package:flutter/foundation.dart'; // For defaultTargetPlatform
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

// Models (Ensure these are public - i.e., no leading underscore in class names)
class Visit {
  final int id;
  final String clientName;
  final String address;
  final LatLng location;
  final DateTime scheduledTime;
  final VisitStatus status;
  final String notes;
  final String? photoUrl;

  Visit({
    required this.id,
    required this.clientName,
    required this.address,
    required this.location,
    required this.scheduledTime,
    required this.status,
    this.notes = '',
    this.photoUrl,
  });
}

enum VisitStatus { upcoming, completed, missed, inProgress }

class FFMVisitTrackerScreen extends StatefulWidget {
  const FFMVisitTrackerScreen({super.key});

  @override
  // This is the standard Flutter pattern for creating state.
  // If "Invalid use of a private type in a public API" flags this line,
  // it might be due to a specific lint rule or project setup.
  // Consider '// ignore: private_in_public_api' if this is the case and structure is correct.
  // ignore: library_private_types_in_public_api
  _FFMVisitTrackerScreenState createState() => _FFMVisitTrackerScreenState();
}

class _FFMVisitTrackerScreenState extends State<FFMVisitTrackerScreen> {
  GoogleMapController? _mapController;
  bool _isMapLoading = true;
  bool _listView = false;
  String _selectedFilter = "Today";
  LatLng _currentLocation = const LatLng(28.6139, 77.2090); // Default location (Delhi)
  final Set<Marker> _markers = {};
  
  final List<Visit> _visits = [
    Visit(
      id: 1,
      clientName: 'ABC Corporation',
      address: '123 Business Park, Sector 5, Noida',
      location: const LatLng(28.5851, 77.3263),
      scheduledTime: DateTime.now().add(const Duration(hours: 1)),
      status: VisitStatus.upcoming,
      notes: 'Product demo for new ERP system',
    ),
    Visit(
      id: 2,
      clientName: 'XYZ Industries',
      address: '456 Tech Hub, Sector 62, Noida',
      location: const LatLng(28.6280, 77.3649),
      scheduledTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: VisitStatus.completed,
      notes: 'Maintenance check completed',
      photoUrl: 'https://via.placeholder.com/150/008000/FFFFFF?Text=Visit+Photo+2',
    ),
    Visit(
      id: 3,
      clientName: 'Global Solutions Ltd',
      address: '789 Metro Mall, Connaught Place, New Delhi',
      location: const LatLng(28.6315, 77.2167),
      scheduledTime: DateTime.now().add(const Duration(hours: 3)),
      status: VisitStatus.upcoming,
      notes: 'Sales presentation for new clients',
    ),
    Visit(
      id: 4,
      clientName: 'Innovate Tech',
      address: '101 Startup Hub, Gurgaon',
      location: const LatLng(28.4595, 77.0266),
      scheduledTime: DateTime.now().subtract(const Duration(hours: 4)),
      status: VisitStatus.missed,
      notes: 'Client canceled at the last minute',
    ),
    Visit(
      id: 5,
      clientName: 'Premier Services',
      address: '202 Business Zone, Noida Extension',
      location: const LatLng(28.5921, 77.4054),
      scheduledTime: DateTime.now(),
      status: VisitStatus.inProgress,
      notes: 'Installation of new equipment',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreenData();
  }

  Future<void> _initializeScreenData() async {
    await _getCurrentLocation(); 
    // _loadVisits() is called within _getCurrentLocation's finally block
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isMapLoading = true;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled. Using default location.')),
          );
        }
        return; 
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location permissions are ${permission == LocationPermission.deniedForever ? "permanently " : ""}denied. Using default location.')),
            );
          }
          return;
        }
      }
      
      LocationSettings locationSettings;

      // Platform specific settings example from geolocator plugin
      // For getCurrentPosition, a simpler LocationSettings can also work for basic accuracy.
      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          // distanceFilter: 100, // Not strictly needed for single requests
          // forceLocationManager: true, // Use with caution
          // intervalDuration: const Duration(seconds: 10), // For streams
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          // distanceFilter: 100, // Not strictly needed for single requests
          // activityType: ActivityType.other,
          pauseLocationUpdatesAutomatically: true, // iOS specific
          // showBackgroundLocationIndicator: false, // For foreground only use
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          // distanceFilter: 100, // Not strictly needed for single requests
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings, // Use the new locationSettings parameter
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        _moveToCurrentLocation();
      }
    } catch (e) {
    //  print('Error getting current location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Could not get current location. Using default. Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        _loadVisits();
        setState(() {
          _isMapLoading = false;
        });
      }
    }
  }

  void _moveToCurrentLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation,
            zoom: 12.0,
          ),
        ),
      );
    }
  }

  void _loadVisits() {
    // This method could potentially be called multiple times during init
    // if not carefully managed. Ensure it's idempotent or state is handled.
    if (!mounted) return; 
    setState(() {
      _markers.clear();
      
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
      
      for (var visit in _getFilteredVisits()) {
        _markers.add(
          Marker(
            markerId: MarkerId('visit_${visit.id}'),
            position: visit.location,
            icon: _getMarkerIcon(visit.status),
            infoWindow: InfoWindow(
              title: visit.clientName,
              snippet: '${_getStatusText(visit.status)} - ${DateFormat('hh:mm a').format(visit.scheduledTime)}',
              onTap: () {
                _showVisitDetails(visit);
              },
            ),
          ),
        );
      }
    });
  }

  BitmapDescriptor _getMarkerIcon(VisitStatus status) {
    switch (status) {
      case VisitStatus.completed:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case VisitStatus.missed:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case VisitStatus.inProgress:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
      case VisitStatus.upcoming:
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    }
  }

  String _getStatusText(VisitStatus status) {
    switch (status) {
      case VisitStatus.completed: return 'Completed';
      case VisitStatus.missed: return 'Missed';
      case VisitStatus.inProgress: return 'In Progress';
      case VisitStatus.upcoming: return 'Upcoming';
    }
  }

  Color _getStatusColor(VisitStatus status) {
    switch (status) {
      case VisitStatus.completed: return Colors.green;
      case VisitStatus.missed: return Colors.red;
      case VisitStatus.inProgress: return Colors.orange;
      case VisitStatus.upcoming: return Colors.purple;
    }
  }

  List<Visit> _getFilteredVisits() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    switch (_selectedFilter) {
      case 'Today':
        return _visits.where((visit) => 
          visit.scheduledTime.year == today.year &&
          visit.scheduledTime.month == today.month &&
          visit.scheduledTime.day == today.day
        ).toList();
      case 'Upcoming':
        return _visits.where((visit) => 
          visit.scheduledTime.isAfter(now) &&
          visit.status == VisitStatus.upcoming
        ).toList();
      case 'Completed':
        return _visits.where((visit) => visit.status == VisitStatus.completed).toList();
      case 'Missed':
        return _visits.where((visit) => visit.status == VisitStatus.missed).toList();
      case 'All':
      default:
        return _visits;
    }
  }

  void _showVisitDetails(Visit visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      visit.clientName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(visit.status).withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(visit.status),
                      style: TextStyle(color: _getStatusColor(visit.status), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(visit.address, style: const TextStyle(color: Colors.grey))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(visit.scheduledTime),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(visit.notes),
              const SizedBox(height: 16),
              if (visit.photoUrl != null) ...[
                const Text('Visit Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      visit.photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Center(child: Text('Could not load image')),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening navigation...')),
                      );
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Navigate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  if (visit.status == VisitStatus.upcoming || visit.status == VisitStatus.inProgress)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Visit marked as completed')),
                        );
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Mark Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

   @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            icon: Icon(_listView ? Icons.map : Icons.list),
            onPressed: () => setState(() => _listView = !_listView),
            tooltip: _listView ? 'Map View' : 'List View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _initializeScreenData(); 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing visits...')),
              );
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final filter in ['Today', 'Upcoming', 'Completed', 'Missed', 'All'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                            _loadVisits(); 
                          });
                        },
                        selectedColor: Colors.blue.shade100,
                        checkmarkColor: Colors.blue,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _listView ? _buildListView() : _buildMapView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_listView) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adding new visit...')),
            );
          } else {
            _moveToCurrentLocation();
          }
        },
        tooltip: _listView ? 'Add Visit' : 'My Location',
        child: Icon(_listView ? Icons.add : Icons.my_location),
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
             if (mounted) { 
                setState(() {
                  _mapController = controller;
                });
             }
          },
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 12.0,
          ),
          markers: _markers,
          myLocationEnabled: true, 
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
        ),
        if (_isMapLoading)
          Container(
            color: Colors.white.withAlpha(178),
            child: const Center(child: CircularProgressIndicator()),
          ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Today\'s Visits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Completed', _visits.where((v) => v.status == VisitStatus.completed && v.scheduledTime.day == DateTime.now().day).length.toString(), Colors.green),
                      _buildStatCard('In Progress', _visits.where((v) => v.status == VisitStatus.inProgress && v.scheduledTime.day == DateTime.now().day).length.toString(), Colors.orange),
                      _buildStatCard('Upcoming', _visits.where((v) => v.status == VisitStatus.upcoming && v.scheduledTime.day == DateTime.now().day).length.toString(), Colors.purple),
                      _buildStatCard('Missed', _visits.where((v) => v.status == VisitStatus.missed && v.scheduledTime.day == DateTime.now().day).length.toString(), Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withAlpha(51), shape: BoxShape.circle),
            child: Text(count, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final filteredVisits = _getFilteredVisits();
    
    if (filteredVisits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No $_selectedFilter visits found', style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredVisits.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final visit = filteredVisits[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _getStatusColor(visit.status).withAlpha(76), width: 1),
          ),
          child: InkWell(
            onTap: () => _showVisitDetails(visit),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(visit.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(visit.status).withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_getStatusText(visit.status), style: TextStyle(color: _getStatusColor(visit.status), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(child: Text(visit.address, style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(DateFormat('dd MMM yyyy, hh:mm a').format(visit.scheduledTime), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening navigation...')),
                        ),
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('Navigate'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), visualDensity: VisualDensity.compact),
                      ),
                      if (visit.status == VisitStatus.upcoming || visit.status == VisitStatus.inProgress)
                        OutlinedButton.icon(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Starting check-in process...')),
                          ),
                          icon: const Icon(Icons.check_circle, size: 16),
                          label: const Text('Check In'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), visualDensity: VisualDensity.compact),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}