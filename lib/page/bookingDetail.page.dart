import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_booking/models/service.model.dart';
import 'package:service_booking/blocs/booking/booking.bloc.dart';
import 'package:service_booking/blocs/booking/booking.event.dart';
import 'package:service_booking/blocs/booking/booking.state.dart';

class BookingDetailsPage extends StatefulWidget {
  final Service service;
  
  const BookingDetailsPage({super.key, required this.service});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final locationController = TextEditingController();
  final userCountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
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
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Thêm dòng này
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 6, 95, 140),
          title: Text("Booking Details", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đặt dịch vụ thành công!")),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state is BookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceCard(),
                  SizedBox(height: 20),
                  Text(
                    "Thông tin đặt chỗ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 6, 95, 140),
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildDateTimePicker(),
                  SizedBox(height: 15),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: "Địa điểm",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: userCountController,
                    decoration: InputDecoration(
                      labelText: "Số lượng người",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  // XÓA Spacer() và nút ở đây
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: state is BookingLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 6, 95, 140),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (locationController.text.isEmpty ||
                              userCountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Vui lòng điền vào tất cả các trường"))
                            );
                            return;
                          }
                          final userCount = int.tryParse(userCountController.text) ?? 1;
                          context.read<BookingBloc>().add(
                            SubmitBookingWithDetails(
                              service: widget.service,
                              date: selectedDate,
                              time: selectedTime,
                              location: locationController.text,
                              userCount: userCount,
                            ),
                          );
                        },
                        child: Text("Xác nhận đặt chỗ"),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 208, 219, 224),
            Color.fromARGB(255, 176, 205, 222),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 6, 95, 140),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Provider: ${widget.service.providerName}",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 6, 95, 140),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "\$${widget.service.price}/hour",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 6, 95, 140),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.service.imagePath,
              height: 80,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Ngày",
                border: OutlineInputBorder(),
              ),
              child: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () => _selectTime(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Thời gian",
                border: OutlineInputBorder(),
              ),
              child: Text(
                "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}",
              ),
            ),
          ),
        ),
      ],
    );
  }
}