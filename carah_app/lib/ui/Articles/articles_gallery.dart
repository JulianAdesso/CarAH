// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/articles_provider.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
//
// import '../../shared/appbar_widget.dart';
//
// class ArticlesGallery extends StatefulWidget {
//
//   final String id;
//   final String categoryId;
//
//   const ArticlesGallery({super.key, required this.id, required this.categoryId});
//
//   @override
//   _ArticlesGallery createState() => _ArticlesGallery();
//   }
//
// class _ArticlesGallery extends State<ArticlesGallery> {
//   bool isLoading = false;
//   late int shownPictureNumber = 1;
//
//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }
//
//   void onPageChanged(int index) {
//     setState(() {
//       shownPictureNumber = index + 1;
//     });
//   }
//
//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });
//     var provider = Provider.of<ArticlesProvider>(context, listen: false);
//     await provider.getArticleByUUID(widget.id, widget.categoryId);
//     setState(() {
//       isLoading = false;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return Consumer<ArticlesProvider>(
//         builder: (context, provider, child) {
//           return Scaffold(
//             appBar: AppbarWidget(
//               centerTitle: true,
//               backgroundColor: Colors.black ,
//               title:  "$shownPictureNumber from ${provider.images.length}",
//             ),
//             body: PhotoViewGallery.builder(
//               scrollPhysics: const BouncingScrollPhysics(),
//               onPageChanged: onPageChanged,
//               builder: (BuildContext context, int index) {
//                 return PhotoViewGalleryPageOptions(
//                 imageProvider: (provider.showingImages[index].image),
//                   initialScale: PhotoViewComputedScale.contained * 1,
//                 );
//               },
//               itemCount: provider.images.length,
//               loadingBuilder: (context, event) => const Center(
//                 child: SizedBox(
//                   width: 20.0,
//                   height: 20.0,
//                 ),
//               ),
//             )
//           );
//         });
//   }
// }
