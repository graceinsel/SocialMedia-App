import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/auth/login/login.dart';
import 'package:google_fonts/google_fonts.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> welcomeText = [
    "Receive the Latest Art World Insights from Fellow Artists, Curators and Collectors",
    "Inspired by the world’s top artists",
    "Nurture your professional relationships",
    "Find the right opportunity for you",
    "Maintaining Your Professional Portfolio"
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 15),
            // Some space at the top for the ARTLAS text
            Padding(
              padding: const EdgeInsets.only(top: 27.0),
              child: Text(
                'ARTLAS',
                style: GoogleFonts.crimsonText(
                  fontWeight: FontWeight.w400,
                  fontSize: 32.0,
                ),
              ),
            ),
            Expanded(
              // PageView occupies most of the screen
              child: PageView.builder(
                controller: _pageController,
                itemCount: welcomeText.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(welcomeText[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoSerif(
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey,
                              fontSize: 14.0,
                            )),
                        SizedBox(height: 20.0), // Space between text and PageView
                        // Add your image here
                        Flexible(
                          child: Image.asset(
                            'assets/images/welcome$index.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                  ],
                    ),
                  );
                },
              ),
            ),
            // Dots indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(welcomeText.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 10.0,
                  width: _currentPage == index ? 30.0 : 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey,
                  ),
                );
              }),
            ),
            SizedBox(height: 30.0), // Space between dots and Get Started button
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (_) => Login(),
                    ),
                  );
                },
                child: Container(
                  height: 62.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    // border: Border.all(color: Colors.grey),
                    color: Theme.of(context).colorScheme.secondary,
                    // gradient: LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomLeft,
                    //   colors: [
                    //     Theme.of(context).colorScheme.secondary,
                    //     Colors.lightBlue,
                    //     // Color(0xff597FDB),
                    //   ],
                    // ),
                  ),
                  child: Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
