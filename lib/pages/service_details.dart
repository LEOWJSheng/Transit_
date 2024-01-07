import 'package:flutter/material.dart';
import 'package:transit_malaya/global_variables/bus_options.dart';
import 'package:transit_malaya/pages/bus_schedule.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({super.key});

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
          "Service Details",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.blue[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Bus Routes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  var bus = buses[index];

                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: bus["color"] as Color,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.directions_bus,
                                color: bus["color"] as Color,
                                size: 35,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              bus["name"] as String,
                              style: TextStyle(
                                color: bus["color"] as Color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return BusSchedule(
                                      imageUrl: bus["schedule"] as String);
                                },
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
