import 'package:flutter/material.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Colors.blue[800], 
      ),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a la Aplicación MINERD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900], 
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Esta aplicación está diseñada para facilitar el registro y la gestión de incidencias y visitas realizadas por los técnicos del Ministerio de Educación de la República Dominicana (MINERD).',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Características principales:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800], 
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildFeatureCard(
              context,
              '- Registro de Técnicos: Permite a los técnicos crear un perfil con su información personal.',
            ),
            _buildFeatureCard(
              context,
              '- Registro de Incidencias: Facilita el registro de incidencias en los centros educativos con detalles como el título, descripción, foto, y más.',
            ),
            _buildFeatureCard(
              context,
              '- Visualización de Incidencias: Los técnicos pueden buscar y ver las incidencias registradas, detallando cada una de ellas.',
            ),
            _buildFeatureCard(
              context,
              '- Registrar Visitas: Permite a los técnicos registrar visitas a los centros educativos con detalles como el motivo, foto, y ubicación geográfica.',
            ),
            _buildFeatureCard(
              context,
              '- Mapa de Visitas: Muestra en un mapa las visitas realizadas por los técnicos.',
            ),
            _buildFeatureCard(
              context,
              '- Noticias y Estado del Clima: Muestra noticias relevantes para los técnicos y el estado del clima en su ubicación actual.',
            ),
            SizedBox(height: 20),
            Text(
              'Esperamos que esta herramienta sea útil para su labor diaria y ayude a mejorar la gestión en los centros educativos.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String feature) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          feature,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}



