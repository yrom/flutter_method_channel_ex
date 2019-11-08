import 'package:flutter/material.dart';
import 'package:method_channel_ex/method_channel_ex.dart';

void main() => runApp(MyApp());

var channel = StandardMethodChannel("test");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          builder: (context, snaphost) {
            if (snaphost.hasData) {
              var list = snaphost.data.entries.toList();
              return ListView.separated(
                itemBuilder: (context, index) {
                  var data = list[index];
                  return Text("${data.key}: ${data.value}");
                },
                itemCount: list.length,
                separatorBuilder: (_, __) => Divider(),
              );
            }
            return Center(child: Text('Loading...'));
          },
          future: _loadFatJson(),
        ));
  }

  Future<Map<String, dynamic>> _loadFatJson() {
    return channel.invokeMapMethod("getAFatJson");
  }
}
