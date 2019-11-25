import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/render_pdf_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scannerdocumentos/pages_repository.dart';
import 'package:scannerdocumentos/src/pages/filter_multi_page.dart';
import 'package:scannerdocumentos/src/pages/page_oper.dart';
import 'package:scannerdocumentos/src/pages/pages_data.dart';
import 'package:scannerdocumentos/src/pages/progress_dialog.dart';
import 'package:scannerdocumentos/src/utils/utils.dart';



class DocumentVista extends StatelessWidget {
  final PageRepository _pageRepository;
  
  DocumentVista(this._pageRepository);

  @override
  Widget build(BuildContext context) {
    //List<Widget> _buttons = List();
   /*  if (_selectionMode) {
      _buttons.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            //_selectedIndexList.sort();
            //print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
          }));
    } */
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          //actions: _buttons,
          title: const Text('Galería de Imágenes',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: PagesPreviewWidget(this._pageRepository));
  }
}

class PagesPreviewWidget extends StatefulWidget {
  final PageRepository _pageRepository;

  PagesPreviewWidget(this._pageRepository);

  @override
  State<PagesPreviewWidget> createState() {
    return new PagesPreviewWidgetState(this._pageRepository);
  }
}

class PagesPreviewWidgetState extends State<PagesPreviewWidget> {
  List<Page> pages;
  final PageRepository _pageRepository;
  int currentSelectedPage = 0;
  var isSelected = false;
  var mycolor=Colors.white;
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

  PagesPreviewWidgetState(this._pageRepository) {
    this.pages = _pageRepository.pages;
  }

  void _updatePagesList() {
    imageCache.clear();
    Future.delayed(Duration(microseconds: 500)).then((val) {
      setState(() {
        this.pages = _pageRepository.pages;
      });
    });
  }

void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if(!_selectionMode){
       return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200),
                    itemBuilder: (context, position) {  
                      return getGridTile(position);
                    },
                    itemCount: pages?.length ?? 0)
                )
          ),
       
      ],
     );
     
    }else{
       return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200),
                    itemBuilder: (context, position) {  
                      return getGridTile(position);
                    },
                    itemCount: pages?.length ?? 0)
                )
          ),
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
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
              ),
            ],
          ),
        )
      ],
     );
    }


  }

  GridTile getGridTile(int position){

                if (_selectionMode){
                  return GridTile(
                          header: GridTileBar(
                            leading: Icon(
                               _selectedIndexList.contains(position) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                               color: _selectedIndexList.contains(position) ? Colors.green : Colors.black,
                            ),
                           ),
                          child: Container(
                            padding: EdgeInsets.only(top: 15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedIndexList.contains(position)) {
                                     _selectedIndexList.remove(position);
                                  } else {
                                     _selectedIndexList.add(position);
                                 }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 15),
                                child: PageData(
                                pages[position].documentPreviewImageFileUri,
                                ),
                              ),
                              onLongPress: () {
                                setState(() {
                                 _changeSelection(enable: false, index: -1);
                                });
                              },
                            ),
                          )
                        );

                  }else{
                    return GridTile(
                         child: InkResponse(
                          child: Container(
                             padding: EdgeInsets.only(top: 15),
                             child: PageData(
                                pages[position].documentPreviewImageFileUri,
                            ),
                          ),
                          onLongPress: () {
                            setState(() {
                            _changeSelection(enable: true, index: position);
                            });
                          },
                          onTap: (){
                            showOperationsPage(pages[position]);
                          },
                         
              ),
      );
                  }
  }

  showOperationsPage(Page page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PageOper(page, _pageRepository)),
    );
    _updatePagesList();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.picture_as_pdf),
                  title: new Text('Guardar como PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    createPdf();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.close),
                  title: new Text('Cancelar'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  cleanupStorage() async {
    try {
      await ScanbotSdk.cleanupStorage();
      _pageRepository.clearPages();
      _updatePagesList();
    } catch (e) {
      print(e);
    }
  }

  createPdf() async {
    if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Creando PDF ...");
    try {
      dialog.show();
      var options = PdfRenderingOptions(PdfRenderSize.A4);
      final Uri pdfFileUri = await ScanbotSdk.createPdf(this._pageRepository.pages, options);
      this._pageRepository.addUriPDF(pdfFileUri);
      print(pdfFileUri.toFilePath());
      dialog.hide();
      showAlertDialog(context, pdfFileUri.toString(), title: "Nuevo archivo PDF");
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }



  Future<bool> checkHasPages(BuildContext context) async {
    if (pages.isNotEmpty) {
      return true;
    }
    await showAlertDialog(context, 'Please scan or import some documents to perform this function.', title: 'Info');
    return false;
  }

}
