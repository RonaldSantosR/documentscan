
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/render_pdf_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scannerdocumentos/pages_repository.dart';
import 'package:scannerdocumentos/src/pages/pages_data.dart';
import 'package:scannerdocumentos/src/pages/progress_dialog.dart';
import 'package:scannerdocumentos/src/utils/utils.dart';


class PageOper extends StatelessWidget {
  Page _page;
  final PageRepository _pageRepository;

  PageOper(this._page, this._pageRepository);

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text('Vista previa de imagen',
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
                    Icon(Icons.picture_as_pdf, color: Colors.blue,),
                    Container(width: 4),
                    Text('Convertir a PDF',
                        style: TextStyle(inherit: true, color: Colors.blue)),
                  ],
                ),
                onPressed: (){
                    createPdf(page);
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

    createPdf(Page page) async {
    //if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Creando PDF ...");
    try {
      dialog.show();
      var options = PdfRenderingOptions(PdfRenderSize.A4);
      final Uri pdfFileUri = await ScanbotSdk.createPdf(this._pageRepository.pages, options);
      this._pageRepository.addUriPDF(pdfFileUri);
      dialog.hide();
      showAlertDialog(context, pdfFileUri.toString(), title: "Nuevo archivo PDF");
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }




}
