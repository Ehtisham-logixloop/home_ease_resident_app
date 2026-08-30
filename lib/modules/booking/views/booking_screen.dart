import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/res/app_url.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/ui_helper.dart';
import '../../../data/models/service_provider_model.dart';
import '../../../data/services/api_service.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../Bottom_navigation/views/bottom_navigation.dart';

class BookingScreen extends StatelessWidget {
  final ServiceProvider? provider;
  final String? categoryName;

  const BookingScreen({
    super.key,
    this.provider,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    if (provider != null && categoryName != null) {
      return NewBookingScreen(
        provider: provider!,
        categoryName: categoryName!,
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final tabBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final tabBorder = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final tabUnselected = isDark ? Colors.white70 : Colors.black;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: scaffoldBg,
          title: Text(
            "My Bookings",
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: titleColor),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(58),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: tabBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: tabBorder),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: tabUnselected,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Up Coming"),
                  Tab(text: "In Progress"),
                  Tab(text: "Completed"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            BookingList(status: "Up Coming"),
            BookingList(status: "In Progress"),
            BookingList(status: "Completed"),
          ],
        ),
        bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      ),
    );
  }
}

class NewBookingScreen extends StatefulWidget {
  final ServiceProvider provider;
  final String categoryName;

  const NewBookingScreen({
    super.key,
    required this.provider,
    required this.categoryName,
  });

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  LatLng? _selectedLocation;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _confirmBooking() async {
    if (selectedDate == null || selectedTime == null || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select GPS location')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final payload = {
        'provider_id': widget.provider.id,
        'category': widget.categoryName,
        'date': selectedDate!.toIso8601String(),
        'time': '${selectedTime!.hour}:${selectedTime!.minute}',
        'address': _addressController.text,
        'notes': _notesController.text,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      };

      final response = await ApiService().postRequest(
        AppUrl.createBooking,
        payload,
        requireAuth: true,
      );

      if (mounted) Navigator.pop(context); // close loading

      if (response['success'] == true) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final titleColor = isDark ? Colors.white : Colors.black;
            final subColor = isDark ? Colors.white70 : Colors.grey;
            return Dialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Request Send\nSuccessfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Congratulations\nYour Request has been Send',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: subColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        if (mounted) UIHelper.showFlushbarError(context, response['message'] ?? "Failed to book service");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // close loading
        UIHelper.showFlushbarError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.grey.shade600;
    final placeholderColor = isDark ? Colors.white54 : Colors.grey;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = Theme.of(context).cardColor;
    final fieldBorder = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text('Book Service',
            style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
        centerTitle: true,
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              color: cardBg,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.provider.image,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.provider.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.provider.profession,
                            style: TextStyle(
                              fontSize: 14,
                              color: subColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.provider.rating}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.provider.yearsOfExperience} years exp',
                                style: TextStyle(color: subColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PKR ${widget.provider.pricePerHour}/hour',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: fieldBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Choose Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedDate != null ? titleColor : placeholderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: fieldBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : 'Choose Time',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedTime != null ? titleColor : placeholderColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Select GPS Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, RoutesName.map);
                if (result != null && result is LatLng) {
                  setState(() {
                    _selectedLocation = result;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: fieldBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedLocation != null
                            ? 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}'
                            : 'Pick location',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedLocation != null ? titleColor : placeholderColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Service Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 3,
              style: TextStyle(color: titleColor),
              decoration: InputDecoration(
                hintText: 'Enter your address',
                hintStyle: TextStyle(color: placeholderColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Additional Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 2,
              style: TextStyle(color: titleColor),
              decoration: InputDecoration(
                hintText: 'Any special instructions (optional)',
                hintStyle: TextStyle(color: placeholderColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingItem {
  final String bookingId;
  final String providerId;
  final String providerName;
  final String providerRole;
  final String providerImage;
  final String serviceTitle;
  final String serviceDetail;
  final String date;
  final String time;
  final String status;
  final bool bookingAccepted;

  const BookingItem({
    required this.bookingId,
    required this.providerId,
    required this.providerName,
    required this.providerRole,
    required this.providerImage,
    required this.serviceTitle,
    required this.serviceDetail,
    required this.date,
    required this.time,
    required this.status,
    this.bookingAccepted = false,
  });
}

class BookingList extends StatelessWidget {
  final String status;
  const BookingList({super.key, required this.status});

  List<BookingItem> _demoBookings(String status) {
    if (status == "Up Coming") {
      return const [
        BookingItem(
          bookingId: '101',
          providerId: 'p101',
          providerName: 'Saad Mughal',
          providerRole: 'Carpenter',
          providerImage: 'assets/images/message1.png',
          serviceTitle: 'Carpenter Service',
          serviceDetail: 'Main Door Repair, Wall Repair.',
          date: 'Mon - Oct 2, 2025',
          time: '11.00 AM',
          status: 'Up Coming',
          bookingAccepted: true,
        ),
        BookingItem(
          bookingId: '102',
          providerId: 'p102',
          providerName: 'Ehtisham',
          providerRole: 'Electrician',
          providerImage: 'assets/images/message2.png',
          serviceTitle: 'Electrician Service',
          serviceDetail: 'Wiring repair, new switches.',
          date: 'Tue - Oct 3, 2025',
          time: '2.00 PM',
          status: 'Up Coming',
          bookingAccepted: true,
        ),
      ];
    } else if (status == "In Progress") {
      return const [
        BookingItem(
          bookingId: '201',
          providerId: 'p201',
          providerName: 'Nahil Shafiq',
          providerRole: 'Beautification',
          providerImage: 'assets/images/message3.png',
          serviceTitle: 'Home Cleaning Service',
          serviceDetail: 'Full apartment deep cleaning.',
          date: 'Today',
          time: '10.00 AM',
          status: 'In Progress',
          bookingAccepted: true,
        ),
      ];
    } else {
      return const [
        BookingItem(
          bookingId: '301',
          providerId: 'p301',
          providerName: 'Hamid',
          providerRole: 'Cleaner',
          providerImage: 'assets/images/message5.png',
          serviceTitle: 'AC Repair',
          serviceDetail: 'AC cooling problem fixed.',
          date: 'Last week',
          time: '4.00 PM',
          status: 'Completed',
          bookingAccepted: true,
        ),
      ];
    }
  }

  Future<void> _openChat(BuildContext context, BookingItem item) async {
    if (!item.bookingAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking not yet accepted by the provider')),
      );
      return;
    }
    final String? currentUserId = await LocalStorageService.getUserIdString();
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        RoutesName.chat,
        arguments: {
          'name': item.providerName,
          'image': item.providerImage,
          'role': item.providerRole,
          'bookingId': item.bookingId,
          'providerId': item.providerId,
          'userId': currentUserId,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey;
    final cardBg = Theme.of(context).cardColor;
    final bookings = _demoBookings(status);
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final item = bookings[index];
        return Card(
          margin: const EdgeInsets.all(12),
          color: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  "assets/images/booking.png",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.serviceTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                        ),
                        if (item.bookingAccepted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Accepted",
                              style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.serviceDetail,
                      style: TextStyle(color: subColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "By: ${item.providerName} (${item.providerRole})",
                      style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(item.date, style: TextStyle(color: titleColor)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(item.time, style: TextStyle(color: titleColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (status == "Up Coming") ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Booking cancelled')),
                                );
                              },
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () => _openChat(context, item),
                              child: const Text("Message"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Work started')),
                                );
                              },
                              child: const Text("Start Work"),
                            ),
                          ),
                        ],
                      )
                    ] else if (status == "In Progress") ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(0, 46),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () => _openChat(context, item),
                              child: const Text("Message"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(0, 46),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Service marked as done!')),
                                );
                              },
                              child: const Text("Done"),
                            ),
                          ),
                        ],
                      )
                    ] else if (status == "Completed") ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(0, 46),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () => _openChat(context, item),
                              child: const Text("Message"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(0, 46),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Book again feature coming soon')),
                                );
                              },
                              child: const Text("Book Again"),
                            ),
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
