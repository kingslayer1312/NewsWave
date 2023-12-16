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
      backgroundColor: OceanTheme.darkCyan,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "NewsWave",
                    style: GoogleFonts.comfortaa(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: OceanTheme.black
                    ),
                  ),

                ],
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
                                      //borderRadius: BorderRadius.circular(30),
                                      color: OceanTheme.richBlack
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
          )
        ),
      )
    );
  }
}