import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/config/config.dart';
import 'package:myapp/config/internal.config.dart';
import 'package:myapp/model/response/trip_get_res.dart';
import 'package:myapp/page/profile.dart';
import 'package:myapp/page/trip.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  late Future<void> loadData;
  @override
  void initState() {
    super.initState();
    // Configuration.getConfig().then((config) {
    //   url = config['apiEndpoint'];
    //   getTrips();
    // });
    loadData = loadDataAsync();
  }

  List<TripGetResponse> tripGetResponses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายการ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, //ซ่อนicon ด้านหน้า เช่น ปุ่มกลับ
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "profile") {
                log(value);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == "logout") {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ปลายทาง",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilledButton(
                            onPressed: () => getTrips(),
                            child: Text("ทั้งหมด"),
                          ),
                          FilledButton(
                            onPressed: () => getAsia(),
                            child: Text("เอเชีย"),
                          ),
                          FilledButton(
                            onPressed: getEurope,
                            child: Text("ยุโรป"),
                          ),
                          FilledButton(
                            onPressed: getSoutheast_Asia,
                            child: Text("เอเชียตะวันออกเฉีย"),
                          ),
                          FilledButton(
                            onPressed: getThai,
                            child: Text("ประเทศไทย"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: ListView(
                  //     children: tripGetResponses
                  //         .map((trip) => Card(child: Text(trip.name)))
                  //         .toList(),
                  //   ),
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        child: Column(
                          children: tripGetResponses.map((trip) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 20,
                                        ),
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 130,
                                                height: 50,
                                                child: Text(
                                                  trip.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),

                                              Image.network(
                                                trip.coverimage ??
                                                    "https://cdn-icons-png.flaticon.com/128/3585/3585596.png/170x100",
                                                width: 170,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Image.network(
                                                        "https://cdn-icons-png.flaticon.com/128/3585/3585596.png",
                                                        width: 170,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 80,
                                          left: 20,
                                        ),
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("ประเทศ" + trip.country),
                                              Text(
                                                "ระยะเวลา " +
                                                    trip.duration.toString() +
                                                    " วัน",
                                              ),
                                              Text(
                                                "ราคา " + trip.price.toString(),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    gotoTrip(trip.idx),
                                                child: Text(
                                                  "รายละเอียดเพิ่มเติม",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getTrips() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));
    // log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    // log(tripGetResponses.length.toString());
  }

  getAsia() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips/des/1'));
    // log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  getEurope() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips/des/2'));
    // log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  getSoutheast_Asia() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips/des/3'));
    // log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  getThai() async {
    var res = await http.get(Uri.parse('$API_ENDPOINT/trips/des/9'));
    // log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$API_ENDPOINT/trips'));
    // log(res.body);
    tripGetResponses = tripGetResponseFromJson(res.body);
    // log(tripGetResponses.length.toString());
  }

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }
}
