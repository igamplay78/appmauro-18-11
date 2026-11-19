import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Usuario> cadastroUsuario(
    String nome, String email, String senha, int perfil) async {
  final resposta = await http.post(
    Uri.parse('http://10.106.76.18:8080/cadastro'),
    body: jsonEncode({
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': perfil,
    }),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
  );

  if (resposta.statusCode == 200 || resposta.statusCode == 201) {
    // status 200 resposta OK
    return Usuario.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  } else {
    // status != 200 é erro!
    throw Exception('Falha ao carregar post.');
  }
}

class Usuario {
  final String nome;
  final String email;
  final String senha;
  final int perfil;

  const Usuario(
      {required this.nome,
      required this.email,
      required this.senha,
      required this.perfil});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'nome': String nome,
        'email': String email,
        'senha': String senha,
        'perfil': int perfil
      } =>
        Usuario(
          nome: nome,
          email: email,
          senha: senha,
          perfil: perfil,
        ),
      _ => throw const FormatException('Falha no carregamento...'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController perfilController = TextEditingController();
  Future<Usuario>? usuarioFuturo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de usuarios',
      home: Scaffold(
        appBar: AppBar(title: const Text('Cadastro de usuarios')),
        body: Column(
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(hintText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(hintText: 'Senha'),
            ),
            TextField(
              controller: perfilController,
              decoration: const InputDecoration(hintText: 'perfil'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  usuarioFuturo = cadastroUsuario(
                      nomeController.text,
                      emailController.text,
                      senhaController.text,
                      int.parse(perfilController.text));
                });
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
