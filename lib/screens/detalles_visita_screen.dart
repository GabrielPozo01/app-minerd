import 'package:flutter/material.dart';
import 'dart:io';

class DetallesVisitaScreen extends StatelessWidget {
  final Map<String, dynamic> visita;

  DetallesVisitaScreen({required this.visita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Visita'),
        backgroundColor: Colors.blue[900], // Color azul oscuro
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cédula del Director: ${visita['cedula_director']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Código Escuela: ${visita['codigoescuela']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Motivo: ${visita['motivo']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Comentario: ${visita['comentario']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Latitud: ${visita['latitud']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Longitud: ${visita['longitud']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fecha: ${visita['fecha']}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue[900], // Color del texto
              ),
            ),
            SizedBox(height: 16),
            if (visita['foto_evidencia'] != null && visita['foto_evidencia'].toString().isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[300]!, width: 2), // Borde azul claro
                ),
                child: Image.file(
                  File(visita['foto_evidencia']),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

