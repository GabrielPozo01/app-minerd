import 'package:flutter/material.dart';
import 'dart:io';

class DetallesIncidenciaScreen extends StatelessWidget {
  final Map<String, dynamic> incidencia;

  DetallesIncidenciaScreen({required this.incidencia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Incidencia'),
        backgroundColor: Colors.blueAccent, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Título',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['titulo'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Código de la Escuela',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['codigoescuela'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Centro Educativo',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['nombreescuela'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Regional',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['regional'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Distrito',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['distrito'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Fecha',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['fecha'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Descripción',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: Text(
                incidencia['descripcion'] ?? '',
                style: TextStyle(color: Colors.blueGrey), 
              ),
            ),
            ListTile(
              title: Text(
                'Foto',
                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
              ),
              subtitle: incidencia['foto'] != null
                  ? Image.file(File(incidencia['foto']))
                  : Text(
                      'No hay foto disponible',
                      style: TextStyle(color: Colors.blueGrey), 
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
