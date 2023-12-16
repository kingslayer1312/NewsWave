import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newswave/presentation/news_screen.dart';
import 'package:newswave/services/news_service.dart';
import '../key/api_key.dart';
import '../model/news_model.dart';
import 'nord_palette.dart';

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
    double num = 50;
    if (_news?.articles[index]['urlToImage'] == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/images/newspaper.png", height: num, width: num,),
      );
    }
    else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(_news?.articles[index]['urlToImage'], height: num, width: num,),
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
        padding: const EdgeInsets.fromLTRB(20, 1.2 * kToolbarHeight, 20, 20),
        child: Container(
          child: Column(
            children: [
              Text(
                "NewsWave",
                style: GoogleFonts.comfortaa(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: NordPalette.nord0
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _news?.articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(NordPalette.nord0)
                            ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NewsScreen(news: _news, index: index,)),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: NordPalette.nord0
                                  ),
                                  child: Center(
                                      child: Row(
                                        children: [
                                          getStateOfURL(index),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                              child: Text(
                                                  _news?.articles[index]['title'] ?? "",
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    color: NordPalette.nord4
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
          )
        ),
      )
    );
  }
}