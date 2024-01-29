import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newswave/model/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'themes.dart';

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

  _launchURL(String newsArticleLink) async {
   final Uri url = Uri.parse(newsArticleLink);
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: OceanTheme.richBlack,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: OceanTheme.timberwolf
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                getStateOfURL(widget.index),
                Flexible(
                    child: Text(
                      widget.news?.articles[widget.index]['content'] ?? "",
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white
                      ),
                    )
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    _launchURL(widget.news?.articles[widget.index]['url']);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(OceanTheme.timberwolf),
                    foregroundColor: MaterialStatePropertyAll<Color>(OceanTheme.richBlack),
                  ),
                  child: Text(
                      "Read full article"
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}