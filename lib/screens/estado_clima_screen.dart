import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EstadoClimaScreen extends StatefulWidget {
  final double? latitud;
  final double? longitud;

  EstadoClimaScreen({this.latitud, this.longitud});

  @override
  _EstadoClimaScreenState createState() => _EstadoClimaScreenState();
}

class _EstadoClimaScreenState extends State<EstadoClimaScreen> {
  Map<String, dynamic>? _climaData;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchClima();
  }

  Future<void> _fetchClima() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String appId = '77e56d9e';
    final String appKey = '0d2980d72a51302ec68e71bfb0e8c4d6';
    final String url = 'http://api.weatherunlocked.com/api/current/${widget.latitud},${widget.longitud}?app_id=$appId&app_key=$appKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _climaData = json.decode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Error al obtener el estado del clima. Intente nuevamente más tarde.';
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
        title: Text('Estado del Clima'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás en la pila de navegación
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : _climaData != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Temperatura: ${_climaData!['temp_c']}°C',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Descripción: ${_climaData!['wx_desc']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Viento: ${_climaData!['windspd_kmh']} km/h',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Humedad: ${_climaData!['humid_pct']}%',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text('No se pudo obtener el estado del clima')),
    );
  }
}

