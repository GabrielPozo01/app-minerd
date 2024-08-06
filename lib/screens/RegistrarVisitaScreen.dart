import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; 
import 'package:minerd_app/services/database_helper.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class RegistrarVisitaScreen extends StatefulWidget {
  @override
  _RegistrarVisitaScreenState createState() => _RegistrarVisitaScreenState();
}

class _RegistrarVisitaScreenState extends State<RegistrarVisitaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  XFile? _image;
  String? _codigoCentro;
  String _cedulaDirector = '';
  String _motivoVisita = '';
  String _comentario = '';
  double _latitud = 0.0;
  double _longitud = 0.0;
  DateTime _fecha = DateTime.now();

  List<String> _codigosEscuelas = [];

  @override
  void initState() {
    super.initState();
    _loadCodigosEscuelas();
  }

  Future<void> _loadCodigosEscuelas() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      DatabaseHelper.tableIncidencias,
      distinct: true,
      columns: ['codigoescuela'],
    );
    setState(() {
      _codigosEscuelas = result.map((e) => e['codigoescuela'] as String).toList();
    });
  }

  Future<void> _loadMotivoVisita(String codigoCentro) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      DatabaseHelper.tableIncidencias,
      where: 'codigoescuela = ?',
      whereArgs: [codigoCentro],
      columns: ['titulo'],
    );
    if (result.isNotEmpty) {
      setState(() {
        _motivoVisita = result.first['titulo'] as String;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _registerVisit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final db = await DatabaseHelper.instance.database;
      await db.insert(
        DatabaseHelper.tableVisitas,
        {
          'cedula_director': _cedulaDirector,
          'codigoescuela': _codigoCentro,
          'motivo': _motivoVisita,
          'foto_evidencia': _image?.path,
          'comentario': _comentario,
          'latitud': _latitud,
          'longitud': _longitud,
          'fecha': DateFormat('yyyy-MM-dd').format(_fecha),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      
      _formKey.currentState!.reset();
      setState(() {
        _image = null;
        _codigoCentro = null;
        _cedulaDirector = '';
        _motivoVisita = '';
        _comentario = '';
        _latitud = 0.0;
        _longitud = 0.0;
        _fecha = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Visita registrada exitosamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Visita'),
        backgroundColor: Colors.blue[800],
      ),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              
              DropdownButtonFormField<String>(
                value: _codigoCentro,
                hint: Text('Seleccionar código de centro'),
                items: _codigosEscuelas.map((codigo) {
                  return DropdownMenuItem<String>(
                    value: codigo,
                    child: Text(codigo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _codigoCentro = value;
                    if (value != null) {
                      _loadMotivoVisita(value);
                    }
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un código de centro';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cédula del director',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cédula del director';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cedulaDirector = value ?? '';
                },
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Motivo de la visita',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _motivoVisita,
                ),
                readOnly: true,
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Comentario',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _comentario = value ?? '';
                },
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Latitud',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la latitud';
                  }
                  return null;
                },
                onSaved: (value) {
                  _latitud = double.tryParse(value ?? '') ?? 0.0;
                },
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Longitud',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la longitud';
                  }
                  return null;
                },
                onSaved: (value) {
                  _longitud = double.tryParse(value ?? '') ?? 0.0;
                },
              ),
              SizedBox(height: 16.0),

              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: DateFormat('yyyy-MM-dd').format(_fecha),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _fecha) {
                    setState(() {
                      _fecha = selectedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),

              
              Row(
                children: [
                  Text('Foto evidencia: '),
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: _pickImage,
                  ),
                  _image != null
                      ? Image.file(
                          File(_image!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 16.0),

              
              ElevatedButton(
                onPressed: _registerVisit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, 
                ),
                child: Text('Registrar Visita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



