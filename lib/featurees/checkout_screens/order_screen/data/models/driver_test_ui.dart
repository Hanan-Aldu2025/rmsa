import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'driver_model.dart';
import 'package:uuid/uuid.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({super.key});

  @override
  State<AddDriverPage> createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController deliveryMethodController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();

  bool isActive = true;
  bool isAvailable = true;

  String driverId = '';

  @override
  void initState() {
    super.initState();
    driverId = const Uuid().v4(); // معرف السائق تلقائي
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Driver")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Driver Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: vehicleController,
                decoration: const InputDecoration(labelText: "Vehicle Type"),
              ),
              TextFormField(
                controller: deliveryMethodController,
                decoration: const InputDecoration(labelText: "Delivery Method"),
              ),
              const SizedBox(height: 16),
              Text(
                "Location (manual input for testing)",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: latController,
                      decoration: const InputDecoration(labelText: "Latitude"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: lngController,
                      decoration: const InputDecoration(labelText: "Longitude"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _updateLocation,
                    child: const Text("Update"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Active"),
                value: isActive,
                onChanged: (v) => setState(() => isActive = v),
              ),
              SwitchListTile(
                title: const Text("Available"),
                value: isAvailable,
                onChanged: (v) => setState(() => isAvailable = v),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDriver,
                child: const Text("Save Driver"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveDriver() async {
    if (!_formKey.currentState!.validate()) return;

final driver = DriverModel(
  id: driverId,
  name: nameController.text.trim(),
  phone: phoneController.text.trim(),
  imageUrl: "", // يمكن إضافة صورة لاحقًا
  rating: 0, // افتراضي
  isActive: isActive,
  isAvailable: isAvailable,
  totalRatings: 0, // افتراضي
  vehicleType: vehicleController.text.trim(),
  deliveryMethod: deliveryMethodController.text.trim(),
  createAt: Timestamp.fromDate(DateTime.now()), // ⚡ هذا فقط
  isOnline: true,
  isBlocked: false,
  hasActiveOrder: false,
  ratingSum: 0,
  cancelledOrder: 0,
  completedOrder: 0,
  vehicleColor: '',
  vehiclePlate: '',
  branchId: '',
  cityId: '',
  orderId: '',
  email: '',
  lastActiveAt: Timestamp.now(),
  lastloacationUpdate: Timestamp.now(),
  lat: GeoPoint(0.0, 0.0),
  //lng: 0.0,
);

    try {
      // إضافة السائق
      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(driverId)
          .set(driver.toMap());

      // إذا تم إدخال الموقع، تحديثه
      if (latController.text.isNotEmpty && lngController.text.isNotEmpty) {
        await _updateLocation();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Driver added successfully!")),
      );

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _updateLocation() async {
    try {
      final double latitude = double.parse(latController.text.trim());
      final double longitude = double.parse(lngController.text.trim());

      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(driverId)
          .update({
        "lat": GeoPoint(latitude, longitude),
        "lng": GeoPoint(latitude, longitude), // لو تحتاج تخزن الlng منفصل
        "lastloacationUpdate": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location update failed: $e")),
      );
    }
  }
  

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    vehicleController.clear();
    deliveryMethodController.clear();
    latController.clear();
    lngController.clear();
  }
}