import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/domain/state/likes_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/widget/components/loadable_image.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

GetIt getIt = GetIt.instance;

class HistoryList extends StatelessWidget {
  final List<LikeInteraction> content;

  const HistoryList({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.isNotEmpty) {
      return Card(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color.fromARGB(255, 240, 240, 255)
              : const Color.fromARGB(255, 10, 10, 15),
          child: ListView.separated(
            cacheExtent: 500,
            itemBuilder: (context, index) => _HistoryItem(
              index + 1,
              content[index],
            ),
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            itemCount: content.length,
          ));
    }
    return const Center(
        child: Text(style: TextStyle(fontSize: 25), "No entries to display"));
  }
}

class _HistoryItem extends StatelessWidget {
  static DateFormat formatter = DateFormat('MM-dd HH:mm');
  final int index;
  final LikeInteraction interaction;

  const _HistoryItem(this.index, this.interaction);

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

    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50, maxHeight: 50),
        child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 2,
              children: [
                SizedBox(
                    width: 20,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          index.toString(),
                          style: const TextStyle(fontSize: 20),
                        ))),
                IconButton.filled(
                    style: IconButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        minimumSize: const Size.fromWidth(80),
                        maximumSize: const Size.fromWidth(80),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        backgroundColor: Colors.transparent,
                        hoverColor:
                            Theme.of(context).brightness == Brightness.light
                                ? const Color.fromARGB(10, 0, 0, 0)
                                : const Color.fromARGB(10, 255, 255, 255)),
                    onPressed: () => getIt<NavigationManager>()
                        .openDetails(interaction.imageInfo),
                    icon: LoadableImage(
                        url: interaction.imageInfo.url, fit: BoxFit.fitHeight)),
                likeOrDislike,
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 5),
                        child: Text(
                          interaction.imageInfo.imageName,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ))),
                Expanded(
                    child: Text(
                  formatter.format(interaction.actionTime),
                  overflow: TextOverflow.fade,
                )),
                TextButton(
                    onPressed: () => deleteSelf(context),
                    child: const Text("Delete"))
              ],
            )));
  }
}
