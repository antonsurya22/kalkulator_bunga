import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator Bunga',
        theme: ThemeData(primarySwatch: Colors.pink, accentColor: Colors.pinkAccent),
      home: Form(),
    );
  }
}

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {

  TextEditingController principalTextEditingController = TextEditingController();
  TextEditingController rateofInterestTextEditingController = TextEditingController();
  TextEditingController termTextEditingController = TextEditingController();

  //Mata Uang
  var _mataUang = ['Rp.', "USD", 'Rm.', 'Ps.', 'Rs.'];

  String result= "";
  String _character = "";
  String nilaiMataUang = "";
  String nv = "";

  @override
  void initState(){
    nilaiMataUang = _mataUang[0];
  }

  void _setSelectedValue(String newValue){
    setState(() {
      this.nilaiMataUang = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
        padding: EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(Icons.star_border_outlined),
            color: Colors.white,
            onPressed: (){
             starDialogOpen(context);
            },
          ),
         ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Kalkulator Bunga', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline),
            color: Colors.white,
            onPressed: (){
              aboutDialogOpen(context);
            },
          ),
        ],
      ),

      body: Container(
        //color: Colors.red,
        margin: EdgeInsets.all(10),
        child: ListView(
          children:<Widget>[
              getImage(),

              Row(
              children: <Widget>[
                Expanded(child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: ListTile(
                    title: Text("Bunga Tunggal"),
                    leading: Radio(
                      value:"tunggal",
                      groupValue: _character,
                      onChanged: (String value)
                      {
                        setState(() {
                          //simple select
                          _character = value;
                        });
                      },
                    )),
                )),

                Expanded(child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: ListTile(
                      title: Text("Bunga Majemuk"),
                      leading: Radio(
                        value:"majemuk",
                        groupValue: _character,
                        onChanged: (String value)
                        {
                          setState(() {
                            //simple select
                            _character = value;
                          });
                        },
                      )),
                  )),

                Container(
                  width: 5.0,
                ),
              ],
            ),
            
              Padding(padding: EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(color: Colors.black87),
                  keyboardType: TextInputType.number,
                  controller: principalTextEditingController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black87),
                    labelText: "Pokok Pinjaman",
                    hintText: "Masukan Pokok yang dipinjam mis. 1000000",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.all(5),
                child: TextField(
                 style: TextStyle(color: Colors.black87),
                 keyboardType: TextInputType.number,
                 controller: rateofInterestTextEditingController,
                 decoration: InputDecoration(
                   labelStyle: TextStyle(color: Colors.black87),
                   labelText: "Rerata Bunga",
                   hintText: "Masukan Rerata Bunga per tahun",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(5),
                   ),
                 ),
               ),
              ),

            Row(
              children: <Widget>[
                Expanded(child: Padding(padding: EdgeInsets.all(5),
                  child: TextField(
                    style: TextStyle(color: Colors.black87),
                    keyboardType: TextInputType.number,
                    controller: termTextEditingController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black87),
                      labelText: "Jangka Waktu",
                      hintText: "Jangka Waktu Bunga",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                 ),
                ),

                Container(
                  width: 10,
                ),

                Expanded(
                    child: DropdownButton<String>(
                      items: _mataUang.map((String value){
                         return DropdownMenuItem<String>(
                           value: value,
                           child: Text(value),
                         );
                       }).toList(),
                      value: nilaiMataUang,
                      onChanged: (String newValue){
                        _setSelectedValue(newValue);
                        this.nv = newValue;
                        setState(() {
                          this.nilaiMataUang = newValue;
                        });
                      },
                    ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
                    child:  RaisedButton(
                      color: Colors.pink,
                      textColor: Colors.white,
                      child: Text(
                        'Hitung',
                        textScaleFactor: 1,
                      ),
                      onPressed: (){
                        this.result = _jumlahkanSemua(this.nv);
                        onDialogOpen(context, this.result);
                      },
                    ),
                ),

                Container(
                  width: 10,
                ),

                Expanded(
                  child:  RaisedButton(
                    color: Colors.pinkAccent,
                    textColor: Colors.white,
                    child: Text(
                      'Reset',
                      textScaleFactor: 1,
                    ),
                    onPressed: (){
                      _reset();
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      )
    );
  }

  String _jumlahkanSemua(String newValue)
  {
    String newResult;
    double pokok = double.parse(principalTextEditingController.text);
    double rata = double.parse(rateofInterestTextEditingController.text);
    double jangka_waktu = double.parse(termTextEditingController.text);

    rata /= 100;

    double uangBunga = 0;

    if(_character == "tunggal"){
       uangBunga = (pokok * rata * jangka_waktu) * 12;
    }else if(_character == "majemuk"){
       uangBunga = pokok * pow((1+(rata/100)), jangka_waktu);
    }

    if(jangka_waktu == 1){
      newResult = "Setelah $jangka_waktu tahun, Anda akan membayar =  $nilaiMataUang $uangBunga";
    }
    else{
      newResult = "Setelah $jangka_waktu tahun, Anda akan membayar total $nilaiMataUang $uangBunga";
    }
    return newResult;
  }


  void _reset()
  {
    principalTextEditingController.text = "";
    rateofInterestTextEditingController.text = "";
    termTextEditingController.text = "";
    result = "";
    nilaiMataUang = _mataUang[0];
  }

  void onDialogOpen(BuildContext context, String s)
  {
    Widget okButton = FlatButton(
        onPressed: () {},
        child: Text("Ok"),
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hitungan:"),
      content: Text(s),
      backgroundColor: Colors.pinkAccent,
      elevation: 8.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text(s),
          );
        });
  }

  void aboutDialogOpen(BuildContext context)
  {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Tentang"),
      content: Text("Created by 안토니 (Antonie Dev) 😎"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void starDialogOpen(BuildContext context)
  {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suka dengan Aplikasi ini?"),
      content: Text("Kirimkan kritik dan saran Anda ke surel " "anton.surya@undiksha.ac.id"
          "Terima Kasih ^^"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

Widget getImage() {
  AssetImage assetImage = AssetImage("assets/110602.png");
  Image image = Image(
    image: assetImage,
    width: 135,
    height: 135,
  );

  return Container(
    child: image,
    margin: EdgeInsets.all(10),
  );
}
