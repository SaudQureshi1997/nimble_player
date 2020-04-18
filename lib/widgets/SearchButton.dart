import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
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
//            bottomRight: Radius.circular(20)
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('search');
          },
          child: Container(
            width: 100,
            height: 70,
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
}