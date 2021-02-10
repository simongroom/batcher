import 'package:batcher/models/client.dart';
import 'package:batcher/client_search.dart';
import 'package:batcher/product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ClientList extends StatefulWidget {
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final CollectionReference clients =
      FirebaseFirestore.instance.collection('clients');

  List<Client> clientList = [];

  @override
  void initState() {
    getClientList();
    super.initState();
  }

  void getClientList() async {
    QuerySnapshot _clients = await clients.get();
    setState(() {
      clientList = _clients.docs.map((p) {
        return Client.fromJson(p.data());
      }).toList();
      clientList.sort((a, b) => a.clientName.compareTo(b.clientName));
    });
  }

  _showDialog() async {
    Client _client = Client(
      clientId: Uuid().v4(),
      clientName: "",
    );
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Client Name',
                    hintText: "eg. Maria's House Made Salsa",
                  ),
                  onChanged: (val) {
                    _client.clientName = val;
                  }),
            )
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (_client.clientName.trim().isEmpty) {
                  return;
                } else {
                  _client.save().then((response) {
                    print(response);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(
                          client: _client,
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        getClientList();
                      });
                    });
                  });
                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ClientSearch(
                    clientList: clientList,
                  ));
            },
            icon: Icon(Icons.search),
          )
        ],
        title: Text('Search Clients'),
        backgroundColor: Colors.grey[400],
      ),
      body: ListView.builder(
        itemCount: clientList.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductList(
                      client: clientList[index],
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    getClientList();
                  });
                });
              },
              splashColor: Colors.blue.withAlpha(30),
              child: ListTile(
                title: Text(clientList[index].clientName),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Client",
        child: Icon(Icons.add),
        onPressed: _showDialog,
      ),
    );
  }
}
