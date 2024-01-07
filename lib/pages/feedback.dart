import 'dart:async';
import 'dart:collection';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transit_malaya/utils/firestore.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => FeedBackState();
}

class FeedBackState extends State<FeedBack> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isButtonEnabled = true;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController busRouteController = TextEditingController();
  TextEditingController busPlateController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  TimeOfDay timeNow = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        timeController.text = selectedTime.format(context).toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      dateController.text = DateFormat.yMMMd().format(DateTime.now());
      timeController.text = TimeOfDay.now().format(context).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Feedback",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Share your feedback",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Please fill in the form below to convey your issues. We will be reaching shortly",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Email ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    validator: _validateEmail,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Name ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    validator: _validateName,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Date ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        TextFormField(
                                          validator: _validateDate,
                                          readOnly: true,
                                          controller: dateController,
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                              child: Icon(
                                                Icons.date_range,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.all(12.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Time ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        TextFormField(
                                          validator: _validateTime,
                                          controller: timeController,
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                _selectTime(context);
                                              },
                                              child: Icon(
                                                Icons.more_time_sharp,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.all(12.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Bus Route ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: busRouteController,
                                    validator: _validateBusRoute,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Bus Route",
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Bus No.Plate ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: busPlateController,
                                    validator: _validateBusNoPlate,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Bus No.Plate",
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Comments ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextFormField(
                                    controller: commentsController,
                                    validator: _validateComments,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Add Your Comment Here",
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.all(12.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onPressed: _isButtonEnabled
                    ? () {
                        _submitForm();
                      }
                    : null,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with submission
      setState(() {
        _isLoading = true;
        _isButtonEnabled = false;
      });

      Map<String, dynamic> map = HashMap();
      map["email"] = emailController.text;
      map["name"] = nameController.text;
      map["date"] = dateController.text;
      map["time"] = timeController.text;
      map["busRoute"] = busRouteController.text;
      map["busPlate"] = busPlateController.text;
      map["comment"] = commentsController.text;

      bool uploaded = await Firestore().uploadFeedBack(map);

      setState(() {
        _isLoading = false;
        _isButtonEnabled = true;
      });

      if (uploaded) {
        _showSuccessDialog();
      } else {
        _showFailDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Submitted'),
          content: const Text('Thank you for your feedback!'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Submission Failed'),
          content: const Text('Failed to submit feedback. Please try again.'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter valid email';
    } else if (!EmailValidator.validate(value)) {
      return "Enter valid email";
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please pick a date';
    }
    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please pick a time';
    }
    return null;
  }

  String? _validateBusRoute(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid bus route';
    }
    return null;
  }

  String? _validateBusNoPlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the bus no. plate';
    }
    return null;
  }

  String? _validateComments(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add your comments';
    }
    return null;
  }
}
