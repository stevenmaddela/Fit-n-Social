import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fitnsocial/calendar_Screen.dart';
import 'package:flutter_app_fitnsocial/cart_Screen.dart';
import 'package:flutter_app_fitnsocial/models/member_model.dart';
import 'package:flutter_app_fitnsocial/swipe_Screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'drawer_screen.dart';
import 'home_Screen.dart';
import 'inbox_screen.dart';
import 'login_screen.dart';
import 'package:flutter_app_fitnsocial/inbox_screen.dart' as inbox;

import 'onBoarding_screen.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  // RenderErrorBox.backgroundColor = Colors.transparent;
  // RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String i = prefs.getString('color');
  runApp(MyApp(i));

}

class MyApp extends StatelessWidget {
  String i = "#001100";
  MyApp(this.i);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
     return FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                );
              }
              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                initializeDateFormatting('pt_BR', null);
                return MaterialApp(
                  title: 'Fitn',
                  debugShowCheckedModeBanner: false,
                  home: LoggedInScreen(),
                  theme: ThemeData(
                    primaryColor: i!=null? HexColor(i) : HexColor("#000000"),
                    accentColor: Color(0xFFF3F5F7),
                  ),
                );
              }
              return Container();
              // Otherwise, show something whilst waiting for initialization to complete
              //return Loading();
            },
          );
  }

}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class LoggedInScreen extends StatefulWidget {

  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen>
    with TickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  TabController tabController;
  TabBarView tabBarView;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  bool terms;
  int _currentTab = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SwipeScreen(),
    CalendarScreen(),
    CartScreen(),
  ];
  final DatabaseReference rootRef = FirebaseDatabase.instance.reference();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String _homeScreenText = "waiting for token...";
  String _messageText = "Waiting for Message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      googleSignIn.disconnect();
      if (event == null) {
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (_) => OnboardingScreen()), (
            Route<dynamic> rr) => false);
      }
    });
    //popup();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messageomg message $message";
        });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messageomg message $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messageomg message $message";
        });
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      rootRef
          .child("Users")
          .child(auth.currentUser.uid)
          .child('token')
          .set(token);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DrawerScreen(),
        _animatedController(),
      ],
    );
  }

  Widget _animatedController() {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor),
      duration: Duration(milliseconds: 250),
      child: ClipRRect(
        borderRadius: isDrawerOpen
            ? BorderRadius.only(
                topLeft: Radius.circular(60), bottomLeft: Radius.circular(60))
            : BorderRadius.only(),
        child: GestureDetector(
          child: Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            appBar: AppBar(
              leading: isDrawerOpen
                  ? Shimmer.fromColors(
                      highlightColor: Colors.redAccent,
                      baseColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            xOffset = 0;
                            yOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          });
                        },
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.menu),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          xOffset =
                              (MediaQuery.of(context).size.width / 4) + 150;
                          yOffset = MediaQuery.of(context).size.height / 4.5;
                          scaleFactor = .6;
                          isDrawerOpen = true;
                        });
                      },
                    ),
              centerTitle: true,
             // title: Image.asset("lib/images/site.png",height: 90,width: 90,),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.chat),
                  iconSize: 30.0,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => InboxScreen()));
                  },
                ),
              ],
            ),
            body: _widgetOptions.elementAt(_currentTab),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentTab,
              onTap: (int value) {
                setState(() {
                  _currentTab = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.trending_up,
                    size: 30,
                  ),
                  title: SizedBox.shrink(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.swap_horiz_rounded,
                    size: 30,
                  ),
                  title: SizedBox.shrink(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.event,
                    size: 30,
                  ),
                  title: SizedBox.shrink(),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(
                //     Icons.shopping_cart,
                //     size: 30,
                //   ),
                //   title: SizedBox.shrink(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedy Terms & Conditions'),
          content: SingleChildScrollView(
            child: Text(
                "Welcome to Feedy. We (Syfn, Inc.) hope you find it useful. By accessing or otherwise interacting with our servers, services, mobile app ("
                'App"), or any associated content/postings, you agree to these Terms of Use ("TOU") (last updated August 13, 2020). You acknowledge and agree Feedy is a private app owned and operated by Syfn, Inc. If you are accessing or using Feedy on behalf of a business, you represent and warrant to Feedy that you have authority to accept the TOU on behalf of that business and that that business agrees to the TOU. If you do not agree to the TOU, you are not authorized to use Feedy or download the App. We may modify the TOU at any time in our sole discretion. You are responsible for periodically checking for changes and are bound by them if you continue to use Feedy. LICENSE. If you agree to the TOU and (1) are of sufficient age and capacity to use Feedy and be bound by the TOU, or (2) use Feedy on behalf of a business, thereby binding that business to the TOU, we grant you a limited, revocable, non-exclusive, non-assignable license to use Feedy in compliance with the TOU; unlicensed use is unauthorized. You agree not to display, "frame," make derivative works, distribute, license, or sell, content from Feedy, excluding postings you create. You grant us a perpetual, irrevocable, unlimited, worldwide, fully paid/sublicensable license to use, copy, display, distribute, and make derivative works from content you post. USE. Unless licensed by us in a separate written or electronic agreement, you agree not to use or provide software (except our App and email clients) or services that interact or interoperate with Feedy, e.g. for downloading, uploading, creating/accessing/using an account, posting, flagging, emailing, searching, or mobile use. You agree not to copy/collect Feedy content via robots, spiders, scripts, scrapers, crawlers, or any automated or manual equivalent (e.g., by hand). Misleading, unsolicited, and/or unlawful postings/communications/accounts are prohibited, as is buying or selling accounts. You agree not to post content that is prohibited by any of Feedy\'s policies or rules referenced above ("Prohibited Content"). You agree not to collect Feedy user information or interfere with Feedy. You agree we may moderate Feedy access/use in our sole discretion, e.g., by blocking, filtering, re-categorizing, re-ranking, deleting, delaying, holding, omitting, verifying, or terminating your access/license/account. You agree (1) not to bypass said moderation, (2) we are not liable for moderating or not moderating, and (3) nothing we say or do waives our right to moderate, or not. Unless licensed by us in a separate written or electronic agreement, you agree not to (i) rent, lease, sell, publish, distribute, license, sublicense, assign, transfer, or otherwise make available Feedy or our application programming interface ("API"), (ii) copy, adapt, create derivative works of, decompile, reverse engineer, translate, localize, port or modify the App, the API, any website code, or any software used to provide Feedy, (iii) combine or integrate Feedy or the API with any software, technology, services, or materials not authorized by us, (iv) circumvent any functionality that controls access to or otherwise protects Feedy or the API, or (v) remove or alter any copyright, trademark or other proprietary rights notices. You agree not to use Feedy or the API in any manner or for any purpose that infringes, misappropriates, or otherwise violates any intellectual property right or other right of any person, or that violates any applicable law. LIQUIDATED DAMAGES. You further agree that if you violate the TOU, or you encourage, support, benefit from, or induce others to do so, you will be jointly and severally liable to us for liquidated damages as follows for: (A) collecting/harvesting Feedy users\' information, including personal or identifying information - \$1 per violation; (B) publishing/misusing personal or identifying information of a third party in connection with your use of Feedy without that party\'s express written consent - \$1,000 per violation; (C) misrepresenting your identity or affiliation to anyone in connection with your use of Feedy - \$1,000 per violation; (D) posting or attempting to post Prohibited Content - \$4 per violation; (E) posting or attempting to post Prohibited Content in any paid section of Feedy - the price per post applicable to that section of Feedy; (F) sending an unauthorized/unsolicited email to an email address obtained from Feedy - \$25 per violation; (G) using Feedy user information to make/send an unauthorized/unsolicited text message, call, or communication to a Feedy user - \$500 per text/call/communication; (H) creating a misleading or unlawful Feedy account or buying/selling a Feedy account - \$4 per violation; (I) abusing or attempting to abuse Feedy\'s flagging or reporting processes - \$1 per violation; (J) distributing any software to facilitate violations of the USE Section - \$1,000 per violation; (K) aggregating, displaying, framing, copying, duplicating, reproducing, making derivative works from, distributing, licensing, selling, or exploiting Feedy content for any purpose without our express written consent - \$3,000 for each day you engage in such violations; (L) requesting, viewing, or accessing more than 1,000 pages of Feedy in any 24-hour period - \$0.25 per page during the 24 hour period after the first 1,000 pages; (M) bypassing or attempting to bypass our moderation efforts - \$4 per violation. You agree that these amounts are (1) a reasonable estimate of our damages (as actual damages are often difficult to calculate), (2) not a penalty, and (3) not otherwise limiting on our ability to recover under any legal theory or claim, including statutory damages and other equitable relief (e.g., for spam, we can elect between the above liquidated damages or statutory damages under the anti-spam statute). You further agree that repeated violations of the USE section will irreparably harm and entitle us to injunctive or equitable relief, in addition to monetary damages. FEES. When you make posting you awknowledge that it is a donation and no money will be exchanged for goods. We may refuse any posting. DISCLAIMER &amp; LIABILITY. To the full extent permitted by law, Feedy, Inc., and its officers, directors, employees, agents, licensors, affiliates, and successors in interest ("Feedy Entities") (1) make no promises, warranties, or representations as to Feedy, including its completeness, accuracy, availability, timeliness, propriety, security or reliability; (2) provide Feedy on an "AS IS" and "AS AVAILABLE" basis and any risk of using Feedy is assumed by you; (3) disclaim all warranties, express or implied, including as to accuracy, merchantability, fitness for a particular purpose, and non-infringement, and all warranties arising from course of dealing, usage, or trade practice; and (4) disclaim any liability or responsibility for acts, omissions, or conduct of you or any party in connection with Feedy. Feedy Entities are NOT liable for any direct, indirect, consequential, incidental, special, punitive, or other losses, including lost profits, revenues, data, goodwill, etc., arising from or related to Feedy. Some jurisdictions restrict or alter these disclaimers and limits, so some may not apply to you."'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("terms", true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> popup() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      terms = prefs.getBool("terms");
    });
    if (terms != true) {
      _showMyDialog();
    }
  }

}
