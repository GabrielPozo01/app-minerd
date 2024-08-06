import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'screens/login_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/registro_tecnicos_screen.dart';
import 'screens/registro_incidencias_screen.dart';
import 'screens/visualizacion_incidencias_screen.dart';
import 'screens/detalles_incidencia_screen.dart';
import 'screens/AcercaDeScreen.dart';
import 'screens/RegistrarVisitaScreen.dart';
import 'screens/lista_visitas_screen.dart';
import 'screens/detalles_visita_screen.dart';
import 'screens/mapa_visitas_screen.dart';
import 'screens/video_demostrativo_screen.dart';
import 'screens/consulta_director_screen.dart';
import 'screens/noticias_screen.dart';






import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  final db = await DatabaseHelper.instance.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de MINERD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/registro': (context) => RegistroTecnicosScreen(),
        '/InicioScreen': (context) => InicioScreen(),
        '/incidencias': (context) => RegistroIncidenciasScreen(),
        '/vistaincidencias': (context) => VisualizacionIncidenciasScreen(),
        '/consulta': (context) => ConsultaDirectorScreen(),
        '/visitas': (context) => RegistrarVisitaScreen(),
        '/listavisitas': (context) => ListaVisitasScreen(),
        '/mapa': (context) => MapaVisitasScreen(),
        '/video': (context) => VideoDemostrativoScreen(),
        '/noticias': (context) => NoticiasScreen(),
        '/acerca': (context) => AcercaDeScreen(),

      },
    );
  }
}
