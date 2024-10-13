import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage();

  @override
  _SplashPageState createState() => _SplashPageState();
}

final List<Widget> SliderItems = [
  Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Column(
          children: [
            Image.asset(
              "assets/img/hello_jalapeno.png",
              width: 200,
              height: 200,
            ),
            Text("Welcome to Hot Takes", style: TextStyle(fontSize: 20.0))
          ],
        )),
  ),
  Container(
      margin: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/img/jalapeno_idea.png",
            width: 200,
            height: 200,
          ),
          SizedBox(
            width: 300,
            child: Text(
              "The app where you can submit your hot takes",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      )),
  Container(
    margin: EdgeInsets.all(5.0),
    child: Column(
      children: <Widget>[
        Image.asset(
          "assets/img/jalapeno_voting.png",
          width: 200,
          height: 200,
        ),
        SizedBox(
          width: 300,
          child: Text(
            "And vote on others",
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
];

class _SplashPageState extends State<SplashPage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hot Takes"),
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Color.fromRGBO(175, 0, 123, 1),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                      viewportFraction: 1.5,
                      initialPage: 0,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: SliderItems.map((item) => item).toList(),
                )),
            DotsIndicator(
              dotsCount: SliderItems.length,
              position: _current.toDouble(),
              decorator: DotsDecorator(
                color: Colors.white,
                activeColor: Colors.grey.shade600,
                size: Size(12, 12),
                activeSize: Size(12, 12),
              ),
            ),
            ElevatedButton(
              onPressed: () => {context.go("/Login")},
              child: Text("Login"),
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
                  backgroundColor: WidgetStateProperty.all<Color>(
                      ThemeData.dark().canvasColor),
                  side: WidgetStateProperty.all(BorderSide(
                      color: Colors.white,
                      width: 1.0,
                      style: BorderStyle.solid))),
            )
          ],
        ));
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      User _user = Supabase.instance.client.auth.currentUser!;
      String profileName =
          _user.identities?.elementAt(0).identityData!["full_name"];
      await Supabase.instance.client.rpc('insert_user_if_not_exists', params: {
        'client_user_id': _user.id,
        'client_user_name': profileName
      });
      context.go("/Explore");
    }
  }
}
