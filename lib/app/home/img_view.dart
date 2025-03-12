// ignore_for_file: must_be_immutable, library_private_types_in_public_api, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../api/logic/API.dart';
import '../navigation/navigation.dart';

class ImgView extends StatefulWidget {
  List<String> img;
  ImgView({super.key, required this.img});

  @override
  _ImgViewState createState() => _ImgViewState(img);
}

class _ImgViewState extends State<ImgView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> img;
  String shareImg = "";

  _ImgViewState(this.img);

  @override
  void initState() {
    super.initState();
    API.setLight();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: Color(0x80000000),
          systemNavigationBarContrastEnforced: true,
        ),
        backgroundColor: const Color(0xCC111111),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
          child: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 200),
                  reverseTransitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Navigation(
                    pIndex: 0,
                    reNav: false,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end: end);
                    final offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
                (route) => false, // This condition removes all previous routes
              );
            },
            child: const Icon(
              Icons.chevron_left_sharp,
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
        title: img.length > 1
            ? Text("Swipe to view more...",
                style: TextStyle(fontFamily: 'DM Sans',
                  
                  color: Colors.white,
                  fontSize: 13,
                ))
            : const SizedBox(),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 3, 25, 0),
            child: InkWell(
              onTap: () async {
                if (shareImg == "") {
                  shareImg = img[0];
                }
                final url = Uri.parse(shareImg);
                final response = await http.get(url);
                Share.shareXFiles([
                  XFile.fromData(
                    response.bodyBytes,
                    mimeType: 'image/png',
                  ),
                ]);
              },
              child: const Icon(
                Icons.share_sharp,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(img[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              initialScale: PhotoViewComputedScale.contained,
            );
          },
          itemCount: img.length,
          loadingBuilder: (context, progress) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
          onPageChanged: (index) {
            shareImg = img[index];
          },
        ),

        // GestureDetector(
        //     child: PhotoView(
        //   imageProvider: NetworkImage(img),
        //   minScale: PhotoViewComputedScale.contained * 0.8,
        //   maxScale: PhotoViewComputedScale.covered * 2.5,
        //   initialScale: PhotoViewComputedScale.contained,
        // )),
      ),
    );
  }
}
