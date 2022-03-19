class Location {
  int? id;
  String streetNumber;
  String street;
  String country;
  String state;
  String postalCode;

  Location(
      {this.id,
      required this.streetNumber,
      required this.street,
      required this.state,
      required this.country,
      required this.postalCode});

  Location.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        streetNumber = res["street_number"],
        street = res["street"],
        country = res["country"],
        state = res["state"],
        postalCode = res["postal_code"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'street_number': streetNumber,
      'street': street,
      'country': country,
      'state': state,
      'postal_code': postalCode
    };
  }
}

class Meter {
  int? id;
  String name;
  String meterSerialNumber;
  int locationId;
  String type;

  Meter(
      {this.id,
      required this.name,
      required this.meterSerialNumber,
      required this.locationId,
      required this.type});

  Meter.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        meterSerialNumber = res["serial_number"],
        locationId = res["location_id"],
        type = res["type"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'serial_number': meterSerialNumber,
      'location_id': locationId,
      'type': type
    };
  }
}

class MeterReading {
  int? id;
  int meterId;
  int timestamp;
  double reading;

  MeterReading(
      {this.id,
      required this.meterId,
      required this.timestamp,
      required this.reading});

  MeterReading.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        meterId = res["meter_id"],
        timestamp = res["timestamp"],
        reading = res["reading"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'meter_id': meterId,
      'timestamp': timestamp,
      'reading': reading
    };
  }
}
