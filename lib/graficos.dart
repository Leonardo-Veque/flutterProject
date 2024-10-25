import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:four_aba_project/cliente.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class Grafico extends StatefulWidget {
  @override
  _Grafico createState() => _Grafico();

  
}

class _Grafico extends State<Grafico> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChartPage(),
    );
  }
  
}



class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
  
}

class _ChartPageState extends State<ChartPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedClient;
  List<FlSpot> spots = [];
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

  Future<void> fetchChartData() async {
    if (startDate != null && endDate != null && selectedClient != null) {
      try{
        final String baseUrl = 'http://localhost:8000/api';

        final response = await http.post(
        Uri.parse('$baseUrl/chartCliente'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      body: jsonEncode({
 
          'cliente': '',
          'teste': '',
          'dataInicial': DateFormat('yyyy-MM-dd').format(startDate!),
          'dataFinal': DateFormat('yyyy-mm-dd').format(endDate!)
        })
        );









        /*if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            spots = data.map((item) => FlSpot( 
              DateTime.parse(item['date']).day.toDouble(),
              item['value'].toDouble(),
            )).toList();
          });
        }*/
      }
      catch(e){

      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gráfico de Clientes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => startDate = date);
                  },
                  child: Text(startDate == null ? 'Data Início' : DateFormat('yyyy-MM-dd').format(startDate!)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => endDate = date);
                  },
                  child: Text(endDate == null ? 'Data Fim' : DateFormat('yyyy-MM-dd').format(endDate!)),
                ),
              ],
            ),
            DropdownButton<String>(
              value: selectedClient,
              hint: Text('Selecione o Cliente'),
              onChanged: (value) {
                setState(() {
                  selectedClient = value;
                });
              },
              items: _clients.map((client) {
                return DropdownMenuItem<String>(
                  value: client['id'].toString(),
                  child: Text(client['tipo']),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedClient,
              hint: Text('Selecione o Teste'),
              onChanged: (value) {
                setState(() {
                  selectedClient = value;
                });
              },
              items: _tests.map((test) {
                return DropdownMenuItem<String>(
                  value: test['id'].toString(),
                  child: Text(test['tipo']),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: fetchChartData,
              child: Text('Buscar Dados'),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}