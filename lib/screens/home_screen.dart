import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_favorite_model.dart';
import 'package:webtoon/services/api_services.dart';
import 'package:webtoon/models/webtoon_days_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:webtoon/widget/daily_webtoon_widget.dart';

const List<Widget> selectDays = <Widget>[
  Text('월'),
  Text('화'),
  Text('수'),
  Text('목'),
  Text('금'),
  Text('토'),
  Text('일'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  late Future<List<WebtoonDayModel>> daywebtoons;
  late Future<List<WebtoonFavoriteModel>> favoriteWebtoons;
  late List<dynamic> favoriteWebtoonsArray = [];
  int favoriteToonLength = 0;
  final _selectedDays = List<bool>.filled(7, false);
  final List<String> selectDay = <String>[
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];

  final urlImages = [
    'https://shared-comic.pstatic.net/thumb/webtoon/712362/thumbnail/thumbnail_IMAG06_05bdce8c-61e1-4446-9052-5cf216b76670.jpg',
    'https://shared-comic.pstatic.net/thumb/webtoon/800770/thumbnail/thumbnail_IMAG21_d2e1e7ee-fc83-4030-a1e7-200378bc088f.jpg',
    'https://shared-comic.pstatic.net/thumb/webtoon/792125/thumbnail/thumbnail_IMAG21_74ba68fa-63d8-41d1-9db2-09f6235dbd2d.jpg',
  ];

  bool vertical = false;
  String formatDate = DateFormat('E').format(DateTime.now()).toLowerCase();

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons != null) {
      setState(() {
        favoriteToon(likedToons);
      });
    } else {
      prefs.setStringList('likedToons', []);
    }
    //오늘 날짜 선택
    _selectedDays[selectDay.indexOf(formatDate)] = true;
  }

  void favoriteToon(List<String> likedToons) {
    favoriteToonLength = likedToons.length;
    setState(() {
      favoriteWebtoons = ApiService.getFavoriteToonById(likedToons);
    });
  }

  void selectedDay(int index) {
    setState(() {
      daywebtoons = ApiService.getDaysToon(selectDay[index]);

      for (var i = 0; i <= _selectedDays.length - 1; i++) {
        _selectedDays[i] = false;
      }
      _selectedDays[index] = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    selectedDay(selectDay
        .indexOf(DateFormat('E').format(DateTime.now()).toLowerCase()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          title: const Text(
            "KeyBase Toons",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // Container(
            //   child: favoriteToonBanner(),
            // ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: daySelected(),
            ),
            Expanded(
              child: webtoonList(),
            ),
          ],
        ));
  }

  // FutureBuilder<List<WebtoonFavoriteModel>> favoriteToonBanner() {
  //   return FutureBuilder(
  //     future: favoriteWebtoons,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.hasData) {
  //           return Column(
  //             children: [Expanded(child: favoriteToonList(snapshot))],
  //           );
  //         } else {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       } else {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }

  FutureBuilder<List<WebtoonDayModel>> webtoonList() {
    return FutureBuilder(
      future: daywebtoons,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              children: [Expanded(child: makeList(snapshot))],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // ListView favoriteToonList(
  //     AsyncSnapshot<List<WebtoonFavoriteModel>> snapshot) {
  //   return ListView.separated(
  //     shrinkWrap: true,
  //     physics: const BouncingScrollPhysics(),
  //     scrollDirection: Axis.vertical,
  //     itemCount: snapshot.data!.length,
  //     padding: const EdgeInsets.symmetric(
  //       vertical: 20,
  //       horizontal: 20,
  //     ),
  //     itemBuilder: (context, index) {
  //       var webtoon = snapshot.data![index];
  //       return FavoriteWebtoon(
  //         title: webtoon.title,
  //         thumb: webtoon.thumb,
  //         id: webtoon.id,
  //       );
  //     },
  //     separatorBuilder: (context, index) => const SizedBox(
  //       width: 30,
  //     ),
  //   );
  // }

  GridView makeList(AsyncSnapshot<List<WebtoonDayModel>> snapshot) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1 / 1.6,
        crossAxisSpacing: 10, //수직 Padding
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return WebtoonDaily(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
    );
  }

  ToggleButtons daySelected() {
    return ToggleButtons(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      onPressed: (int index) {
        selectedDay(index);
      },
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.green[900],
      selectedColor: Colors.white,
      fillColor: Colors.green[900],
      color: Colors.green[900],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 50.0,
      ),
      isSelected: _selectedDays,
      children: selectDays,
    );
  }

  // FutureBuilder<List<WebtoonFavoriteModel>> favoriteToonList(
  //     AsyncSnapshot<List<WebtoonFavoriteModel>> snapshot) {
  //   return FutureBuilder(
  //     future: favoriteWebtoons,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.hasData) {
  //           return Row(
  //             children: [
  //               Container(
  //                 child: CarouselSlider.builder(
  //                   itemCount: favoriteToonLength,
  //                   options: CarouselOptions(
  //                     height: 200,
  //                     viewportFraction: 1,
  //                     autoPlay: true,
  //                     enlargeCenterPage: true,
  //                     autoPlayInterval: const Duration(
  //                       seconds: 2,
  //                     ),
  //                   ),
  //                   itemBuilder: (context, index, realIndex) {
  //                     print(snapshot);
  //                     return Container(
  //                       margin: const EdgeInsets.symmetric(horizontal: 50),
  //                       color: Colors.grey,

  //                       // child: Image.network(
  //                       //   // urlImage,
  //                       //   // headers: const {
  //                       //   //   "User-Agent":
  //                       //   //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
  //                       //   // },
  //                       //   // fit: BoxFit.cover,
  //                       // ),
  //                     );
  //                   },
  //                 ),
  //               )
  //             ],
  //           );
  //         } else {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       } else {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }
}
