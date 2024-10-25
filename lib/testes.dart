import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:four_aba_project/home.dart';

class TesteScreen extends StatefulWidget {
  @override
  _TesteScreenState createState() => _TesteScreenState();
  final DateTime data;
  final String? cliente;
  final String? teste;

  TesteScreen({required this.data, required this.cliente, required this.teste});
}

class _TesteScreenState extends State<TesteScreen> {
  List<dynamic> perguntas = [];
  Map<int, String> respostas = {}; // Armazena as respostas do usuário
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarPerguntas();
  }

  // Função para buscar as perguntas da API
  Future<void> _buscarPerguntas() async {
    final String baseUrl = 'http://localhost:8000/api';
    try {
      final response = await http.post(Uri.parse('$baseUrl/getperguntas'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({'idTeste': int.parse(widget.teste ?? '-1')}));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decodifica como um mapa
        print(data);
        print(data['teste']);
        if (data is Map && data['teste'] is List) {
          setState(() {
            perguntas = List.from(data['teste']); // Acesse a lista correta
            print(perguntas); // Para depuração
            carregando = false;
          });
        } else {
          // Mensagem de erro mais informativa
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Formato inesperado da resposta da API."),
              backgroundColor: Colors.red));
          setState(() {
            carregando = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erro de perguntas"),
            backgroundColor: Color(0xFC7FC8F8)));
      }
    } catch (e) {
      //_mostrarErroSnackBar("Erro conexao: " ${e.toString()});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()), backgroundColor: Color(0xFC7FC8F8)));
    }
  }

Future<void> _enviarRespostas() async {
  final String baseUrl = 'http://localhost:8000/api';

  print('Respostas originais: $respostas');

  List<dynamic> resp = [];
  List<dynamic> respID = [];
  for(var entry in respostas.entries){
    print(entry);
    print(entry.value);
    print(entry.key);
    resp.add(entry.value);
    respID.add(entry.key);
  }

 print(resp);
 print(respID);

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/enviarRespostas'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'respostas': resp,
        'IDrespostas': respID,
        'cliente': int.parse(widget.cliente ?? '-1'),
        'teste': int.parse(widget.teste ?? '-1'),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Respostas enviadas com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()),);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar respostas: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Erro ao enviar respostas: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao enviar respostas: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: AppBar(
        backgroundColor: Color(0xFC7FC8F8),
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/imagens/logo4aba.png',
                height: 100,
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
    ),
    body: carregando
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: perguntas.length,
                    itemBuilder: (context, index) {
                      final pergunta = perguntas[index];

                      // Acesso seguro aos campos
                      final id = pergunta['id'] ?? -1; 
                      final descricao = pergunta['descricao'] ?? 'Descrição não disponível'; 

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            descricao,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Sua resposta'),
                            onChanged: (value) {
                              respostas[id] = value;
                            },
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    bottomNavigationBar: Container(
      color: Color(0xFC7FC8F8), // Cor de fundo do botão
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity, // Faz o botão ocupar toda a largura
        child: ElevatedButton(
            onPressed: _enviarRespostas,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, 
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              'Enviar Respostas',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
        ),
      ),
    ),
  );
}
}