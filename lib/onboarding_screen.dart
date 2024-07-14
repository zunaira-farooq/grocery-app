import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:grocery_list/home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final List<String> _commonItems = [];
  final TextEditingController _itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildNamePage(context),
          _buildCommonItemsPage(context),
        ],
      ),
    );
  }

  Widget _buildNamePage(BuildContext context) {
    return Container(
      color: const Color(0xFF151738),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Hey there! Please enter your name',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Enter name',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 50, width: 200),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: const Color(0xFF9B9BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Next',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonItemsPage(BuildContext context) {
    return Container(
      color: const Color(0xFF9B9BFF),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Please enter some of your usual grocery items',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF151738),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _itemController,
            decoration: const InputDecoration(
              labelText: 'Enter common item',
              labelStyle: TextStyle(color: Color(0xFF151738)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF151738)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF151738)),
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _commonItems.add(value);
                  _itemController.clear();
                });
              }
            },
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _commonItems
                .map((item) => Chip(
                      label: Text(item),
                      backgroundColor: const Color(0xFF151738),
                      labelStyle: const TextStyle(color: Colors.white),
                    ))
                .toList(),
          ),
          const SizedBox(height: 50, width: 200),
      SizedBox(
        width: 120,
        child: ElevatedButton(
            onPressed: _saveOnboarding,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              backgroundColor: const Color(0xFF151738),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Finish',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
      ),
        ],
      ),
    );
  }

  _saveOnboarding() async {
    var box = await Hive.openBox('userBox');
    box.put('name', _nameController.text);
    box.put('commonItems', _commonItems);
    box.put('isOnboarded', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
