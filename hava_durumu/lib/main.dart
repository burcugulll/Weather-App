import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main()  =>runApp(//başlar
  MaterialApp(//uygulamaın dış çerçevesi-görünür değil
    title:"Hava Durumu Uygulaması",
    home: Home(),//varsayılan yolunda gösterilecek widget alınır
  )
);

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
class _HomeState extends State<Home> {
  var temp;
  var description;//betimleme
  var currently;
  var humidity;//nem
  var windSpeed;//rüzgar hızı

  Future getWeather() async{//bir servise istek attığımızda cevap sonradan gelecek-işlem zaman alabilir
    //http.Response response = await http.get("http://api.openweathermap.org/data/2.5/weather?q=Konya&units=metric&appid=946748935ab6d4669c6dc1404f41dece");
    http.Response response =await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/weather?q=Konya&units=metric&appid=946748935ab6d4669c6dc1404f41dece"));//metot
    var results = jsonDecode(response.body);//çözümlendi
    setState(() {//state değişikliğinin ekrana yansıması için build fonk tetikledi
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];

    });
  }
  @override
  void initState(){//state değişkenlerini hazırlama
    super.initState();//üst sınıfın nesnesi çağırdık
    this.getWeather();//sınıftaki nesneye ulaşım
  }
  @override
  Widget build (buildContext) {//state değişkenleri ve bunları görselleştiren widget yapma
    return Scaffold(//sayfanın genel yapısını yönetir üstte appbar ort body alt navigation bar
      body: Column(
        children: <Widget>[
          Container(
            height:MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center ,//düşey
              crossAxisAlignment: CrossAxisAlignment.center,//yatay
              children: <Widget>[
                Padding(//uazklık ayarlaması
                  padding: EdgeInsets.only(bottom: 10.0),//tek bir kenara uygular
                  child: Text(
                    "Şu anda Konya",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 18.0,
                       fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                     currently != null ? currently.toString() : "Loading",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 14.0,
                       fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(//içerdekiler sıkıştırılarak küçültülür
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(//birden fazla widgettan oluşursa children alır
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometer),
                    title: Text("Sıcaklık"),
                    trailing: Text(temp != null ? temp.toString() + "\u00B0" :"Loading"),
                  ),
                  ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Hava"),
                  trailing: Text(description != null ? description.toString():"Loading"),
                  ),
                  ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text("Nem"),
                  trailing: Text(humidity != null ? humidity.toString():"Loading"),
                  ),
                  ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text("Rüzgar hızı"),
                  trailing: Text(windSpeed != null ? windSpeed.toString():"Loading"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
