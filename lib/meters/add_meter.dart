import 'package:flutter/material.dart';
import 'package:meter_tracker/helpers/database_helper.dart';
import 'package:meter_tracker/models.dart';

class AddMeter extends StatefulWidget {
  const AddMeter({Key? key}) : super(key: key);

  @override
  State<AddMeter> createState() => _AddMeterState();
}

class _AddMeterState extends State<AddMeter> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _serialNumberController;
  int? _locationId;
  String? _meterType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _serialNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Meter'),
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Meter Name',
                            filled: false,
                            isDense: true,
                          ),
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Meter Serial Number',
                              filled: false,
                              isDense: true,
                            ),
                            controller: _serialNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            })),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'Meter Unit',
                            filled: false,
                            isDense: true,
                          ),
                          onChanged: (String? i) {
                            _meterType = i;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: "kWh",
                              child: Text("kWh"),
                            ),
                            DropdownMenuItem(
                              value: "m^3",
                              child: Text("m^3"),
                            ),
                            DropdownMenuItem(
                              value: "BTU",
                              child: Text("BTU"),
                            )
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: FutureBuilder(
                            future: DatabaseHelper.db.getLocations(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Location>> snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButtonFormField(
                                    onChanged: (int? i) {
                                      _locationId = i;
                                    },
                                    elevation: 16,
                                    itemHeight: null,
                                    isDense: false,
                                    isExpanded: true,
                                    items: snapshot.data!
                                        .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Text(
                                                          "${e.streetNumber} ${e.street}\n${e.state} ${e.postalCode}\n${e.country}",
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 4)),
                                                )
                                              ],
                                            )))
                                        .toList());
                              } else {
                                return Container();
                              }
                            })),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );

                            DatabaseHelper.db
                                .addMeter(Meter(
                                    name: _nameController.text,
                                    meterSerialNumber:
                                        _serialNumberController.text,
                                    locationId: _locationId!,
                                    type: _meterType!))
                                .whenComplete(() => Navigator.pop(context));
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
