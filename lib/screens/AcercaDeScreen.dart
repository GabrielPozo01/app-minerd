import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class AcercaDeScreen extends StatefulWidget {
  @override
  _AcercaDeScreenState createState() => _AcercaDeScreenState();
}

class _AcercaDeScreenState extends State<AcercaDeScreen> {
  Map<String, dynamic>? tecnicoData;

  @override
  void initState() {
    super.initState();
    _loadTecnicoData();
  }

  Future<void> _loadTecnicoData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedInUser');

    if (username != null) {
      final db = await DatabaseHelper.instance.database;

      if (username == 'admin') {
        
        setState(() {
          tecnicoData = {
            'nombre': 'Admin',
            'apellido': 'User',
            'matricula': 'N/A',
            'foto': 'assets/images/default_avatar.png', 
            'usuario': 'admin',
            'contrasena': '00',
            'frase': 'Administrador del sistema',
          };
        });
      } else {
        
        final List<Map<String, dynamic>> result = await db.query(
          DatabaseHelper.tableTecnicos,
          where: '${DatabaseHelper.columnUsuario} = ?',
          whereArgs: [username],
        );

        if (result.isNotEmpty) {
          setState(() {
            tecnicoData = result.first;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tecnicoData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Acerca De'),
          backgroundColor: Colors.blue[900], 
        ),
        drawer: DrawerMenu(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca De'),
        backgroundColor: Colors.blue[900], 
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, 
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: tecnicoData!['foto'] != null &&
                            tecnicoData!['foto'] != 'assets/images/default_avatar.png'
                        ? AssetImage(tecnicoData!['foto'])
                        : AssetImage('assets/images/default_avatar.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Nombre: ${tecnicoData!['nombre']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900], 
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Apellido: ${tecnicoData!['apellido']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Matrícula: ${tecnicoData!['matricula']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Usuario: ${tecnicoData!['usuario']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Frase:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900], 
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    tecnicoData!['frase'] ?? 'N/A',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



