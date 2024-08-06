import 'package:flutter/material.dart';
import 'package:minerd_app/services/database_helper.dart';
import 'detalles_visita_screen.dart';
import 'estado_clima_screen.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class ListaVisitasScreen extends StatefulWidget {
  @override
  _ListaVisitasScreenState createState() => _ListaVisitasScreenState();
}

class _ListaVisitasScreenState extends State<ListaVisitasScreen> {
  List<Map<String, dynamic>> _visitas = [];

  @override
  void initState() {
    super.initState();
    _loadVisitas();
  }

  Future<void> _loadVisitas() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(DatabaseHelper.tableVisitas);
    setState(() {
      _visitas = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Visitas'),
        backgroundColor: Colors.blue[900], // Color azul oscuro
      ),
      drawer: DrawerMenu(),
      body: Container(
        color: Colors.blue[50], // Fondo azul claro
        child: _visitas.isEmpty
            ? Center(
                child: Text(
                  'No hay visitas registradas',
                  style: TextStyle(fontSize: 18, color: Colors.blue[900]), // Color de texto
                ),
              )
            : ListView.builder(
                itemCount: _visitas.length,
                itemBuilder: (context, index) {
                  final visita = _visitas[index];

                  final latitud = visita['latitud'];
                  final longitud = visita['longitud'];

                  return Card(
                    color: Colors.blue[100], // Fondo de las tarjetas
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        visita['motivo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900], // Color del texto
                        ),
                      ),
                      subtitle: Text(
                        'Código Escuela: ${visita['codigoescuela']}\nComentario: ${visita['comentario']}',
                        style: TextStyle(color: Colors.blue[800]), // Color de subtítulo
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cloud, color: Colors.blue[700]), // Icono color azul
                        onPressed: () {
                          if (latitud != null && longitud != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EstadoClimaScreen(
                                  latitud: latitud,
                                  longitud: longitud,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Latitud o Longitud no disponibles')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesVisitaScreen(visita: visita),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
