import 'package:flutter/material.dart';
import 'package:transit_malaya/pages/contact_us.dart';
import 'package:transit_malaya/pages/feedback.dart';

class SideNavbar extends StatelessWidget {
  const SideNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Image.asset(
                    "assets/transit_malaya_logo.png",
                    width: 85,
                    height: 85,
                    fit: BoxFit.contain,
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transit Malaya",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "ver 1.3.0",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Theme.of(context).primaryColor,
              size: 25,
            ),
            title: Text(
              "Contact Us",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(
                DialogRoute(
                  context: context,
                  builder: (context) => const ContactUs(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
              color: Theme.of(context).primaryColor,
              size: 25,
            ),
            title: Text(
              "Feedback",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(DialogRoute(
                context: context,
                builder: (context) {
                  return const FeedBack();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
