import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

      openPDF(context,url) async {
        print("hee");
        var urli = Uri.parse('https://arxiv.org/pdf/1904.01941.pdf');
        var urlu = Uri.parse('https://drive.google.com/drive/folders/1uvHO8Rc05b8qvL_V9dGhjhbBercm33Wp/Regulation on School Safety.pdf');
        print(urlu);
        var response = await http.get(urlu);
        print(response.bodyBytes);

    final tempDir = await getTemporaryDirectory();
    print(tempDir.path);
    File file = File("${tempDir.path}/mypdfonline.pdf");
    // final file = await File("${tempDir.path}/mypdfonline.pdf").create(recursive: true);
      File urlFile = await file.writeAsBytes(response.bodyBytes);
      
      print(urlFile.path);

      Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFViewerScaffold(path:urlFile.path)));

      // return urlFile.path;

  }