import 'dart:convert';
import 'dart:io';




import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/render_pdf_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_models.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scannerdocumentos/src/pages/document_vista.dart';
import 'package:scannerdocumentos/src/pages/menu_items.dart';
import 'package:scannerdocumentos/src/pages/pdf_vista.dart';
import 'package:scannerdocumentos/src/utils/utils.dart';

import 'pages_repository.dart';



void main() => runApp(MyApp());
 
const SCANBOT_SDK_LICENSE_KEY = "ZnP70w/STfecm/ZUINT450OKWxOQu6" +
  "cAOOC7ugHKdjQkA1K5gn5maBKW1jMt" +
  "kM80Vk0/ODhCP1KUlfxeE0CjU5M03o" +
  "l+cxyZB+WTSQx21zvsCrJlMDGv00v9" +
  "kgCbdyOzHo2o/MJzBRpn0GwAwMNwp8" +
  "VbGJtQHq4a4VebgPZintH43JbmKStN" +
  "eP4VBySZwqhQGY6jN5wC46QbaPJtcl" +
  "UNNyy92TwpIWcvVrHOgcnTHYvZ5P7x" +
  "7Tuoum4rmBo4UR08+q8bWqEdWKABTV" +
  "yJs+rq2uO8rigYQU2qhY39kXygAjyh" +
  "SN4UOJhV5i3cUVdcK75DkmYcLkEfVE" +
  "IfPokCs2BWFw==\nU2NhbmJvdFNESw" +
  "pjb20uZXhhbXBsZS5zY2FubmVyZG9j" +
  "dW1lbnRvcwoxNTc2ODg2Mzk5CjU5MA" +
  "oz\n";

initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  var customStorageBaseDirectory = await getDemoStorageBaseDirectory();
  
  
  var config = ScanbotSdkConfig(
    loggingEnabled: true, // Consider switching logging OFF in production builds for security and performance reasons.
    licenseKey: SCANBOT_SDK_LICENSE_KEY,
    imageFormat: ImageFormat.JPG,
    imageQuality: 80,
    storageBaseDirectory: customStorageBaseDirectory
  );

  try {
    await ScanbotSdk.initScanbotSdk(config);
  } catch (e) {
    print(e);
  }
}

Future<String> getDemoStorageBaseDirectory() async {
  // !! Please note !!
  // It is strongly recommended to use the default (secure) storage location of the Scanbot SDK.
  // However, for demo purposes we overwrite the "storageBaseDirectory" of the Scanbot SDK by a custom storage directory.
  //
  // On Android we use the "ExternalStorageDirectory" which is a public(!) folder.
  // All image files and export files (PDF, TIFF, etc) created by the Scanbot SDK in this demo app will be stored
  // in this public storage directory and will be accessible for every(!) app having external storage permissions!
  // Again, this is only for demo purposes, which allows us to easily fetch and check the generated files
  // via Android "adb" CLI tools, Android File Transfer app, Android Studio, etc.
  //
  // On iOS we use the "ApplicationDocumentsDirectory" which is accessible via iTunes file sharing.
  //
  // For more details about the storage system of the Scanbot SDK Flutter Plugin please see our docs:
  // - https://scanbotsdk.github.io/documentation/flutter/
  //
  // For more details about the file system on Android and iOS we also recommend to check out:
  // - https://developer.android.com/guide/topics/data/data-storage
  // - https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

  Directory storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = await getExternalStorageDirectory();
  }
  else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  }
  else {
    throw("Unsupported platform");
  }

  return "${storageDirectory.path}/my-custom-storage";
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    initScanbotSdk();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPageWidget()
      );
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  PageRepository _pageRepository = PageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Exact Scanner',
            style: TextStyle(inherit: true, color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
           MenuItemWidget(
            "Escanear",
            endIcon: Icons.wallpaper,
            onTap: () {
              startDocumentScanning();
            },
          ),
          MenuItemWidget(
            "Ver Imágenes",
            endIcon: Icons.image,
            onTap: () {
              gotoImagesView();
            },
          ),
          MenuItemWidget(
            "Ver Documentos en PDF",
            endIcon: Icons.picture_as_pdf,
            onTap: () {
              gotoPDFView();
            },
          ),
        ],
      ),
    );
  }

 

/*   importImage() async {
    try {
      // TODO replace by a 3rd party "image picker" plugin
      var uri = await Utils.pickImage();
      if (uri != null && uri.path.isNotEmpty) {
        await createPage(uri);
        gotoImagesView();
      }
    } catch (e) {
      print(e);
    }
  } */

/*   createPage(Uri uri) async {
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Processing");
    dialog.show();
    try {
      var page = await ScanbotSdk.createPage(uri, false);
      page = await ScanbotSdk.detectDocument(page);
      this._pageRepository.addPage(page);
    } catch (e) {
      print(e);
    } finally {
      dialog.hide();
    }
  } */

  startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) { return; }

    DocumentScanningResult result;
    try {
      var config = DocumentScannerConfiguration(
        multiPageButtonHidden: false,
        bottomBarBackgroundColor: Colors.blue,
        shutterButtonHidden: false,
        ignoreBadAspectRatio: false,
        multiPageEnabled: true,
        //maxNumberOfPages: 3,
        //flashEnabled: true,
        //autoSnappingSensitivity: 0.7,
        cameraPreviewMode: CameraPreviewMode.FIT_IN,
        orientationLockMode: CameraOrientationMode.PORTRAIT,
        //documentImageSizeLimit: Size(2000, 3000),
        cancelButtonTitle: "Cancelar",
        pageCounterButtonTitle: "%d Página(s)",
        textHintOK: "No mover",
        autoSnappingEnabled: false
        //textHintNothingDetected: "Nothing",
        // ...
      );
      result = await ScanbotSdkUi.startDocumentScanner(config);
/*       var options = PdfRenderingOptions(PdfRenderSize.A4);
      final Uri pdfFileUri = await ScanbotSdk.createPdf(result.pages, options); */
    } catch (e) {
      print(e);
    }
    if (result?.operationResult != OperationResult.ERROR) {
      _pageRepository.addPages(result.pages);
      gotoImagesView();
    }
  }

  gotoImagesView() async {
    imageCache.clear();
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DocumentVista(_pageRepository)),
    );
  }


  gotoPDFView() async {
    imageCache.clear();
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PdfVista(_pageRepository)),
    );
  }

   getLicenseStatus() async {
    try {
      var result = await ScanbotSdk.getLicenseStatus();
      showAlertDialog(context, jsonEncode(result), title: "License Status");
    } catch (e) {
      print(e);
      showAlertDialog(context, "Error getting OCR configs");
    }
  }


}





/* class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'documents': (BuildContext context) => DocumentsPage()
      },
      theme: ThemeData(
        primaryColor: Colors.lightBlue
      ),
    );
  }
} */