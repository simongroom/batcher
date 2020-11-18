import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');

  String clientId;
  String clientName;

  Client({
    this.clientId,
    this.clientName,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json['client_id'],
      clientName: json['client_name'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> _data = {
      'client_id': clientId,
      'client_name': clientName,
    };
    return _data;
  }

  Future save() async {
    return clients.doc(clientId).set(toJson());
  }
}
