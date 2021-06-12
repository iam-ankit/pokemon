import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon/providers/downloadqueueModal.dart';
import 'package:pokemon/home_screen.dart';
import 'package:image_downloader/image_downloader.dart';

void main() {
  runApp(Pokemon());
}

class Pokemon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => DownloadModel(),
        child: LaunchPad(),
      ),
    );
  }
}

class LaunchPad extends StatefulWidget {
  const LaunchPad({Key key}) : super(key: key);

  @override
  _LaunchPadState createState() => _LaunchPadState();
}

class _LaunchPadState extends State<LaunchPad> {
  download(url) async {
    await ImageDownloader.downloadImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomeScreen(),
          Consumer<DownloadModel>(builder: (context, data, child) {
            for (int i = 0; i < data.downloadList.length; i++) {
              data.downloadList.forEach((key, value) => download(value));
            }
            return Positioned(
              bottom: 70,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text(data.downloadList.length.toString())],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
