import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:four_aba_project/testes.dart';

class Testinfo extends StatefulWidget {
  @override
  _TestinfoState createState() => _TestinfoState();
}

class _TestinfoState extends State<Testinfo> {
  DateTime _selectedDate = DateTime.now(); // Data atual
  String? _selectedClient;
  String? _selectedTest;
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, dynamic>> _tests = [];

  @override
  void initState() {
    super.initState();
    fetchClients();
 
  }

  Future<void> fetchClients() async {
    final String baseUrl = 'http://localhost:8000/api';
    try {
      final response = await http.get(Uri.parse('$baseUrl/pegarCliteTeste'));
      if (response.statusCode == 200) {
        final List<dynamic> data = [jsonDecode(response.body)];
        
        setState(() {
          _clients = (data[0]['clientes'] as List).map((client) => {
            'id': client['id'],
            'nome': client['nome'],
          }).toList();
          _tests = (data[0]['testes'] as List).map((test) => {
           'id': test['id'],
           'tipo': test['tipo'],
           }).toList();
        });
        
        print(_clients);
      } else {
        print('Erro ao carregar clientes: ${response.statusCode}');
      }
    } catch (e) {
      print('Ocorreu um erro ao buscar os clientes: $e');
    }
  }

  String formatDate(DateTime date) {
    final List<String> weekdays = [
      "domingo",
      "segunda-feira",
      "terça-feira",
      "quarta-feira",
      "quinta-feira",
      "sexta-feira",
      "sábado"
    ];
    final List<String> months = [
      "janeiro",
      "fevereiro",
      "março",
      "abril",
      "maio",
      "junho",
      "julho",
      "agosto",
      "setembro",
      "outubro",
      "novembro",
      "dezembro"
    ];

    String weekday = weekdays[date.weekday - 1];
    String day = date.day.toString();
    String month = months[date.month - 1];
    String year = date.year.toString();

    return "$weekday, $day de $month de $year";
  }
@override
Widget build(BuildContext context) {
  String formattedDate = formatDate(_selectedDate);

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
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Data: $formattedDate',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Center(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Selecionar Cliente'),
              value: _selectedClient,
              items: _clients.map((client) {
                return DropdownMenuItem<String>(
                  value: client['id'].toString(),
                  child: Text(client['nome']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClient = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Selecionar Teste'),
              value: _selectedTest,
              items: _tests.map((test) {
                return DropdownMenuItem<String>(
                  value: test['id'].toString(),
                  child: Text(test['tipo']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTest = value;
                });
              },
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      color: Color(0xFC7FC8F8), // Cor de fundo do botão
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        onPressed: () {
          // Ação ao pressionar o botão
          print('Data: ${_selectedDate.toLocal()}');
          print('Cliente: $_selectedClient');
          print('Teste: $_selectedTest');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TesteScreen(data: _selectedDate,cliente: _selectedClient,teste: _selectedTest)), 
          );
        },
        child: Text(

          'Próximo',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

}
