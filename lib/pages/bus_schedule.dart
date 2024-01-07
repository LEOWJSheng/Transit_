import 'package:flutter/material.dart';

class BusSchedule extends StatelessWidget {
  final String imageUrl;
  const BusSchedule({super.key, required this.imageUrl});

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
          "Bus Schedule",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Image(
        image: AssetImage(imageUrl),
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
