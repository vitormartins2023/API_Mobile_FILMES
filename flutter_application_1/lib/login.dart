import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/cadastrar.dart';


class Login extends StatefulWidget {
  Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  List<dynamic>? usuarios;

  final String url = 'http://10.109.83.9:3000/usuarios';

  Future<void> _verificarlogin() async {
    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          usuarios = jsonResponse['usuarios'];
        });

        for (var usuario in usuarios!) {
          if (usuario['nome'] == user.text && usuario['password'] == senha.text) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MovieScreen()));
            return;
          }
        }

        print("Usuário ou senha incorretos.");
      } else {
        print("Erro ao carregar usuários: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao verificar login: $e");
    }
  }
  void _navigateToCadastro() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TelaCadastro()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 105, 95, 95),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.red[600],
        title: const Text("MangeFix"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(width: 50),
                      ),
                      icon: Icon(Icons.person_sharp, color: Colors.white,),
                      labelText: "Digite o usuário",
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    controller: user,
                    
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(width: 50),
                      ),
                      labelText: "Digite sua senha",
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.key, color: Colors.white,),
                    ),
                    controller: senha,
                    obscureText: true,
                    obscuringCharacter: "*",
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _verificarlogin().then((_) {
                  // Navega para MovieScreen se as credenciais estiverem corretas
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieScreen()));
                });
              },
              child: const Text("Entrar", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToCadastro,
              child: const Text("Cadastro", style: TextStyle(color: Colors.white)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
