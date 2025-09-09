import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myapp/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/model/response/trip_idx_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx}); //ส่งค่าข้ามหหน้า

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late TripIdxGetResponse tripIdx;
  late Future<void>
  loadData; //late คือ ตอนนี้ยังไม่มีค่า จะไปกำหนดค่าตอน initstate

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData = loadDataAsync();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // Loding data with FutureBuilder
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Load Done
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tripIdx.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("ประเทศ ${tripIdx.country}"),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                10,
                                15,
                                10,
                                15,
                              ),
                              child: Column(
                                children: [
                                  Image.network(
                                    tripIdx.coverimage ??
                                        "https://cdn-icons-png.flaticon.com/128/3585/3585596.png/170x100",
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        "https://cdn-icons-png.flaticon.com/128/3585/3585596.png",
                                        width: 170,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ราคา ${tripIdx.price} บาท"),
                                  Text(tripIdx.destinationZone),
                                ],
                              ),
                            ),
                            Text(tripIdx.detail),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FilledButton(
                                    onPressed: () {},
                                    child: Text("จองเลย"),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    // log(res.body);
    tripIdx = tripIdxGetResponseFromJson(res.body);
  }
}
