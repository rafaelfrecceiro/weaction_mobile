import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userEC = TextEditingController();
  var passEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var sp = await SharedPreferences.getInstance();
      if (sp.containsKey('tokenweaction')) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    userEC.dispose();
    passEC.dispose();
  }

  Future<void> sendAuth() async {
    try {
      final response = await Dio().post('https://weon5.weon.com.br/weaction-api/api/weon/v2/auth/token', data: {'identifier': userEC.text, 'password': passEC.text});
      if (response.statusCode == 200) {
        var token = response.headers['authorization'];
        var sp = await SharedPreferences.getInstance();
        sp.setString('tokenweaction', token![0]);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (e.response!.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciais inválidas'),
          ),
        );
      } else if (e.response!.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parâmetros incorretos'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Spacer(),
                  const SizedBox(
                    height: 80,
                    child: Image(
                      image: AssetImage('assets/images/logoweon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: userEC,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passEC,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: sendAuth,
                      child: const Text('Entrar'),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
