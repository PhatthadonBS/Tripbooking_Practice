import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/config/config.dart';
import 'package:myapp/model/response/customer_login_post_response.dart';
import 'package:myapp/model/response/customer_profile_respone.dart';
import 'package:myapp/page/login.dart';

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  String url = '';
  late CustomerProfileRespones customer;
  late Future<void> loadData;
  final TextEditingController _controller1 = TextEditingController(text: "");
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton(
            onSelected: (value) => {
              // delete
              Get.defaultDialog(
                title: "ยืนยันการลบข้อมูล?",
                middleText: "",
                textConfirm: "ยืนยัน",
                textCancel: "ยกเลิก",
                onConfirm: () {
                  delete();
                  Get.defaultDialog(
                    title: "ลบข้อมูลเสร็จสิ้น",
                    middleText: "",
                    barrierDismissible: false, // กดข้างนอกไม่ให้ปิดเอง
                  );
                  Future.delayed(Duration(seconds: 2), () {
                    Get.back(); // ปิด dialog
                    Get.offAll(() => LoginPage());
                  });
                },
                onCancel: () {},
              ),
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("ยกเลิกสมาชิก"), value: 'delete'),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Load Done
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      child: Image.network(
                        customer.image ??
                            "https://cdn-icons-png.flaticon.com/128/3585/3585596.png/170x100",
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            "https://cdn-icons-png.flaticon.com/128/3585/3585596.png",
                            width: 170,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ชื่อ-นามกุล"),
                                TextFormField(controller: nameCtl),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("หมายเลขโทรศัพย์"),
                                TextFormField(controller: phoneCtl),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("อีเมล"),
                                TextFormField(controller: emailCtl),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("รูปภาพ"),
                                TextFormField(controller: imageCtl),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: update,
                      child: Text("บันทึกข้อมูล"),
                    ),
                  ],
                ),
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
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customer = customerProfileResponesFromJson(res.body);
    log(jsonEncode(customer));
    nameCtl.text = customer.fullname;
    phoneCtl.text = customer.phone;
    emailCtl.text = customer.email;
    imageCtl.text = customer.image;
  }

  void update() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var json = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
    };
    // Not using the model, use jsonEncode() and jsonDecode()
    try {
      var res = await http.put(
        Uri.parse('$url/customers/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(json),
      );
      log(res.body);
      var result = jsonDecode(res.body);
      // Need to know json's property by reading from API Tester
      log(result['message']);
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + err.toString()),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สำเร็จ'),
        content: const Text('บันทึกข้อมูลเรียบร้อย'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));
    log(res.statusCode.toString());
  }
}
