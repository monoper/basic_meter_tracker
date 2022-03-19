import 'package:flutter/material.dart';
import 'package:meter_tracker/helpers/database_helper.dart';
import 'package:meter_tracker/meters/add_meter.dart';
import 'package:meter_tracker/meters/meter_readings.dart';
import 'package:meter_tracker/models.dart';
import 'package:meter_tracker/widgets/list_card.dart';

class Meters extends StatefulWidget {
  const Meters({Key? key}) : super(key: key);

  @override
  State<Meters> createState() => _MetersState();
}

class _MetersState extends State<Meters> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DatabaseHelper.db.getMeters(),
          builder: (BuildContext context, AsyncSnapshot<List<Meter>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Material(
                  type: MaterialType.transparency,
                  child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var currentMeter = snapshot.data![index];
                        return ListCard(
                            cardContent: ListTile(
                                title: Text(currentMeter.name),
                                subtitle: Text(currentMeter.meterSerialNumber),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MeterReadings(
                                              meter: currentMeter,
                                            )),
                                  ).then((value) => setState(() {}));
                                }));
                      }));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMeter()),
          ).then((value) => setState(() {}));
        },
      ),
    );
  }
}
