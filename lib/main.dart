import 'package:flutter/material.dart';
import 'package:flutter_application_sqflite_crud/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SQLITE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [
    // {
    //   "id": 1,
    //   "title": "hello",
    //   "description": "hello world :D",
    // },
    // {
    //   "id": 2,
    //   "title": "study",
    //   "description": "flutter sqlite",
    // },
    // {
    //   "id": 3,
    //   "title": "fighting",
    //   "description": "go go go",
    // },
    // {
    //   "id": 4,
    //   "title": "hello",
    //   "description": "hello world :D",
    // },
    // {
    //   "id": 5,
    //   "title": "study",
    //   "description": "flutter sqlite",
    // },
    // {
    //   "id": 6,
    //   "title": "fighting",
    //   "description": "go go go",
    // },
    // {
    //   "id": 7,
    //   "title": "hello",
    //   "description": "hello world :D",
    // },
    // {
    //   "id": 8,
    //   "title": "study",
    //   "description": "flutter sqlite",
    // },
    // {
    //   "id": 9,
    //   "title": "fighting",
    //   "description": "go go go",
    // },
    // {
    //   "id": 10,
    //   "title": "hello",
    //   "description": "hello world :D",
    // },
    // {
    //   "id": 11,
    //   "title": "study",
    //   "description": "flutter sqlite",
    // },
    // {
    //   "id": 12,
    //   "title": "fighting",
    //   "description": "go go go",
    // },
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
    print("count journals : ${_journals.length}");
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                } else {
                  // await _updateItem(id);
                }

                _titleController.text = "";
                _descriptionController.text = "";

                Navigator.of(context).pop();
              },
              child: Text(id == null ? "Create" : "Update"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("SQLITE"),
      ),
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          margin: const EdgeInsets.all(15),
          child: ListTile(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            subtitleTextStyle: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              _journals[index]['title'],
            ),
            subtitle: Text(_journals[index]['description']),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          _showForm(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
