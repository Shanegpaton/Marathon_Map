import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marthon_map/data.dart';

class MarathonLog extends StatefulWidget {
  final String state;
  final String marathonTime;
  final String heartRate;
  final String extraInfo;
  final String docId;
  final Function(Map<String, dynamic>) onUpdate;
  final Function() onDelete;

  const MarathonLog({
    super.key,
    required this.state,
    required this.marathonTime,
    required this.heartRate,
    required this.extraInfo,
    required this.docId,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<MarathonLog> createState() => _MarathonLogState();
}

class _MarathonLogState extends State<MarathonLog> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  String? _selectedState;

  @override
  Widget build(BuildContext context) {
    double height = 200;
    if (widget.extraInfo.isEmpty) {
      height = 140;
    }
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 50),
              Text(
                widget.state,
                style: fontStyle(33),
              ),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    _timeController.text = widget.marathonTime;
                    _heartRateController.text = widget.heartRate;
                    _otherController.text = widget.extraInfo;
                    _selectedState = widget.state;
                    return AlertDialog(
                      title: const Center(child: Text("Edit")),
                      actions: [
                        const Row(
                          children: [
                            Text("State"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Select state',
                          ),
                          value: _selectedState,
                          items: states.map((state) {
                            return DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedState = value;
                            });
                          },
                        ),
                        const Row(
                          children: [
                            Text("Time"),
                          ],
                        ),
                        TextField(
                            controller: _timeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter time',
                            )),
                        const Row(
                          children: [
                            Text("Heart Rate"),
                          ],
                        ),
                        TextField(
                          controller: _heartRateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter heart rate',
                          ),
                        ),
                        const Row(
                          children: [
                            Text("Extra Info"),
                          ],
                        ),
                        TextField(
                          maxLines: 3,
                          controller: _otherController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Other',
                              alignLabelWithHint: true),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  String updatedState =
                                      _selectedState ?? widget.state;
                                  String updatedTime = _timeController.text;
                                  String updatedHeartRate =
                                      _heartRateController.text;
                                  String updatedExtraInfo =
                                      _otherController.text;

                                  await FirebaseFirestore.instance
                                      .collection('Marathons')
                                      .doc(widget.docId)
                                      .update({
                                    'state': updatedState,
                                    'time': updatedTime,
                                    'heartRate': updatedHeartRate,
                                    'extraInfo': updatedExtraInfo,
                                  });

                                  widget.onUpdate({
                                    'state': updatedState,
                                    'time': updatedTime,
                                    'heartRate': updatedHeartRate,
                                    'extraInfo': updatedExtraInfo,
                                    'id': widget.docId,
                                  });

                                  Navigator.of(context).pop();
                                } catch (e) {
                                  log('Error updating document: $e');
                                }
                              },
                              child: const Text("Save"),
                            ),
                            TextButton(
                              onPressed: () async => {
                                await FirebaseFirestore.instance
                                    .collection('Marathons')
                                    .doc(widget.docId)
                                    .delete()
                                    .then((_) {
                                  widget.onDelete();
                                }),
                                Navigator.of(context).pop()
                              },
                              child: const Text(
                                "Delete Marathon",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  fixedSize: WidgetStateProperty.all(const Size(40, 40)),
                  shape: WidgetStateProperty.all(
                    const CircleBorder(),
                  ),
                ),
                child: const Icon(Icons.edit, size: 20),
              )
            ],
          ),
          const SizedBox(width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    widget.marathonTime,
                    style: fontStyle(20),
                  ),
                  const Text('Marathon Time ')
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.heartRate,
                    style: fontStyle(20),
                  ),
                  const Text('Heart Rate')
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.extraInfo),
          ),
        ],
      ),
    );
  }

  TextStyle fontStyle(double size) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
  }
}
