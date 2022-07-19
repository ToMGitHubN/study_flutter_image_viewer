import 'dart:ffi';
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mime/mime.dart';// ファイル拡張子
import 'package:path/path.dart';// ファイルパスライブラリ
import 'package:path_provider/path_provider.dart';// 特殊フォルダのパス

void main() {
  runApp(const MyApp());

  // フォルダの中身を表示する
  // Get the system temp directory.
  /*var systemTempDir = Directory.current;
  // List directory contents, recursing into sub-directories,
  // but not following symbolic links.
  systemTempDir
      .list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) {
    print(entity.path);
  });*/
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const ListViewImages(title: 'Flutter Demo Home Page'),
    );
  }
}

// 画像をメインサイズで大きく表示する
class ViewImages extends StatefulWidget {
  const ViewImages({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ViewImages> createState() => _ViewImages();
}

class _ViewImages extends State<ViewImages> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// 画像・ファルダをリストで一覧表示
class ListViewImages extends StatefulWidget {
  const ListViewImages({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ListViewImages> createState() => _ListViewImages();
}

class _ListViewImages extends State<ListViewImages> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    // 非同期系処理 => FutureBuilderに渡す
    final Future<List<String>> _wait_func = Future<List<String>>.delayed(
      const Duration(seconds: 2),
      () async{
        var application_documents_directory_path = await FileUtiles.getApplicationDocumentsDirectoryPath();
        var cl_file_list = FileList(application_documents_directory_path);

        return cl_file_list.getFileList();
      },
    );

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
              title: const Text('ImageViewer ListView - ファイル一覧を表示'),
              centerTitle: true,
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            elevation: 2.0,
          ),
          body: FutureBuilder<List<String>>(
            future: _wait_func,
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                final List<String> fileList = snapshot.data ?? [];
                
                return ListView.builder(
                    itemCount: fileList.length,
                    itemBuilder: (BuildContext context, int index) {
                    return _messageItem(fileList[index]); 
                  },
                );

              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');

              } else {
                return Text('Loading...');
              }

            },
          )
      )
    );
  }

  Widget _messageItem(String filePath) {

    Image leading_image;
    if(FileUtiles.isImage(filePath) == true) {
      leading_image = Image.file(File(filePath));
    } else {
      leading_image = Image.asset('assets/images/no-image-icon.jpg');// 「イメージなし」のアイコン
    }

    String file_name = basename(filePath);

    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        leading: leading_image,
        title: Text(
          file_name,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        onTap: () {
          print("onTap called.");
        }, // タップ
        onLongPress: () {
          print("onLongTap called.");
        }, // 長押し
      ),
    );
  }
}


/// 指定フォルダの内容を指定のフィルターをして返す
class FileList {
  List<FileSystemEntity> dirFileLists = [];/// 対象のフォルダ/ファイル一覧

  FileList(String path) {
    
    Directory dir = Directory(path);
    dirFileLists = dir.listSync();
  }

  /// ファイル一覧を取得する
  List<String> getFileList(){
    List<String> fileList = [];
    List<FileSystemEntity> list = dirFileLists;
    for (FileSystemEntity entity in list) {
      if (entity is File) {
        fileList.add(entity.path);
      }
    }
    return fileList;
  }
}

/// ファイル系 便利機能
class FileUtiles {

  /// イメージファイルか判定する
  static bool isImage(String path) {
    final mimeType = lookupMimeType(path);
    if(mimeType == null) return false;

    return mimeType.startsWith('image/');
  }

  static Future<String> getApplicationDocumentsDirectoryPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
