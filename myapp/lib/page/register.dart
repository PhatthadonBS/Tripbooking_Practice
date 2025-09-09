import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myapp/config/internal.config.dart';
import 'package:myapp/model/request/customer_register_post_request.dart';
import 'package:myapp/model/response/customer_register_post_response.dart';
import 'package:myapp/page/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController img = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController pwd2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ลงทะเบียนสมาชิกใหม่")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("ชื่อ-นามสกุล"),
                          ),
                          TextFormField(
                            controller: fullname,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              return emtField(value, "กรุณากรอกชื่อของท่าน");
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("หมายเลขโทรศัพย์"),
                          ),
                          TextFormField(
                            controller: phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              return emtField(
                                value,
                                "กรุณากรอกหมายเลขโทรศัพย์ของท่าน",
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("อีเมล"),
                          ),
                          TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return emtField(value, "กรุณากรอกอีเมลของท่าน");
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("รหัสผ่าน"),
                          ),
                          TextFormField(
                            controller: pwd,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              return emtField(
                                value,
                                "กรุณากรอกรหัสผ่านของท่าน",
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("รหัสผ่านอีกครั้ง"),
                          ),
                          TextFormField(
                            controller: pwd2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              return passwordConfirm(value);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("รูป"),
                          ),
                          TextFormField(
                            controller: img,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              return emtField(value, "กรุณาใส่รูปของท่าน");
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              child: Column(
                                children: [
                                  FilledButton(
                                    onPressed: registerBtnClick,
                                    child: Text("สมัครสมาชิก"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      20,
                                      20,
                                      20,
                                      0,
                                    ),
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("หากมีบัญชีอยู่แล้ว?"),
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => LoginPage());
                                            },
                                            child: Text(
                                              "เข้าสู่ระบบ",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                  255,
                                                  6,
                                                  104,
                                                  232,
                                                ),
                                              ),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void backToLogin() {
    Navigator.pop(context);
  }

  String? emtField(String? str, String msg) {
    if (str == null || str.isEmpty) {
      return msg;
    }

    return null;
  }

  String? passwordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกรหัสผ่านอีกครั้ง";
    }
    if (pwd.text != value) {
      return "รหัสผ่านไม่ตรงกัน";
    }
    return null;
  }

  void registerBtnClick() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var data = CustomerRegisterPostRequest(
      fullname: fullname.text,
      phone: phone.text,
      email: email.text,
      password: pwd.text,
      image: img.text,
    );
    log("isrun");
    var res = http
        .post(
          Uri.parse("$API_ENDPOINT/customers"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostRequestToJson(data),
        )
        .then((value) {
          CustomerRegisterPostResponse customerRegisterPostResponse =
              customerRegisterPostResponseFromJson(value.body);
          log(customerRegisterPostResponse.message);
          if (value.statusCode == 200) {
            Get.defaultDialog(
              title: "สร้างบัญชีเสร็จสิ้น",
              middleText: "Yes Yes Ye6",
              textConfirm: "ตกลง",
              onConfirm: () {
                Get.back();
              },
            );
          }
        })
        .onError((error, stackTrace) {
          log(error.toString());
        });
  }
}
