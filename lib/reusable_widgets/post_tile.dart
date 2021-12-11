import 'package:flutter/material.dart';
import 'package:kenso/reusable_widgets/custom_image.dart';
import 'package:kenso/reusable_widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  showPost(context) {
    Navigator.push(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: post.mediaUrl != null ? cachedNetworkImage(post.mediaUrl) : null,
    );
  }
}
