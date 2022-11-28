import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _inputValue = '';

  @override
  void initState() {
    super.initState();
  }

  void removeElement(String key) {
    FirebaseFirestore.instance.collection('items').doc(key).delete();
  }

  void addElement() {
    FirebaseFirestore.instance.collection('items').add({'item': _inputValue});
  }

  openMenu() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: Text('Меню')),
          body: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: Text('На главную'),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
            ],
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Список задач'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: openMenu, icon: Icon(Icons.home)),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('No records');
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    onDismissed: ((direction) =>
                        {removeElement(snapshot.data!.docs[index].id)}),
                    key: Key(snapshot.data!.docs[index].id),
                    child: Card(
                      child: ListTile(
                        title: Text(snapshot.data?.docs[index].get('item')),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: () {
                            removeElement(snapshot.data!.docs[index].id);
                          },
                        ),
                      ),
                    ));
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Добавить задачу'),
                  content: TextField(onChanged: (String value) {
                    _inputValue = value;
                  }),
                  actions: [
                    ElevatedButton(
                        onPressed: () =>
                            {addElement(), Navigator.of(context).pop()},
                        child: Text('Добавить')),
                    ElevatedButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        child: Text('Отмена'))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
