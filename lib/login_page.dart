import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> login() async {
    try {
      final String baseUrl = 'http://:8000';  // Substitua pelo seu IP real
// Usando localhost para a web
      
      // Primeira requisição para pegar o token CSRF
      final csrfResponse = await http.get(Uri.parse('$baseUrl/sanctum/csrf-cookie'));
      print('Status da requisição CSRF: ${csrfResponse.statusCode}'); // Log do status

      if (csrfResponse.statusCode == 200) {
        // Extrair o token CSRF
        String? csrfToken = extractCsrfToken(csrfResponse);
        print('Token CSRF extraído: $csrfToken');

        if (csrfToken != null) {
          // Pega os valores dos TextFields
          String login = _loginController.text;
          String senha = _senhaController.text;

          print('Login: $login, Senha: $senha');

          // Fazer a requisição principal
          final response = await http.post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'X-XSRF-TOKEN': csrfToken,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'login': login,
              'senha': senha,
            }),
          );

          print('Status da resposta do login: ${response.statusCode}');
          print('Corpo da resposta do login: ${response.body}');

          if (response.statusCode == 200) {
            print('Requisição principal bem-sucedida: ${response.body}');
          } else {
            print('Erro na requisição principal: ${response.statusCode}');
          }
        } else {
          print('Token CSRF não encontrado.');
        }
      } else {
        print('Erro ao obter o token CSRF: ${csrfResponse.statusCode}');
        print('Resposta CSRF: ${csrfResponse.body}');
      }
    } catch (e) {
      print('Ocorreu um erro: $e'); // Log do erro
    }
  }

  // Função para extrair o token CSRF dos cookies ou da resposta
  String? extractCsrfToken(http.Response response) {
    final cookies = response.headers['set-cookie'];
    if (cookies != null && cookies.contains('XSRF-TOKEN')) {
      final token = RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookies);
      return token?.group(1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFC7FC8F8),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(300.0), // Define a altura da AppBar
          child: AppBar(
            backgroundColor: Color(0xFC7FC8F8), // Cor de fundo da AppBar
            flexibleSpace: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
                children: [
                  Image.asset(
                    'assets/imagens/logo4aba.png',
                    height: 300, // Altura da imagem
                  ),
                ],
              ),
            ),
            elevation: 0, // Remove a sombra
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80.0),
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Garante que o conteúdo siga a borda
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 46),
                  ),
                  SizedBox(height: 70.0),
                  TextField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: 'Login',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            25.0), // Bordas arredondadas nos inputs
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            25.0), // Bordas arredondadas nos inputs
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7FC8F8),
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 40.0), // Aumenta o tamanho do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Bordas arredondadas no botão
                      ),
                    ),
                    onPressed: () {
                      login();  // Chama a função de login ao clicar no botão
                    },
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF000000))), // Aumenta o tamanho do texto
                  ),
                  SizedBox(height: 80.0),
                  Text(
                    'Esqueceu a senha clique aqui',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )));
  }
}
