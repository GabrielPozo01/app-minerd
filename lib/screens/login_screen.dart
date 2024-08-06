import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minerd_app/screens/registro_tecnicos_screen.dart';
import 'package:minerd_app/screens/inicio_screen.dart';
import '../services/database_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      
      if (_username == 'admin' && _password == '00') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso')),
        );

        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUser', 'admin');

        Navigator.pushReplacementNamed(context, '/InicioScreen');
        return;
      }

      final db = await DatabaseHelper.instance.database;

      
      final List<Map<String, dynamic>> result = await db.query(
        DatabaseHelper.tableTecnicos,
        where: '${DatabaseHelper.columnUsuario} = ? AND ${DatabaseHelper.columnContrasena} = ?',
        whereArgs: [_username, _password],
      );

      if (result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso')),
        );

        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUser', _username);

        Navigator.pushReplacementNamed(context, '/InicioScreen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistroTecnicosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/logo.png'), 
                ),
                SizedBox(height: 20),
                
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su usuario';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value ?? '';
                  },
                ),
                SizedBox(height: 20),
                
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value ?? '';
                  },
                ),
                SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Iniciar Sesión'),
                ),
                SizedBox(height: 20),
                
                GestureDetector(
                  onTap: _goToRegister,
                  child: Text(
                    '¿No tienes cuenta? Crea una aquí',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

