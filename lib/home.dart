import 'package:flutter/material.dart';
import 'package:four_aba_project/cliente.dart';
import 'package:four_aba_project/login_page.dart';
import 'package:four_aba_project/testeInfo.dart';
import 'package:four_aba_project/graficos.dart';

class Home extends StatelessWidget {
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
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          elevation: 0, // Remove a sombra
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ajusta o tamanho do Column para o conteúdo
          children: [
            SizedBox(height: 20), // Espaço entre os containers

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Testinfo()), // Navega para a página TestPage
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: 200,
                width: 260,
                decoration: BoxDecoration(
                  color: Color(0xFC7FC8F8),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Column(
                  children: [
                    Image.asset("assets/imagens/lista.png", scale: 1.05),
                    Text(
                      "Testes",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20), // Espaço entre os containers

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Grafico()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: 200,
                width: 260,
                decoration: BoxDecoration(
                  color: Color(0xFC7FC8F8),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Column(
                  children: [
                    Image.asset("assets/imagens/grafico.png"),
                    Text(
                      "Gráficos",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20), // Espaço entre os containers

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cliente()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                height: 200,
                width: 260,
                decoration: BoxDecoration(
                  color: Color(0xFC7FC8F8),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                child: Column(
                  children: [
                    Image.asset("assets/imagens/clientesOut.png"),
                    Text(
                      "Clientes",
                      style: TextStyle(fontSize: 24),
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
