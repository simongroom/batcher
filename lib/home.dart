import 'package:batcher/batch_list.dart';
import 'package:batcher/product_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _children.add(ProductList());
    _children.add(new BatchList(
      UniqueKey(),
      BatchListType.incomplete,
    ));
    _children.add(new BatchList(
      UniqueKey(),
      BatchListType.unbilled,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/batcher_icon.png'),
        title: Text(
          "Batcher",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Incomplete Batches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Unbilled Batches',
          )
        ],
      ),
    );
  }
}
