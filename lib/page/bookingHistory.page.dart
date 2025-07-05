import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:service_booking/models/booking.model.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late Box<Booking> bookingsBox;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    bookingsBox = await Hive.openBox<Booking>('bookingsBox');
    final sessionBox = await Hive.openBox('sessionBox');
    setState(() {
      currentUserId = sessionBox.get('currentUserId');
    });
  }

  void deleteBooking(Booking booking) async {
    await booking.delete();
    setState(() {}); // cập nhật lại UI
  }

  void editBooking(BuildContext context, Booking booking) async {
    final locationController = TextEditingController(text: booking.location);
    final userCountController = TextEditingController(text: booking.userCount.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Chỉnh sửa Booking"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Vị trí"),
            ),
            TextField(
              controller: userCountController,
              decoration: InputDecoration(labelText: "Số người"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () {
              booking.location = locationController.text;
              booking.userCount = int.tryParse(userCountController.text) ?? 1;
              booking.save();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Center(child: CircularProgressIndicator());
    }

    final userBookings = bookingsBox.values
        .where((b) => b.userId == currentUserId)
        .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // sắp xếp mới nhất

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 95, 140),
        title: Text("Lịch sử đặt dịch vụ"),
      ),
      body: userBookings.isEmpty
          ? Center(child: Text("Bạn chưa đặt dịch vụ nào"))
          : ListView.builder(
              itemCount: userBookings.length,
              itemBuilder: (_, index) {
                final booking = userBookings[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(
                      booking.service.imagePath,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(booking.service.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ngày: ${booking.date.day}/${booking.date.month}/${booking.date.year}"),
                        Text("Giờ: ${booking.time}"),
                        Text("Vị trí: ${booking.location}"),
                        Text("Số người: ${booking.userCount}"),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          editBooking(context, booking);
                        } else if (value == 'delete') {
                          deleteBooking(booking);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'edit', child: Text("Sửa")),
                        PopupMenuItem(value: 'delete', child: Text("Xoá")),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
