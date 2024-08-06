import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
            accountName: Text(
              'Gabriel Pozo',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              '20220416@itla.edu.do',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'G',
                style: TextStyle(fontSize: 40.0, color: Colors.blue[800]),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            Icons.home,
            'Inicio',
            '/InicioScreen',
          ),
          _buildDrawerItem(
            context,
            Icons.person_add,
            'Registrar Técnicos',
            '/registro',
          ),
          _buildDrawerItem(
            context,
            Icons.report,
            'Registrar Incidencias',
            '/incidencias',
          ),
          _buildDrawerItem(
            context,
            Icons.list,
            'Lista de Incidencias',
            '/vistaincidencias',
          ),
          _buildDrawerItem(
            context,
            Icons.search,
            'Consultar Cédula',
            '/consulta',
          ),
          _buildDrawerItem(
            context,
            Icons.assignment,
            'Registrar Visitas',
            '/visitas',
          ),
          _buildDrawerItem(
            context,
            Icons.list_alt,
            'Lista de Visitas',
            '/listavisitas',
          ),
          _buildDrawerItem(
            context,
            Icons.map,
            'Mapa de Visitas',
            '/mapa',
          ),
          _buildDrawerItem(
            context,
            Icons.video_library,
            'Video Demostrativo',
            '/video',
          ),
          _buildDrawerItem(
            context,
            Icons.article,
            'Noticias',
            '/noticias',
          ),
          _buildDrawerItem(
            context,
            Icons.info,
            'Acerca de',
            '/acerca',
          ),
          _buildDrawerItem(
            context,
            Icons.exit_to_app,
            'Cerrar Sesión',
            '/login',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue[800], 
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.blue[800], 
        ),
      ),
      onTap: () {
        Navigator.pop(context); 
        Navigator.pushReplacementNamed(context, route); 
      },
    );
  }
}

