import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  _launchPhoneCall() async {
    const phoneNumber = "+60189472723"; // Replace with your phone number
    final url = Uri.parse('tel://$phoneNumber');
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.blue[50],
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(0, 3),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey,
                  ),
                ],
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                    size: 35,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RichText(
                      softWrap: true,
                      text: TextSpan(children: [
                        const TextSpan(
                          text:
                              "Any emergency issues that require immediate assistance? Please reach us out at ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: "+6018-9472723",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchPhoneCall();
                            },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Further enquiries please contact",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "ginkhai88@gmail.com",
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "07-3541692 / 018-9472723",
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
