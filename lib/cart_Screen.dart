import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/promotion_model.dart';
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin{
  List<Promotion> promotions = [
    new Promotion("18-day Vegetarian Meal Plan",
        "+2 Bonus meals and my favorite desert",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "wendy_123",
        "East-West University",
        "This vegetarian meal plan is filled with easy to make recipies even your non-veg friends will love. Simple, inexpensive ingredients and easy preperation"+        "This vegetarian meal plan is filled with easy to make recipies even your non-veg friends will love. Simple, inexpensive ingredients and easy preperation",
        4.3,
        12,
        4.99),
    new Promotion("18-day Vegetarian Meal Plan",
        "+2 Bonus meals and my favorite desert",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "wendy_123",
        "East-West University",
        "This vegetarian meal plan is filled with easy to make recipies even your non-veg friends will love. Simple, inexpensive ingredients and easy preperation",
        4.3,
        12,
        4.99),
    new Promotion("18-day Vegetarian Meal Plan",
        "+2 Bonus meals and my favorite desert",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "wendy_123",
        "East-West University",
        "This vegetarian meal plan is filled with easy to make recipies even your non-veg friends will love. Simple, inexpensive ingredients and easy preperation",
        4.3,
        12,
        4.99),
    new Promotion("18-day Vegetarian Meal Plan",
        "+2 Bonus meals and my favorite desert",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "lib/images/Disinfect_35ct_All-Purpose_Lifestyle-2-768x769.jpg",
        "wendy_123",
        "East-West University",
        "This vegetarian meal plan is filled with easy to make recipies even your non-veg friends will love. Simple, inexpensive ingredients and easy preperation",
        4.3,
        12,
        4.99),
  ];
  TabController _tabController;
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .accentColor,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .accentColor,
        titleSpacing: 0,
        leading: Transform.translate(
          offset: Offset(7.5, 0),
          child: IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.black,),
            onPressed: (){},
          ),
        ),
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black54,
          unselectedLabelColor: Colors.black54,
          labelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              child: Text("All",
                style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width / 30),
              ),
            ),
            Tab(
              child: Text("Meal Plans",
                style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width / 32),
              ),
            ),
            Tab(
              child: Text("Workouts",
                style: GoogleFonts.montserrat(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width / 32),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.sort, color: Colors.black,),
              onPressed: (){},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _list(),
          _list(),
          _list(),
        ],
      ),
    );
  }

  Widget _list(){
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: promotions.length,
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left:20,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(promotions[index].title,
                            style: GoogleFonts.montserrat(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MediaQuery.of(context).size.width / 30),
                          ),
                          Text(promotions[index].titleDescription,
                            style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MediaQuery.of(context).size.width / 35),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0, bottom: 10),
                        child: Image.asset(promotions[index].cornerImage, height: 40, width: 80, fit: BoxFit.fill,),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20,),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),

                        child: Image.asset(
                          promotions[index].mainImage, height: 100, width: 135, fit: BoxFit.fill,)
                    ),
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(promotions[index].userImage),
                              radius: 13,
                            ),
                            SizedBox(width: 10,),
                            Text(promotions[index].username,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 50),
                            ),
                            SizedBox(width: 15,),
                            Text(promotions[index].userCollege,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                  MediaQuery.of(context).size.width / 50),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          child: Text(promotions[index].description,
                            style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize:
                                MediaQuery.of(context).size.width / 50),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          width: MediaQuery.of(context).size.width/1.8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 15,),
                                RatingBarIndicator(
                                  rating: 2.75,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 17.0,
                                  unratedColor: Colors.black12,
                                  direction: Axis.horizontal,
                                ),
                                Row(
                                  children: [
                                    Text(promotions[index].stars.toString()+" /5",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                          MediaQuery.of(context).size.width / 50),
                                    ),
                                    SizedBox(width: 15,),
                                    Text(promotions[index].reviews.toString() + " reviews",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                          MediaQuery.of(context).size.width / 50),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/6.5,),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                  color: Colors.pink),
                              child: Text('\$'+promotions[index].price.toString(),
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                    MediaQuery.of(context).size.width / 30),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Divider(thickness: 1,),
              ],
            );
          }
      ),
    );
  }
}
