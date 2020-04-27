import 'package:flutter/material.dart';

class SearchButton extends StatefulWidget {
  @override
  SearchButtonState createState()  => SearchButtonState();
}

class SearchButtonState extends State<SearchButton> {
  Duration duration = Duration(milliseconds: 100);
  double width;
  double height;

  @override
  void initState() {
    width = 100;
    height = 70;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: PhysicalModel(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(30),
        ),
        child: InkWell(
          onTap: animateScale,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            onEnd: navigate,
            curve: Curves.easeOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.shade500,
                      Colors.purple.shade800,
                      Colors.purple.shade900
                    ]
                )
            ),
            child: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  void animateScale() {
    setState(() {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
    });
  }

  void navigate() {
    if (width == MediaQuery.of(context).size.width) {
      Navigator.of(context).pushNamed('search').then((_) => setState(() {
          width = 100;
          height = 70;
        })
      );
    }
  }
}