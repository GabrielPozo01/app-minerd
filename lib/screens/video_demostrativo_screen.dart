import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:minerd_app/widgets/drawer_menu.dart';

class VideoDemostrativoScreen extends StatefulWidget {
  @override
  _VideoDemostrativoScreenState createState() => _VideoDemostrativoScreenState();
}

class _VideoDemostrativoScreenState extends State<VideoDemostrativoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=xeiCT7kh-qQ")!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Demostrativo'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: DrawerMenu(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenidos al Video Demostrativo',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'Este video le mostrará cómo utilizar la aplicación de manera efectiva. Preste atención a los detalles y aprenda cómo aprovechar al máximo todas las funcionalidades ofrecidas.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                _controller.addListener(() {});
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Recuerde que esta aplicación ha sido diseñada para mejorar la eficiencia en sus tareas diarias. ¡Esperamos que este video le sea de gran ayuda!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
