import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meter_tracker/helpers/database_helper.dart';
import 'package:meter_tracker/models.dart';

class AddMeterReading extends StatefulWidget {
  const AddMeterReading({Key? key, required this.meterId}) : super(key: key);
  final int meterId;

  @override
  State<AddMeterReading> createState() => _AddMeterReading();
}

class _AddMeterReading extends State<AddMeterReading> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _readingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Reading'),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                  decoration: const InputDecoration(labelText: "Reading"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: _readingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (double.tryParse(value) == null) {
                      return 'Reading must be a number';
                    }
                    return null;
                  }),
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
                          .addMeterReading(MeterReading(
                              meterId: widget.meterId,
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                              reading:
                                  double.parse(_readingController.value.text)))
                          .whenComplete(() => Navigator.pop(context));
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ])));
  }
}
