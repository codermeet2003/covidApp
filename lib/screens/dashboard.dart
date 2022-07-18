import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  var data_list1 = [];
  var data_list2 = [];
  var data_list3 = [];
  late String disease="";
  late String imageUrl="";
  int avgPulse = 0;
  int avgOxygen = 0;
  int avgTemp = 0;
  @override
  void initState() {
    super.initState();
    getSymptomData();
  }

  Future getSymptomData() async {
    http.Response response = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbw_t9gQZS_Es5jqPNLQhHKncBslT3lsHNyXBmnmlnxdWPFEWGYoMyuvj7QtavPPLCA_IQ/exec"));
    var result = jsonDecode(response.body);
    setState(() {
      for (var i in result) {
        data_list1.add(i['pulse']);
        data_list2.add(i['oxygen']);
        data_list3.add(i['temperature']);
      }
      num pulseTotal = 0;
      num oxygenTotal = 0;
      num tempTotal = 0;
      for (var item in data_list1) {
        pulseTotal += item;
      }
      for (var item in data_list2) {
        oxygenTotal += item;
      }
      for (var item in data_list3) {
        tempTotal += item;
      }
      avgPulse = (pulseTotal / data_list1.length).round();
      avgOxygen = (oxygenTotal / data_list2.length).round();
      avgTemp = (tempTotal / data_list3.length).round();
      finalDiseaseValue(avgPulse, avgOxygen, avgTemp);
      finalImageValue(avgPulse, avgOxygen, avgTemp);
    });
  }

  String finalDiseaseValue(int avgPulse, int avgOxygen, int avgTemp){
    if(avgPulse<100 && avgOxygen>95 && (avgTemp>=97 && avgTemp<=99)){
      disease = "You are perfectly healthy with no symptoms of any disease";
    }
    if(avgPulse>100 && avgOxygen>95 && (avgTemp>=97 && avgTemp<=99)){
      disease = "You are showing symptoms of Tachycardia (High Pulse)";
    }
    if(avgPulse<100 && avgOxygen>95 && avgTemp>99){
      disease = "You are showing symptoms of Fever (High Temperature)";
    }
    if(avgPulse<100 && avgOxygen<95 && (avgTemp>=97 && avgTemp<99)){
      disease = "You are showing symptoms of Acute Respiratory Distress Syndrome";
    }
    if(avgPulse<100 && avgOxygen<95 && avgTemp>99){
      disease = "You are showing symptoms of Covid-19";
    }
    return disease;
  }
  String finalImageValue(int avgPulse, int avgOxygen, int avgTemp){
    if(avgPulse<100 && avgOxygen>95 && (avgTemp>=97 && avgTemp<=99)){
      imageUrl = "assets/healthy.webp";
    }
    if(avgPulse>100 && avgOxygen>95 && (avgTemp>=97 && avgTemp<=99)){
      imageUrl = "assets/highPulse.webp";
    }
    if(avgPulse<100 && avgOxygen>95 && avgTemp>99){
      imageUrl = "assets/fever.webp";
    }
    if(avgPulse<100 && avgOxygen<95 && (avgTemp>=97 && avgTemp<99)){
      imageUrl = "assets/ARDS.png";
    }
    if(avgPulse<100 && avgOxygen<95 && avgTemp>99){
      imageUrl = "assets/covid.png";
    }
    return imageUrl;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfcfcfc),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: const <Widget>[Text("   Values", style: kTitleTextstyle)],),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 20,
                        color: kActiveShadowColor,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset("assets/oxygenMod.gif",
                          height: 80, width: 80),
                      Text("$avgOxygen %",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 20,
                        color: kActiveShadowColor,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset("assets/pulsingHeart.gif",
                          height: 60, width: 60),
                      Text("$avgPulse bpm",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  width: 340,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 20,
                        color: kActiveShadowColor,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset("assets/temperature.gif",
                          height: 60, width: 60),
                      Text("$avgTemp °F",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(children: const <Widget>[Text("   Status", style: kTitleTextstyle)],),

                PreventCard(
                     image: "$imageUrl",
                     text: "$disease",
                ),
                ElevatedButton.icon(
                  onPressed: () {
                  getSymptomData();
                  finalDiseaseValue(avgPulse, avgOxygen, avgTemp);
                  finalImageValue(avgPulse, avgOxygen, avgTemp);
                  },
                  style: ButtonStyle(
                      minimumSize:
                      MaterialStateProperty.all(const Size(170, 50)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.blue),
                      foregroundColor:
                      MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.white)))),
                  icon: const FaIcon(FontAwesomeIcons.stethoscope,
                      color: Colors.white),
                  label: const Text('Assess again', style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String text;
  const PreventCard({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        width: 340,
        child: Stack(
          alignment: const Alignment(-0.9, 0),
          children: <Widget>[
            Container(
              height: 116,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image, height: 100, width: 100),
            Positioned(
              left: 130,
              top: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: SvgPicture.asset("assets/icons/forward.svg", height: 50, width: 50),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

