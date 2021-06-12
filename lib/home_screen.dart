import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokemon/detail_screen.dart';
import 'package:pokemon/pokemon.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:pokemon/providers/values.dart';
import 'package:pokemon/providers/interceptor/dio_connectivity_request_retrier.dart';
import 'package:pokemon/providers/interceptor/retryer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pokemon;
  Dio dio;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    if (mounted) {
      fetchPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Color _greenColor = Color(0xff2a9d8f);
    Color _redColor = Color(0xffe76f51);
    Color _blueColor = Color(0xff37A5C6);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'images/logo.png',
              width: 200,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
              top: 100,
              left: 20,
              child: Text(
                'catch \'em all',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              )),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                pokemon != null
                    ? Expanded(
                        child: StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      itemCount: pokemon.length,
      itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: InkWell(
                                  child: SafeArea(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: poketypecolor.containsKey(pokemon[index]['type'][0])? poketypecolor[pokemon[index]['type'][0]] : Color(0xff5795a3),
                                          borderRadius: BorderRadius.all(Radius.circular(25))),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: -10,
                                            right: -10,
                                            child: Opacity(
                                              opacity: 0.7,
                                              child: Image.asset(
                                                poketypeimage.containsKey(pokemon[index]['type'][0])? poketypeimage[pokemon[index]['type'][0]]:'images/pokeball.png',
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            right: 5,
                                            child: Hero(
                                              tag: index,
                                              child: Image.network(
                                                pokemon[index]['img'],
                                                //height: 100,
                                                // fit: BoxFit.fitHeight,
                                                // placeholder: (context,url) => Center(
                                                //   child: CircularProgressIndicator(),
                                                // )
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 55,
                                            left: 15,
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Text(
                                                  pokemon[index]['type'][0],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      shadows: [
                                                        BoxShadow(
                                                            color:
                                                                Colors.blueGrey,
                                                            offset:
                                                                Offset(0, 0),
                                                            spreadRadius: 1.0,
                                                            blurRadius: 15)
                                                      ]),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                          ),
                                          Positioned(
                                            top: 30,
                                            left: 15,
                                            child: Text(
                                              pokemon[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  shadows: [
                                                    BoxShadow(
                                                        color: Colors.blueGrey,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 1.0,
                                                        blurRadius: 15)
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailScreen(
                                                  heroTag: index,
                                                  pokemonDetail: pokemon[index],
                                                  color: poketypecolor.containsKey(pokemon[index]['type'][0])? poketypecolor[pokemon[index]['type'][0]] : Color(0xff5795a3),
                                                )));
                                  },
                                ),
                              ),
      staggeredTileBuilder: (index) => StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    )
                        // GridView.builder(
                        //     gridDelegate:
                        //         SliverGridDelegateWithFixedCrossAxisCount(
                        //             crossAxisCount: 2, childAspectRatio: 1.4),
                        //     shrinkWrap: true,
                        //     physics: BouncingScrollPhysics(),
                        //     itemCount: pokemon.length,
                        //     itemBuilder: (context, index) {
                        //       return 
                        //     }))
                    )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: 150,
              width: width,
            ),
          ),
        ]));
  }

  void fetchPokemonData() async {
    final response = await dio.get(
        'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json');
    setState(() {
      var data = jsonDecode(response.data);
      pokemon = data['pokemon'];
    });
    // var url = Uri.https('raw.githubusercontent.com',
    //     '/Biuni/PokemonGO-Pokedex/master/pokemon.json');
    // http.get(url).then((value) {
    //   if (value.statusCode == 200) {
    //     var data = jsonDecode(value.body);
    //     pokemon = data['pokemon'];

    //     setState(() {});

    //     print(pokemon);
    //   }
    // }).catchError((e) {
    //   print(e);
    // });
  }
}


// class StaggeredView extends StatelessWidget {
//   const StaggeredView({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StaggeredGridView.countBuilder(
//       crossAxisCount: 3,
//       itemCount: imageList.length,
//       itemBuilder: (context, index) => ImageCard(
//         imageData: imageList[index],
//       ),
//       staggeredTileBuilder: (index) => StaggeredTile.count(
//           (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
//       mainAxisSpacing: 8.0,
//       crossAxisSpacing: 8.0,
//     );
//   }
// }
