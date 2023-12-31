import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week3/auth.dart';

const int _bluePrimaryValue = 0xFF2196F3;
const MaterialColor blue = const MaterialColor(
  _bluePrimaryValue,
  const <int, Color>{
    50: const Color(0xFFE3F2FD),
    100: const Color(0xFFBBDEFB),
    200: const Color(0xFF90CAF9),
    300: const Color(0xFF64B5F6),
    400: const Color(0xFF42A5F5),
    500: const Color(_bluePrimaryValue),
    600: const Color(0xFF1E88E5),
    700: const Color(0xFF1976D2),
    800: const Color(0xFF1565C0),
    900: const Color(0xFF0D47A1),
  },
);


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue[500],
      ),
      home: MyHomePage(title: 'Budget Tracker'),
    );
  }
}








class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> items = [];
  bool showItems = false;

  void _addItem(String name, double cost) {
    setState(() {
      items.add({'name': name, 'cost': cost});
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _showAddItemDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController costController = TextEditingController();
  void addItemToFirebase() {
    String name = nameController.text;
    double? price = double.tryParse(costController.text);

    if (name.isNotEmpty && price != null) {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('items')
            .add({
          'name': name,
          'price': price,
        }).then((_) {
          setState(() {
            _addItem(name, price);
          });
          nameController.clear();
          costController.clear();
        }).catchError((error) {
          
          print("Error adding data: $error");
        });
      }
    }
  }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          width: 300,
          child: AlertDialog(

            contentPadding: EdgeInsets.all(10.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Item Name",
                    labelStyle: TextStyle(
                      color: Colors.purple[900],
                    ),
                  ),
                ),
                TextField(
                  controller: costController,
                  decoration: InputDecoration(
                    labelText: "Item Cost",
                    labelStyle: TextStyle(
                      color: Colors.purple[900],
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Transform.scale(
                  scale: 1.5,
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
                onPressed: () {

                  Navigator.of(context).pop();

                  addItemToFirebase();
                },
              )
            ],
          ),
        );
      },
    );
  }
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }


  @override
  Widget build(BuildContext context) {
    double totalCost = items.fold(0, (sum, item) => sum + item['cost']);
void deleteItem(int index) {
 if (index < 0 || index >= items.length) {
    print('Invalid index: $index  ' );
    return;
  }  
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String itemName = items[index]['name'];
  if (uid != null) {
    
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .where('name', isEqualTo: itemName)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.first.reference.delete().then((_) {          
          setState(() {
            items.removeAt(index);
          });
        }).catchError((error) {          
          print("Error deleting document: $error");
        });
      }
    }).catchError((error) {
      print("Error fetching document to delete: $error");
    });
  }
}

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 30,color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue[900],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16.0),
          child: Container(),
        ),
      ),


      body: Column(
        children: [
Container(
  decoration: BoxDecoration(
    color: Colors.blue[400],
    borderRadius: BorderRadius.circular(10.0),
  ),
  padding: EdgeInsets.all(16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Spacer(),
      Text('Total:', style: TextStyle(fontSize: 28)),
      Spacer(),

      SizedBox(width: 230),
      Container(
        padding:
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration:
        BoxDecoration(
            color: blue[200],
            border: Border.all(color: Colors.blue)
        ),
        child:
        Text(totalCost.toString(), style: TextStyle(fontSize: 28)),
      ),

      Spacer(),
      IconButton(
        icon:
        Icon(showItems ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        onPressed: () {
          setState(() {
            showItems = !showItems;
          });
        },
      ),
      Spacer(),
      
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          signOut();
        },
      ),
    ],
  ),
),


          Expanded(
            child: showItems
                ? Container(
              color: Colors.blue[100],
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(children: [
                          Row(
                            children: [
                              SizedBox(width: 260),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  items[index]['name'],
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  items[index]['cost'].toString(),
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  
                                  deleteItem(index);
                                  }
                              ),
                              Spacer(),
                            ],
                          ),
                        ]),
                      ],
                    );
                  }),
            )
                : Container(),

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: 'Add Item',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}