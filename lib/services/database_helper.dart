import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "minerd.db";
  static final _databaseVersion = 2; 

  static final tableTecnicos = 'tecnicos';
  static final tableIncidencias = 'incidencias';
  static final tableVisitas = 'visitas';

  // tabla de tecnicos
  static final columnNombre = 'nombre';
  static final columnApellido = 'apellido';
  static final columnMatricula = 'matricula';  
  static final columnFoto = 'foto';
  static final columnUsuario = 'usuario';
  static final columnContrasena = 'contrasena'; 
  static final columnFrase = 'frase';

  // tabla de incidencias
  static final columnTitulo = 'titulo';
  static final columnCodigoEscuela = 'codigoescuela'; 
  static final columnNombreEscuela = 'nombreescuela';
  static final columnRegional = 'regional';
  static final columnDistrito = 'distrito';
  static final columnFecha = 'fecha';
  static final columnDescripcion = 'descripcion';
  static final columnFotoIncidencia = 'foto';

   // tabla de visitas
  static final columnCedulaDirector = 'cedula_director'; 
  static final columnCodigoEscuelaVisita = 'codigoescuela'; 
  static final columnMotivo = 'motivo';
  static final columnFotoEvidencia = 'foto_evidencia';
  static final columnComentario = 'comentario';
  static final columnLatitud = 'latitud';
  static final columnLongitud = 'longitud';
  static final columnFechaVisita = 'fecha';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTecnicos (
        $columnNombre TEXT NOT NULL,
        $columnApellido TEXT NOT NULL,
        $columnMatricula INTEGER NOT NULL PRIMARY KEY,
        $columnFoto TEXT,
        $columnUsuario TEXT NOT NULL,
        $columnContrasena TEXT NOT NULL,
        $columnFrase TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableIncidencias (
        $columnTitulo TEXT NOT NULL,
        $columnCodigoEscuela INTEGER NOT NULL,
        $columnNombreEscuela TEXT NOT NULL,
        $columnRegional TEXT,
        $columnDistrito TEXT,
        $columnFecha TEXT,
        $columnDescripcion TEXT,
        $columnFotoIncidencia TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableVisitas (
        $columnCedulaDirector INTEGER NOT NULL,
        $columnCodigoEscuelaVisita INTEGER, // Nueva columna
        $columnMotivo TEXT,
        $columnFotoEvidencia TEXT,
        $columnComentario TEXT,
        $columnLatitud REAL,
        $columnLongitud REAL,
        $columnFechaVisita TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {
        await db.execute('''
          ALTER TABLE $tableVisitas ADD COLUMN $columnCodigoEscuelaVisita INTEGER
        ''');
      }
    }
  }
}

