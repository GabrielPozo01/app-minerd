import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../services/database_helper.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';
import 'package:sqflite/sqflite.dart';

class RegistroTecnicosScreen extends StatefulWidget {
  @override
  _RegistroTecnicosScreenState createState() => _RegistroTecnicosScreenState();
}

class _RegistroTecnicosScreenState extends State<RegistroTecnicosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _fraseController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _matriculaController.dispose();
    _usuarioController.dispose();
    _contrasenaController.dispose();
    _fraseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveTecnico(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String nombre = _nombreController.text;
      String apellido = _apellidoController.text;
      int matricula = int.tryParse(_matriculaController.text) ?? 0;
      String usuario = _usuarioController.text;
      String contrasena = _contrasenaController.text;
      String frase = _fraseController.text;

      String? imagePath;
      if (_image != null) {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String newPath = join(documentsDirectory.path, '${matricula}_foto.png');
        File newImage = await _image!.copy(newPath);
        imagePath = newImage.path;
      }

      final db = await DatabaseHelper.instance.database;

      await db.insert(DatabaseHelper.tableTecnicos, {
        DatabaseHelper.columnNombre: nombre,
        DatabaseHelper.columnApellido: apellido,
        DatabaseHelper.columnMatricula: matricula,
        DatabaseHelper.columnFoto: imagePath,
        DatabaseHelper.columnUsuario: usuario,
        DatabaseHelper.columnContrasena: contrasena,
        DatabaseHelper.columnFrase: frase,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Técnico registrado exitosamente')),
      );

      _nombreController.clear();
      _apellidoController.clear();
      _matriculaController.clear();
      _usuarioController.clear();
      _contrasenaController.clear();
      _fraseController.clear();
      setState(() {
        _image = null;
      });

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Técnicos'),
        backgroundColor: Colors.blue[800],
      ),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _matriculaController,
                decoration: InputDecoration(
                  labelText: 'Matrícula',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su matrícula';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _image == null
                  ? Text(
                      'No se ha seleccionado ninguna imagen',
                      style: TextStyle(color: Colors.red),
                    )
                  : Image.file(_image!),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Seleccionar Foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800]!,
                ),
              ),
              TextFormField(
                controller: _usuarioController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fraseController,
                decoration: InputDecoration(
                  labelText: 'Frase',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una frase';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveTecnico(context),
                child: Text('Registrar Técnico'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800]!,
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



