import 'package:flutter/cupertino.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_template/router/borg_router.dart';

class AptBanner extends StatefulWidget {
  final int width;
  final int height;
  final List<BannerItem> list;

  AptBanner({this.width = 75, this.height = 150, this.list});

  @override
  _Banner createState() => _Banner();
}

class _Banner extends State<AptBanner> {
  @override
  Widget build(BuildContext context) {
    return BannerSwiper(
      height: widget.height,
      width: widget.width,
      length: widget.list.length,
      spaceMode: false,
      getwidget: (index) {
        debugPrint('index = $index');
        return GestureDetector(
          child: CachedNetworkImage(
            imageUrl: widget.list[index%widget.list.length].imageUrl,
            fit:BoxFit.fill
          ),
          onTap: (){
            Router.push(context, widget.list[index%widget.list.length].schema);
          },
        );
      },
    );
  }
}

class BannerItem {
  final String imageUrl;
  final String schema;

  BannerItem(this.imageUrl, this.schema);
}
