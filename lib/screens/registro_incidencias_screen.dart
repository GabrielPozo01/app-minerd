import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/database_helper.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class RegistroIncidenciasScreen extends StatefulWidget {
  @override
  _RegistroIncidenciasScreenState createState() => _RegistroIncidenciasScreenState();
}

class _RegistroIncidenciasScreenState extends State<RegistroIncidenciasScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _codigoEscuela = '';
  String _nombreEscuela = '';
  String _regional = '';
  String _distrito = '';
  DateTime? _fecha;
  String _descripcion = '';
  File? _foto;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _foto = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveIncidencia(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final db = await DatabaseHelper.instance.database;
      await db.insert(DatabaseHelper.tableIncidencias, {
        DatabaseHelper.columnTitulo: _titulo,
        DatabaseHelper.columnCodigoEscuela: _codigoEscuela,
        DatabaseHelper.columnNombreEscuela: _nombreEscuela,
        DatabaseHelper.columnRegional: _regional,
        DatabaseHelper.columnDistrito: _distrito,
        DatabaseHelper.columnFecha: _fecha?.toIso8601String(),
        DatabaseHelper.columnDescripcion: _descripcion,
        DatabaseHelper.columnFoto: _foto?.path,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incidencia registrada exitosamente')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _foto = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Incidencia'),
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
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titulo = value ?? '';
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Código de la Escuela',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el código de la escuela';
                  }
                  return null;
                },
                onSaved: (value) {
                  _codigoEscuela = value ?? '';
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Centro Educativo',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el centro educativo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombreEscuela = value ?? '';
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Regional',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la regional';
                  }
                  return null;
                },
                onSaved: (value) {
                  _regional = value ?? '';
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Distrito',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el distrito';
                  }
                  return null;
                },
                onSaved: (value) {
                  _distrito = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(_fecha == null
                    ? 'Fecha: No seleccionada'
                    : 'Fecha: ${_fecha!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today, color: Colors.blue[800]),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _fecha = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descripcion = value ?? '';
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  _foto == null
                      ? Text('No se ha seleccionado una imagen.')
                      : Image.file(_foto!, width: 100, height: 100),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Tomar Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800]!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveIncidencia(context),
                child: Text('Guardar Incidencia'),
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
