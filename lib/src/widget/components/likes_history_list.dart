import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/widget/components/loadable_image.dart';

class HistoryList extends StatelessWidget {
  final List<LikeInteraction> content;

  const HistoryList({super.key, required this.content});

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemBuilder: (context, index) => _HistoryItem(
          index,
          content[index],
        ),
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        itemCount: content.length,
      );
}

class _HistoryItem extends StatelessWidget {
  int index;
  LikeInteraction interaction;

  _HistoryItem(this.index, this.interaction);

  void deleteSelf(BuildContext context) {
    var notifier = LikesHistoryInheritedNotifier.of(context);
    notifier.removeInteraction(interaction);
  }

  @override
  Widget build(BuildContext context) {
    ImageIcon likeOrDislike = interaction.isLike
        ? const ImageIcon(AssetImage("assets/icons/like.png"),
            size: 25, color: Color.fromARGB(255, 255, 60, 0))
        : const ImageIcon(AssetImage("assets/icons/dislike.png"),
            size: 25, color: Color.fromARGB(255, 0, 81, 255));

    return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(index.toString()),
            OutlinedButton(
                style:
                    OutlinedButton.styleFrom(side: const BorderSide(width: 3)),
                onPressed: () => NavigationManager.instance
                    .openDetails(interaction.imageInfo),
                child: LoadableImage(
                    url: interaction.imageInfo.url, fit: BoxFit.fitHeight)),
            likeOrDislike,
            Text(interaction.actionTime.toString()),
            const Spacer(),
            TextButton(
                onPressed: () => deleteSelf(context),
                child: const Text("Delete"))
          ],
        ));
  }
}
