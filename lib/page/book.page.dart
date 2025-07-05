import 'package:flutter/material.dart';
import 'package:service_booking/models/service.model.dart';
import 'package:service_booking/page/bookingDetail.page.dart';

class BookPage extends StatelessWidget {
  final Service service;
  const BookPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(context),
            SizedBox(height: 20.0),
            _buildServiceCard(service),
            SizedBox(height: 20),
            Text(
              "Tận tâm và chuyên nghiệp là những gì để nói về ${service.providerName}...",
              style: TextStyle(
                color: const Color.fromARGB(255, 6, 95, 140),
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingDetailsPage(service: service),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 6, 95, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Book now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 6, 95, 140),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      padding: EdgeInsets.all(10.0),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name,
                style: TextStyle(
                  color: const Color.fromARGB(255, 6, 95, 140),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                service.providerName,
                style: TextStyle(
                  color: const Color.fromARGB(255, 6, 95, 140),
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "\$${service.price}/hours",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 6, 95, 140),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              service.imagePath,
              height: 100,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
