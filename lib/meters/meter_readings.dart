import 'package:flutter/material.dart';
import 'package:meter_tracker/helpers/database_helper.dart';
import 'package:meter_tracker/meters/add_meter_reading.dart';
import 'package:meter_tracker/models.dart';

class MeterReadings extends StatefulWidget {
  const MeterReadings({Key? key, required this.meter}) : super(key: key);
  final Meter meter;
  @override
  State<MeterReadings> createState() => _MeterReadingsState();
}

class _MeterReadingsState extends State<MeterReadings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.meter.name} Readings'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          FutureBuilder(
              future: DatabaseHelper.db.getMeterReadings(widget.meter.id!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MeterReading>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var reading = snapshot.data![index];
                        return ListTile(
                          title: Text(
                              "${reading.reading.toString()} ${widget.meter.type}"),
                          subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                                  reading.timestamp)
                              .toString()),
                        );
                      });
                } else {
                  return Container();
                }
              }),
        ]),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddMeterReading(meterId: widget.meter.id!)),
            ).then((value) => setState(() {}));
          },
        ));
  }
}
