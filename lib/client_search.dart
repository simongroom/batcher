import 'package:batcher/models/client.dart';
import 'package:batcher/product_list.dart';
import 'package:flutter/material.dart';

class ClientSearch extends SearchDelegate {
  final List<Client> clientList;

  ClientSearch({
    @required this.clientList,
  });

  List<Client> recentList = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Client> resultList = [];
    resultList.addAll(filterClientList());
    return buildClientListView(resultList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Client> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(filterClientList());
    return buildClientListView(suggestionList);
  }

  List<Client> filterClientList() {
    return clientList.where((p) {
      return p.clientName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  ListView buildClientListView(List<Client> clients) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    client: clients[index],
                  ),
                ),
              );
            },
            splashColor: Colors.blue.withAlpha(30),
            child: ListTile(
              title: Text(clients[index].clientName),
            ),
          ),
        );
      },
    );
  }
}
