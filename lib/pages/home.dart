
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../components/constants.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);



  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Home",
                style: GoogleFonts.comfortaa(
                  color: kPrimaryColor2,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 20),
              Text(" Good morning, Nashe".toUpperCase(),
                  style: GoogleFonts.lato(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width,
                child: Stack(children: [
                  Image.asset("assets/et.jpg",
                      fit: BoxFit.cover,
                      height: 350,
                      alignment: Alignment.center),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "\"This is an Example of the quote\"",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 55,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text("Nashe",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w300,
                                fontSize: 25,
                                color: kPrimaryColor))
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                children: [
                  Text(" browse stories".toUpperCase(),
                      style: GoogleFonts.lato(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  const Icon(
                    LineIcons.arrowDown,
                    color: kPrimaryColor2,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SafeArea(
                  child: SizedBox(
                    height: 400,
                    child: SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: const [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(index: 0),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: Tile(index: 1),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(index: 2),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: Tile(index: 3),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 4,
                            mainAxisCellCount: 2,
                            child: Tile(index: 4),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(index: 5),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(index: 6),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(index: 7),

                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 2,
                            child: Tile(index: 8),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color(0xFFEAEAEA),
      ),
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
