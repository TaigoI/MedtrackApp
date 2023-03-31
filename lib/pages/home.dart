import 'package:flutter/material.dart';
import 'package:medtrack/components/prescription.dart';

import '../cache/prescription_cache.dart';

class Home extends StatelessWidget {
  Home({super.key});

  PrescriptionCache prescriptionCache =  PrescriptionCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {},
        ),
        title: Image.asset('assets/images/logo.png', height: 48),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {},
          )
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: FutureBuilder<List<Prescription>?>(
            future: prescriptionCache.getAllRecords(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) { return snapshot.data?[index]; },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
      )
    );
  }
}
