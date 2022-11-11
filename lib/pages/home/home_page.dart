import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var sp = await SharedPreferences.getInstance();
      setState(() {
        token = sp.getString('tokenweaction') ?? 'Sem token';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weaction Mobile'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var sp = await SharedPreferences.getInstance();
              sp.remove('tokenweaction');
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Deslogar'),
          ),
          Text(token),
        ],
      ),
    );
  }
}
