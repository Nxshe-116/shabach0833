

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:line_icons/line_icons.dart';
import 'package:shabach/components/constants.dart';

import '../models/UIHelper.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  int _activeCategory = 1;

  void  checkValues() {
    String keywords = searchController.text.trim();


    if(keywords == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please enter a keyword to search");
    }
    else {

    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(

                horizontal: 15
            ),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Search", style: GoogleFonts.comfortaa(
                      color: kPrimaryColor2,
                      fontSize: 40,
                    ),
                      textAlign: TextAlign.start,),

                    const SizedBox(height: 20,),

                    TextFormField(
                        autofocus: false,
                        controller: searchController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon:const Icon(LineIcons.search),

                          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Search all photos, plans videos, podcasts",
                          hintStyle:  GoogleFonts.poppins( color: Colors.grey),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: kPrimaryColor2, width: 15.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        )),

                    const SizedBox(height: 25,),
                                      ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(

                    children: [
                      _makeCategoryContainer('For you', 1),
                      _makeCategoryContainer('Popular', 2),
                      _makeCategoryContainer('Example', 3),
                      _makeCategoryContainer('Anxiety', 4),
                      _makeCategoryContainer('Depression', 5),
                      _makeCategoryContainer('Podcasts', 6),
                    ],
                  ),
                ),
                const SizedBox(height: 25 ),
                SizedBox(
                  height: 520,
                  child: SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children:  const [
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Tile(index: 0),
                        ),

                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Tile(index: 1),
                        ),

                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
                          mainAxisCellCount: 2,
                          child: Tile(index: 2),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Tile(index: 3),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 2,
                          mainAxisCellCount: 2,
                          child: Tile(index: 4),
                        ),

                        StaggeredGridTile.count(
                          crossAxisCellCount: 4,
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
                          mainAxisCellCount: 1,
                          child: Tile(index: 7),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: Tile(index: 8),
                        ),
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: Tile(index: 9),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

    );
  }
  /// make category container widget.
  Widget _makeCategoryContainer(String title, int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeCategory = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(
            title,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: (id == _activeCategory) ? Colors.white : Colors.black)
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: (id == _activeCategory) ? mainPrimaryColor : Colors.grey[200],
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

