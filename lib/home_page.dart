import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<String> _groceryBox;
  late String _userName;
  late List<String> _suggestedItems = [];

  @override
  void initState() {
    super.initState();
    _initializeHomePage();
  }

  _initializeHomePage() async {
    var userBox = await Hive.openBox('userBox');
    _userName = userBox.get('name');
    _groceryBox = await Hive.openBox<String>('groceryBox');
    _suggestedItems = List<String>.from(userBox.get('commonItems', defaultValue: []));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151738),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, $_userName',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _groceryBox.listenable(),
              builder: (context, Box<String> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    String item = box.keys.elementAt(index);
                    String quantity = box.get(item)!;
                    return Dismissible(
                      key: Key(item),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _groceryBox.delete(item);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$item removed')),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF9B9BFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    controller: TextEditingController(text: quantity),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Qty',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    onSubmitted: (value) {
                                      int? newQuantity = int.tryParse(value);
                                      if (newQuantity != null && newQuantity > 0) {
                                        setState(() {
                                          _groceryBox.put(item, newQuantity.toString());
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Quantity must be greater than 0'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _suggestedItems
                  .map((item) => GestureDetector(
                onTap: () => _addItemFromSuggestions(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(context),
        backgroundColor: const Color(0xFF9B9BFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 10,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter item name',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String itemName = controller.text.trim();
                  if (itemName.isNotEmpty) {
                    _groceryBox.put(itemName, '1'); // Default quantity is 1
                    controller.clear();
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addItemFromSuggestions(String item) {
    setState(() {
      _groceryBox.put(item, '1'); // Default quantity is 1
    });
  }
}
