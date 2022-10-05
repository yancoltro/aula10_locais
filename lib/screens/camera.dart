import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aula10_locais/models/place.dart';
import 'package:aula10_locais/screens/picture.dart';

class CameraScreen extends StatefulWidget {
  final Place place;
  CameraScreen(this.place);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  late List<CameraDescription> cameras;
  late CameraDescription camera;
  Widget cameraPreview = Center(
    child: CircularProgressIndicator(),
  );
  late Image image;

  Future setCamera() async {
    cameras = await availableCameras();
    if (cameras.length != 0) {
      camera = cameras.first;
    }
  }

  @override
  void initState() {
    setCamera().then((_) {
      controller = CameraController(camera, ResolutionPreset.ultraHigh);
      controller.initialize().then((snapshot) {
        cameraPreview = Center(child: CameraPreview(controller));
        setState(() {
          cameraPreview = cameraPreview;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar foto a: ${widget.place.name}'),
      ),
      body: Container(
        child: cameraPreview,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () async {
            // final path = join(
            //   (await getTemporaryDirectory()).path,
            //   '${DateTime.now()}.png',
            // );

            final image = await controller.takePicture();
            MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => PictureScreen(image.path, widget.place));
            Navigator.push(context, route);
          },
          child: Icon(Icons.camera_alt),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
