
import 'dart:io';
import 'dart:typed_data';


import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:scanbot_sdk/common_data.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

import 'package:scannerdocumentos/pages_repository.dart';

import 'package:scannerdocumentos/src/pages/pages_data.dart';


import 'package:flutter_share_file/flutter_share_file.dart';



class PDFOper extends StatelessWidget {
  Page _page;
  final PageRepository _pageRepository;

  PDFOper(this._page, this._pageRepository);

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, 
          ),
          backgroundColor: Colors.white,
          title: const Text('Vista previa',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: PagesPreviewWidget(_page, _pageRepository));
  }
}

class PagesPreviewWidget extends StatefulWidget {
  Page page;
  final PageRepository _pageRepository;

  PagesPreviewWidget(this.page, this._pageRepository);

  @override
  State<PagesPreviewWidget> createState() {
    return new PagesPreviewWidgetState(page, this._pageRepository);
  }
}

class PagesPreviewWidgetState extends State<PagesPreviewWidget> {
  Page page;
  final PageRepository _pageRepository;

  PagesPreviewWidgetState(this.page, this._pageRepository);

  void _updatePage(Page page) {
    imageCache.clear();
    _pageRepository.updatePage(page);
    setState(() {
      this.page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Center(child: PageData(page.documentImageFileUri)))),
        BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share, color: Colors.blue,),
                    Container(width: 4),
                    Text('Compartir',
                        style: TextStyle(inherit: true, color: Colors.blue)),
                  ],
                ),
                onPressed: () async {
                 // final String dir = (await getApplicationDocumentsDirectory()).path;
                  Directory storageDirectory = await getExternalStorageDirectory();
                  /* var file = File.fromUri(this.page.originalImageFileUri);
                  print(this.page.originalImageFileUri);
                  var bytes = file.readAsBytesSync();
                  String ruta = "${storageDirectory.path}/my-custom-storage/snapping_pages/";
                  Share.file("Documento Escaneado", ruta, bytes, "image/jpg"); */
                    
                   
                   FlutterShareFile.shareImage("${storageDirectory.path}/my-custom-storage/snapping_pages/", page.pageId+"/document_image.jpg");
                   print("${storageDirectory.path}/my-custom-storage/snapping_pages/");
                   print(page.documentImageFileUri);
                   


                 },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete, color: Colors.red),
                    Container(width: 4),
                    Text('Eliminar',
                        style: TextStyle(inherit: true, color: Colors.red)),
                  ],
                ),
                onPressed: () {
                  deletePage(page);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  deletePage(Page page) async {
    try {
      await ScanbotSdk.deletePage(page);
      this._pageRepository.removePage(page);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  

/* 
  static Future<void> file(String title, String name, List<int> bytes, String mimeType, {String text = ''}) async {
    Map argsMap = <String, String>{
      'title': '$title',
      'name': '$name',
      'mimeType': '$mimeType',
      'text': '$text'
    };

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$name').create();
    await file.writeAsBytes(bytes);

    _channel.invokeMethod('file', argsMap);
  }
 */
  compartirDocumento() async{
/*      //page.documentImageFileUri.toString()
    Image.asset(page.documentImageFileUri.toString());
    final ByteData bytes = await rootBundle.load(page.documentImageFileUri.toString());
    Share.file("Documento Escaneado", page.documentImageFileUri.toString(), bytes.buffer.asUint8List(), "image/jpg");
    //startCroppingScreen(page);
     // _settingModalBottomSheet(context, page);  */

    




  }

}
