import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minerd_app/services/database_helper.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class MapaVisitasScreen extends StatefulWidget {
  @override
  _MapaVisitasScreenState createState() => _MapaVisitasScreenState();
}

class _MapaVisitasScreenState extends State<MapaVisitasScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(18.5001200, -69.9885700); 

  @override
  void initState() {
    super.initState();
    _loadVisitas();
  }

  Future<void> _loadVisitas() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> visitas = await db.query(DatabaseHelper.tableVisitas);

    setState(() {
      _markers.clear(); 
      for (final visita in visitas) {
        final marker = Marker(
          markerId: MarkerId(visita['cedula_director'].toString()),
          position: LatLng(visita['latitud'], visita['longitud']),
          infoWindow: InfoWindow(
            title: visita['motivo'],
            snippet: visita['comentario'],
            onTap: () {
              
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(visita['motivo']),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Código Escuela: ${visita['codigoescuela']}'),
                        Text('Comentario: ${visita['comentario']}'),
                        Text('Fecha: ${visita['fecha']}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
        _markers.add(marker);
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Visitas'),
        backgroundColor: Colors.blue[800],
      ),
      drawer: DrawerMenu(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        markers: _markers,
        myLocationEnabled: true, 
      ),
    );
  }
}
