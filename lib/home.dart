import 'package:flutter/material.dart ';

class Home extends StatelessWidget {
   @override
    Widget build(BuildContext context) {
 return Scaffold(
      backgroundColor: Color(0xFC7FC8F8),
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(300.0), // Define a altura da AppBar
        child: AppBar(
          backgroundColor: Color(0xFC7FC8F8), // Cor de fundo da AppBar
          flexibleSpace: Center( // Centraliza todo o conteúdo da AppBar
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
      )
    );
  }
}