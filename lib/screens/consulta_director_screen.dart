import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minerd_app/widgets/drawer_menu.dart';

class ConsultaDirectorScreen extends StatefulWidget {
  @override
  _ConsultaDirectorScreenState createState() => _ConsultaDirectorScreenState();
}

class _ConsultaDirectorScreenState extends State<ConsultaDirectorScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  Map<String, dynamic>? _directorData;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchDirectorData(String cedula) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = 'https://dgii.gov.do/app/WebApps/ConsultasWeb/consultas/ciudadanos.aspx?cedula=$cedula';
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _directorData = json.decode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Error al obtener datos. Por favor verifique la cédula ingresada.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Inténtelo nuevamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Director por Cédula'),
        backgroundColor: Colors.blueAccent, 
      ),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cedulaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingrese la Cédula del Director',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.blueAccent), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent), 
                ),
              ),
              cursorColor: Colors.blueAccent, 
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_cedulaController.text.isNotEmpty) {
                  _fetchDirectorData(_cedulaController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, 
              ),
              child: Text('Consultar'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator(color: Colors.blueAccent) 
                : _errorMessage.isNotEmpty
                    ? Text(_errorMessage, style: TextStyle(color: Colors.red))
                    : _directorData != null
                        ? Expanded(
                            child: ListView(
                              children: [
                                if (_directorData!['foto'] != null)
                                  Image.network(_directorData!['foto']),
                                ListTile(
                                  title: Text(
                                    'Nombre',
                                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
                                  ),
                                  subtitle: Text(
                                    _directorData!['nombre'],
                                    style: TextStyle(color: Colors.blueGrey), 
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Apellido',
                                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
                                  ),
                                  subtitle: Text(
                                    _directorData!['apellido'],
                                    style: TextStyle(color: Colors.blueGrey), 
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Fecha de Nacimiento',
                                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
                                  ),
                                  subtitle: Text(
                                    _directorData!['fecha_nacimiento'],
                                    style: TextStyle(color: Colors.blueGrey), 
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Dirección',
                                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), 
                                  ),
                                  subtitle: Text(
                                    _directorData!['direccion'],
                                    style: TextStyle(color: Colors.blueGrey), 
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
          ],
        ),
      ),
    );
  }
}
