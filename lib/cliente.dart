import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Cliente extends StatefulWidget {
  @override
  _ClienteState createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();

  Future<void> cadastrar() async {
    try{
      final String baseUrl = 'http://localhost:8000/api';
      
      String nome = _nomeController.text;//nome
      String dataNasc = _dataNascimentoController.text;//dataNasc

      final response = await http.post(
        Uri.parse('$baseUrl/cadastrarCliente'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'nome': nome,
          'dataNasc': dataNasc
        })
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        if(data['msg'] != null){
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cliente cadastrado com sucesso!'),backgroundColor: Color(0xFC7FC8F8),),
          );
        }
        else{
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro'),backgroundColor: Color(0xFC7FC8F8),),
          );
        }
      }
      
    }catch (e){
      print('Ocorreu um erro alooooooooooo carai: $e');

    }

  }



  // Função para exibir o seletor de data
  _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dataNascimentoController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Define a altura da AppBar
      child: AppBar(
        backgroundColor: Color(0xFC7FC8F8), // Cor de fundo da AppBar
        flexibleSpace: Center(
          // Centraliza todo o conteúdo da AppBar
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            children: [
              Image.asset(
                'assets/imagens/logo4aba.png',
                height: 100, // Altura da imagem
              ),
            ],
          ),
        ),
        elevation: 0, // Remove a sombra
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center( // Centraliza o conteúdo do body
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            mainAxisSize: MainAxisSize.min, // Minimiza o tamanho vertical da coluna
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espaçamento entre os campos
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a data de nascimento';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
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
          if (_formKey.currentState!.validate()) {
            cadastrar();
          }
        },
        child: Text(
          'Cadastrar',
          style: TextStyle(color: Colors.white), 
        ),
      ),
    ),
  );
}
}
