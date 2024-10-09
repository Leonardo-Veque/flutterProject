import 'package:flutter/material.dart ';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _login() async{
    final String url = 'http://127.0.0.1:8000/login';

    if(_loginController.text.isEmpty || _senhaController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }

    final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type':'application/json'},
    body: json.encode({
      'email': _loginController.text,
      'password': _senhaController.text,
    }),
    );
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      String usuario = data['user'];

      print('Login bem-sucedido: $usuario');
    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar com a API.')));
    }
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
              // Centraliza todo o conteúdo da AppBar
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centraliza verticalmente
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
              borderRadius: BorderRadius.circular(
                  20.0), // Garante que o conteúdo siga a borda
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
                          vertical: 20.0,
                          horizontal: 40.0), // Aumenta o tamanho do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Bordas arredondadas no botão
                      ),
                    ),
                    onPressed: () {
                      // Implementar lógica de login aqui
                    },
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(
                                0xFF000000))), // Aumenta o tamanho do texto
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
