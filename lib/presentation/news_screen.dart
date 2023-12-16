import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newswave/model/news_model.dart';

import 'nord_palette.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, required this.news, required this.index});
  final int index;
  final News? news;
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>{

  ClipRRect getStateOfURL(int index) {
    double width = MediaQuery.sizeOf(context).width;
    double height = 300;
    if (widget.news?.articles[widget.index]['urlToImage'] == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/images/newspaper.png", height: height, width: width,),
      );
    }
    else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(widget.news?.articles[widget.index]['urlToImage'], height: height, width: width,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: NordPalette.nord4,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              getStateOfURL(widget.index),
              Flexible(
                  child: Text(
                    widget.news?.articles[widget.index]['content'] ?? ""
                  )
              )
            ],
          ),
        )
    );
  }
}