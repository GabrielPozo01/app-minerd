import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minerd_app/widgets/drawer_menu.dart';

class NoticiasScreen extends StatefulWidget {
  @override
  _NoticiasScreenState createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  List<dynamic> _noticias = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNoticias();
  }

  Future<void> _fetchNoticias() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = 'https://remolacha.net/wp-json/wp/v2/posts?search=minerd';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _noticias = json.decode(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Error al obtener noticias. Intente nuevamente más tarde.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Inténtelo nuevamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias MINERD'),
        backgroundColor: Colors.blue[900], 
      ),
      drawer: DrawerMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: _noticias.length,
                  itemBuilder: (context, index) {
                    final noticia = _noticias[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          noticia['title']['rendered'],
                          style: TextStyle(color: Colors.blue[900]), 
                        ),
                        subtitle: Text(
                          noticia['excerpt']['rendered'].replaceAll(RegExp(r'<[^>]*>'), ''), 
                          style: TextStyle(color: Colors.blue[700]), 
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetallesNoticiaScreen(noticia: noticia),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class DetallesNoticiaScreen extends StatelessWidget {
  final Map<String, dynamic> noticia;

  DetallesNoticiaScreen({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          noticia['title']['rendered'],
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.blue[900], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noticia['title']['rendered'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0), 
              ),
            ),
            SizedBox(height: 20),
            Text(
              noticia['content']['rendered'].replaceAll(RegExp(r'<[^>]*>'), ''), 
              style: TextStyle(fontSize: 16, color: Colors.blue[800]), 
            ),
          ],
        ),
      ),
    );
  }
}

