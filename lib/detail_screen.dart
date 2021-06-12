import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:pokemon/providers/values.dart';
import 'package:provider/provider.dart';
import 'package:pokemon/providers/downloadqueueModal.dart';
import 'package:path_provider/path_provider.dart';

class DetailScreen extends StatefulWidget {
  final heroTag;
  final pokemonDetail;
  final Color color;

  const DetailScreen({Key key, this.heroTag, this.pokemonDetail, this.color})
      : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Dio dio;
  bool downStatus;
  String progress = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio = Dio();
    downStatus = true;
    print(widget.pokemonDetail);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: widget.color,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            left: 5,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.pokemonDetail['name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "#" + widget.pokemonDetail['num'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              )),
          Positioned(
              top: 110,
              left: 22,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.pokemonDetail['type'].join(", "),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              )),
          Positioned(
            top: height * 0.18,
            right: -30,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                poketypeimage.containsKey(widget.pokemonDetail['type'])
                    ? poketypeimage[widget.pokemonDetail['type']]
                    : 'images/pokeball.png',
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.pokemonDetail['name'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Height',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.pokemonDetail['height'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Weight',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.pokemonDetail['weight'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Spawn Time',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.pokemonDetail['spawn_time'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Weakness',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.pokemonDetail['weaknesses'].join(", "),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Pre Evolution',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                              child:
                                  widget.pokemonDetail['prev_evolution'] != null
                                      ? SizedBox(
                                          height: 20,
                                          width: width * 0.55,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: widget
                                                .pokemonDetail['prev_evolution']
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  widget.pokemonDetail[
                                                          'prev_evolution']
                                                      [index]['name'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Text(
                                          "Just Hatched",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                        )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            child: Text(
                              'Next Evolution',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 17),
                            ),
                          ),
                          Container(
                              child:
                                  widget.pokemonDetail['next_evolution'] != null
                                      ? SizedBox(
                                          height: 20,
                                          width: width * 0.55,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: widget
                                                .pokemonDetail['next_evolution']
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  widget.pokemonDetail[
                                                          'next_evolution']
                                                      [index]['name'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Text(
                                          "Maxed Out",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17),
                                        )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Provider<DownloadModel>(
                        create: (_) => DownloadModel(),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              var dir =
                                  await getApplicationDocumentsDirectory();
                              await dio.download(
                                  widget.pokemonDetail['img'],
                                  "${dir.path}/${widget.pokemonDetail['name']}",
                                  onReceiveProgress: (recived, total) {
                                setState(() {
                                  downStatus = true;
                                  progress = ((recived / total) * 100)
                                          .toStringAsFixed(0) +
                                      "%";
                                });
                              });
                              await ImageDownloader.downloadImage(widget.pokemonDetail['img']);
                              Provider.of<DownloadModel>(context, listen: false)
                                  .addImageInList(
                                      name: widget.pokemonDetail['name'],
                                      url: widget.pokemonDetail['img']);
                            } catch (e) {
                              print(e);
                              setState(() {
                                downStatus = false;
                              });
                            }
                          },
                          icon: Icon(Icons.download),
                          label: Text(downStatus == false
                              ? "error"
                              : progress == ""
                                  ? "download"
                                  : progress)),
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: (height * 0.2),
            left: (width / 2) - 100,
            child: Hero(
              tag: widget.heroTag,
              child: Image.network(
                widget.pokemonDetail['img'],
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
