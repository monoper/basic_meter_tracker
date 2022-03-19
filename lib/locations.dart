import 'package:flutter/material.dart';
import 'package:meter_tracker/helpers/database_helper.dart';
import 'package:meter_tracker/models.dart';
import 'package:meter_tracker/widgets/list_card.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DatabaseHelper.db.getLocations(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Location>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var currentAddress = snapshot.data![index];
                    return ListCard(
                        cardContent: ListTile(
                      title: Text(
                          "${currentAddress.streetNumber} ${currentAddress.street}"),
                      subtitle: Text(
                          "${currentAddress.state}, ${currentAddress.postalCode}"),
                    ));
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLocations()),
          ).then((value) => setState(() {}));
        },
      ),
    );
  }
}

class AddLocations extends StatefulWidget {
  const AddLocations({Key? key}) : super(key: key);

  @override
  State<AddLocations> createState() => _AddLocationsState();
}

class _AddLocationsState extends State<AddLocations> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Location'),
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Street Number',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _streetNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Street',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _streetController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _countryController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'State',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _stateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _postalCodeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
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
                                .addLocation(Location(
                                    street: _streetController.text,
                                    streetNumber: _streetNumberController.text,
                                    state: _stateController.text,
                                    country: _countryController.text,
                                    postalCode: _postalCodeController.text))
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
