import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'detalles_incidencia_screen.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class VisualizacionIncidenciasScreen extends StatefulWidget {
  @override
  _VisualizacionIncidenciasScreenState createState() =>
      _VisualizacionIncidenciasScreenState();
}

class _VisualizacionIncidenciasScreenState
    extends State<VisualizacionIncidenciasScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _incidencias = [];
  List<Map<String, dynamic>> _filteredIncidencias = [];

  @override
  void initState() {
    super.initState();
    _fetchIncidencias();
  }

  Future<void> _fetchIncidencias() async {
    final db = await DatabaseHelper.instance.database;
    final incidencias = await db.query(DatabaseHelper.tableIncidencias);

    setState(() {
      _incidencias = incidencias;
      _filteredIncidencias = incidencias;
    });
  }

  void _filterIncidencias(String query) {
    final filtered = _incidencias.where((incidencia) {
      final codigoEscuela =
          incidencia[DatabaseHelper.columnCodigoEscuela].toString().toLowerCase();
      return codigoEscuela.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredIncidencias = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de Incidencias'),
        backgroundColor: Colors.blueAccent, 
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por código de escuela',
                labelStyle: TextStyle(color: Colors.green), 
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green), 
                ),
                prefixIcon: Icon(Icons.search, color: Colors.green),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              onChanged: _filterIncidencias,
            ),
          ),
          Expanded(
            child: _filteredIncidencias.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron incidencias',
                      style: TextStyle(color: Colors.redAccent), 
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredIncidencias.length,
                    itemBuilder: (context, index) {
                      final incidencia = _filteredIncidencias[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        color: Colors.blueAccent, 
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            incidencia[DatabaseHelper.columnTitulo],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color.fromARGB(255, 253, 253, 253), 
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Centro Educativo: ${incidencia[DatabaseHelper.columnNombreEscuela]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green), 
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fecha: ${incidencia[DatabaseHelper.columnFecha]}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.blueAccent), 
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetallesIncidenciaScreen(
                                        incidencia: incidencia),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


