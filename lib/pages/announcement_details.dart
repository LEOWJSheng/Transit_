import 'package:flutter/material.dart';

class AnnouncementDetails extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String description;

  const AnnouncementDetails({
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          "Announcement Details",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: $title",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Date: $date",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Time: $time",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Description: $description",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
