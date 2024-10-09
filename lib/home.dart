import 'package:flutter/material.dart ';

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
          elevation: 0, // Remove a sombra
        ),
      ),
      body: Center(
        child: Column(
          // Usar Column para múltiplos filhos
          mainAxisSize:
              MainAxisSize.min, // Ajusta o tamanho do Column para o conteúdo
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              height: 200,
              width: 260,
              decoration: BoxDecoration(
                color: Color(0xFC7FC8F8),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              child: Column(
                children: [
                  Image.asset(""),
                  Text(
                    "Testes",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Espaço entre os containers
            Container(
              padding: EdgeInsets.all(16.0),
              height: 200,
              width: 260,
              decoration: BoxDecoration(
                color: Color(0xFC7FC8F8),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              child: Column(
                children: [
                  Image.asset(""),
                  Text(
                    "Gráficos",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Espaço entre os containers
            Container(
              padding: EdgeInsets.all(16.0),
              height: 200,
              width: 260,
              decoration: BoxDecoration(
                color: Color(0xFC7FC8F8),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              child: Column(
                children: [
                  Image.asset(""),
                  Text(
                    "Clientes",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}