import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marthon_map/Components/marathon_log.dart';
import 'package:marthon_map/home.dart';

class Logscreen extends StatefulWidget {
  const Logscreen({super.key});

  @override
  State<Logscreen> createState() => _LogscreenState();
}

class _LogscreenState extends State<Logscreen> {
  List<Map<String, dynamic>> data = [];

  Future<void> getCollection() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Marathons').get();
    setState(() {
      data = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    ),
                child: const Icon(Icons.map_rounded)),
            const Text('Details'),
            const SizedBox(
              width: 100,
            )
          ],
        ),
      ),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var marathonData = data[index];

                return MarathonLog(
                  state: marathonData['state'] ?? 'error',
                  marathonTime: marathonData['time'] ?? 'error',
                  heartRate: marathonData['heartRate'] ?? 'Unknown',
                  extraInfo: marathonData['extraInfo'] ?? '',
                  docId: marathonData['id'],
                  onUpdate: (updatedData) {
                    setState(() {
                      data[index] = updatedData;
                    });
                  },
                  onDelete: () {
                    setState(
                      () {
                        data.removeAt(index);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
