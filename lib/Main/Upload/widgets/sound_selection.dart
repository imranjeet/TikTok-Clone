import 'dart:io';
import 'dart:math';

import 'package:agni_app/Main/Upload/widgets/sound_audio_player.dart';
import 'package:agni_app/providers/sounds.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:simple_permissions/simple_permissions.dart';

var dio = Dio();

class SelectionSound extends StatefulWidget {
  @override
  _SelectionSoundState createState() => _SelectionSoundState();
}

class _SelectionSoundState extends State<SelectionSound> {
  bool downloading = false;
  var progress = "";
  var path;
  String savePath;
  var platformVersion = "Unknown";
  // Permission permission1 = Permission.WriteExternalStorage;
  static final Random random = Random();
  Directory externalDir;

  Future<void> downloadFile(String soundUrl, String soundName) async {
    Dio dio = Dio();
    bool checkPermission1 = true;
    //     await SimplePermissions.checkPermission(permission1);
    // print(checkPermission1);
    // if (checkPermission1 == false) {
    //   await SimplePermissions.requestPermission(permission1);
    //   checkPermission1 = await SimplePermissions.checkPermission(permission1);
    // }
    if (checkPermission1 == true) {
      String dirloc = "";
      dirloc = (await getApplicationDocumentsDirectory()).path;
      // if (Platform.isAndroid) {
      //   dirloc = "/sdcard/download/";
      // } else {
      //   dirloc = (await getApplicationDocumentsDirectory()).path;
      // }

      var randid = random.nextInt(10000);

      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(soundUrl, dirloc + randid.toString() + ".mp3",
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress =
                ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        progress = "Download Completed.";
        path = dirloc + randid.toString() + ".mp3";
        downloading = false;
      });
      path = dirloc + randid.toString() + ".mp3";
      if (path != null) {
        // var data = [path, soundId];
        final data = {"path": path, "soundName": soundName};
        Navigator.of(context).pop(data);
        // Navigator.pop(
        //   context,
        //   data,
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var soundItems = Provider.of<Sounds>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: Text(
          "Sounds",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: downloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: soundItems.items.length,
              itemBuilder: (context, i) {
                return Container(
                  child: Column(
                    children: [
                      Divider(),
                      ListTile(
                        leading: SoundAudioPlayer(
                            soundItem: soundItems.items[i].soundUrl),
                        title: Text(
                          soundItems.items[i].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          soundItems.items[i].description,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Container(
                          height: 40,
                          child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: Colors.purpleAccent,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                downloadFile(soundItems.items[i].soundUrl,
                                    soundItems.items[i].name);

                                setState(() {
                                  downloading = true;
                                });
                              }),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Future download2(
  //   Dio dio,
  //   String url,
  // ) async {
  //   try {
  //     Response response = await dio.download(
  //       url,
  //       savePath,
  //       // onReceiveProgress: showDownloadProgress,
  //       //Received data with List<int>
  //       // options: Options(
  //       //     responseType: ResponseType.bytes,
  //       //     followRedirects: false,
  //       //     validateStatus: (status) {
  //       //       return status < 500;
  //       //     }),
  //     );
  //     print(response.headers);
  //     File sundfile = File(savePath);
  //     print("Ranjeet sund file yhhaa par hai: $sundfile");
  //     setState(() {
  //       sundfile = _soundFile;
  //     });
  //     // var raf = file.openSync(mode: FileMode.write);
  //     // response.data is List<int> type
  //     // raf.writeFromSync(response.data);
  //     // await raf.close();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
