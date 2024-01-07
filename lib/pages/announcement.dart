import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transit_malaya/pages/announcement_details.dart';

class Announcement extends StatelessWidget {
  const Announcement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Announcement",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("announcements").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No announcements available."),
            );
          } else {
            var announcements = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue[50],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24.0,
                    ),
                    child: ListView.builder(
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        var announcement = announcements[index];
                        var data = announcement.data() as Map<String, dynamic>;

                        // Convert timestamp to formatted date
                        List<String> date = (data['date'] as String).split("-");
                        String currentDate = "${date[1]}/${date[2]}";
                        String time = (data['time'] as String);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    data['title'] ?? 'No Title',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 32.0,
                                ),
                                Text(
                                  "$currentDate $time",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              data['description'] ?? 'No Description',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AnnouncementDetails(
                                          title: data['title'],
                                          date: currentDate,
                                          time: time,
                                          description: data['description'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Read More",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
