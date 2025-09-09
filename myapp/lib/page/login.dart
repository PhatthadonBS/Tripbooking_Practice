import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myapp/config/internal.config.dart';
import 'package:myapp/model/request/customer_login_post_request.dart';
import 'package:myapp/model/request/customer_register_post_request.dart';
import 'package:myapp/model/response/customer_login_post_response.dart';
import 'package:myapp/page/register.dart';
import 'package:myapp/page/showtrip.dart';
import 'package:myapp/config/config.dart';
import 'package:myapp/config/internal.config.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // del const for tell t his class not static class
  String url = '';
  String text = "";
  int count = 0;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  late CustomerLoginPostResponse customerLoginPostResponse;
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: SizedBox(
        // Query media info of current page (context)
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: InkWell(
                    onDoubleTap: login,
                    child: Image.asset("assets/images/3.jpg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "หมายเลขโทรศัพท์",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextField(
                                  // onChanged: (value) => log(value), get input from textfield
                                  controller: phone,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "รหัสผ่าน",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextField(
                                  controller: password,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: register,
                            child: Text(
                              "ลงทะเบียนใหม่",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          FilledButton(
                            onPressed: login,
                            child: Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    // var data = {
    //   "phone": "0817399999",
    //   "password": "1111",
    // }; //map for send data before use model
    if ((phone.text.trim().isEmpty) || (password.text.trim().isEmpty)) {
      Get.defaultDialog(
        title: "กรุณากรอกข้อมูล",
        content: SizedBox.shrink(), // ไม่แสดงอะไรตรงกลาง
        textCancel: "ตกลง",
      );
      return;
    }

    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phone.text,
      password: password.text,
    );

    await http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          customerLoginPostResponse = customerLoginPostResponseFromJson(
            value.body,
          ); //conv json to map
          log(customerLoginPostResponse.customer.fullname);
        })
        .onError((error, stackTrace) {
          log(error.toString());
        });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ShowTripPage(cid: customerLoginPostResponse.customer.idx),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}
