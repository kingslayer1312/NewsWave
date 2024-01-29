import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newswave/presentation/news_screen.dart';
import 'package:newswave/services/news_service.dart';
import '../key/api_key.dart';
import '../model/news_model.dart';
import 'themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _newsService = NewsService(API_KEY);
  News? _news;
  String country = "in";
  Future<void> _fetchNews() async {
    try {
      final news = await _newsService.getNews(country);
      setState(() {
        _news = news;
      });
    } catch (e) {
      print("Error fetching news: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  ClipRRect getStateOfURL(int index) {
    double num = 100;
    if (_news?.articles[index]['urlToImage'] == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          "assets/images/newspaper.png",
          height: num,
          width: num,
          fit: BoxFit.fill,
        ),
      );
    }
    else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          _news?.articles[index]['urlToImage'],
          height: num,
          width: num,
          fit: BoxFit.fitHeight,
        ),
      );
    }
  }

  String getDate() {
    DateTime now = DateTime.now();
    String date = "${now.day}.${now.month}.${now.year}";
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: OceanTheme.darkCyan,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: OceanTheme.darkCyan,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${getDate()} | India",
                  style: GoogleFonts.comfortaa(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "NewsWave",
              style: GoogleFonts.comfortaa(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: OceanTheme.black
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: _news?.articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(OceanTheme.richBlack),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    //side: BorderSide(color: Colors.red)
                                )
                            )
                          ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewsScreen(news: _news, index: index,)),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: OceanTheme.richBlack
                                ),
                                child: Center(
                                    child: Row(
                                      children: [
                                        getStateOfURL(index),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                            child: Text(
                                                _news?.articles[index]['title'] ?? "",
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  color: OceanTheme.timberwolf
                                                )
                                            )
                                        )
                                      ],
                                    )
                                )
                            )
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  );
                }
              )
            )
          ],
        ),
      )
    );
  }
}