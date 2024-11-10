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
  List<LineChartBarData> lineBarsData = [];
  DateTime? startDate;
  DateTime? endDate;
  String? selectedClient;
  String? selectedTest;
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
          _clients = (data[0]['clientes'] as List)
              .map((client) => {
                    'id': client['id'],
                    'nome': client['nome'],
                  })
              .toList();
          _tests = (data[0]['testes'] as List)
              .map((test) => {
                    'id': test['id'],
                    'tipo': test['tipo'],
                  })
              .toList();
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
      try {
        final String baseUrl = 'http://localhost:8000/api';

        final response = await http.post(
          Uri.parse('$baseUrl/chartCliente'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'cliente': selectedClient,
            'teste': selectedTest,
            'dataInicial': DateFormat('yyyy-MM-dd').format(startDate!),
            'dataFinal': DateFormat('yyyy-MM-dd').format(endDate!),
          }),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          List<dynamic> data = jsonResponse['data'];

          if (data.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Cliente não fez esse teste"),
              backgroundColor: Colors.red,
            ));
          } else {
            Map<int, List<FlSpot>> groupedData = {};

            // Agrupar dados por pergunta_id
            for (var item in data) {
              int perguntaId = item['pergunta_id'];
              double resposta = item['resposta'] is String
                  ? double.parse(item['resposta'])
                  : item['resposta'];
              DateTime dataItem = DateTime.parse(item['data']);

              if (!groupedData.containsKey(perguntaId)) {
                groupedData[perguntaId] = [];
              }
              groupedData[perguntaId]!
                  .add(FlSpot(dataItem.day.toDouble(), resposta));
            }

            // Criar uma lista de LineChartBarData para cada pergunta
            List<LineChartBarData> lineBars = [];

            groupedData.forEach((perguntaId, spots) {
              lineBars.add(LineChartBarData(
                spots: spots,
                isCurved: false,
                color: Colors.primaries[perguntaId %
                    Colors.primaries.length], // Cores distintas para cada linha
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ));
            });

            setState(() {
              lineBarsData = lineBars; // Armazenar as linhas
            });
          }
        } else {
          print('Erro ao buscar dados: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erro ao buscar dados: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('Erro ao buscar dados: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erro ao buscar dados: $e"),
          backgroundColor: Colors.red,
        ));
      }
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
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza verticalmente
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
                  child: Text(startDate == null
                      ? 'Data Início'
                      : DateFormat('yyyy-MM-dd').format(startDate!)),
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
                  child: Text(endDate == null
                      ? 'Data Fim'
                      : DateFormat('yyyy-MM-dd').format(endDate!)),
                ),
              ],
            ),
            SizedBox(height: 16), // Espaço entre os botões e os dropdowns
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Selecionar Cliente'),
              value: selectedClient,
              items: _clients.map((client) {
                return DropdownMenuItem<String>(
                  value: client['id'].toString(),
                  child: Text(client['nome']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClient = value;
                });
              },
            ),
            SizedBox(height: 16), // Espaço entre os dropdowns
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Selecionar Teste'),
              value: selectedTest,
              items: _tests.map((test) {
                return DropdownMenuItem<String>(
                  value: test['id'].toString(),
                  child: Text(test['tipo']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTest = value;
                });
              },
            ),
            SizedBox(height: 16), // Espaço antes do botão
            ElevatedButton(
              onPressed: fetchChartData,
              child: Text('Buscar Dados'),
            ),
            SizedBox(height: 16), // Espaço antes do gráfico
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true), // Mostra a grade
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Remove os títulos do eixo Y
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Remove os títulos do eixo superior
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(), // Exibe o dia
                            style: TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.black, width: 1),
                      bottom: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  lineBarsData:
                      lineBarsData, // Usar a lista de linhas agrupadas
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
