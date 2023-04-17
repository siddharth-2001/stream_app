import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/current_watch_panel.dart';

//provider imports
import '../provider/anime.dart';

class CurrentWatchList extends StatefulWidget {
  const CurrentWatchList({super.key});

  @override
  State<CurrentWatchList> createState() => _CurrentWatchListState();
}

class _CurrentWatchListState extends State<CurrentWatchList> {
  bool _isLoading = true;
  List<Map<Anime, int>> list = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AllAnime>(context, listen: false)
        .fetchCurrentlyWatching()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<AllAnime>(context, listen: true).currWatchList;

    return _isLoading
        ? const CupertinoActivityIndicator()
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            itemBuilder: (BuildContext context, int index) {
              final Anime anime = list[index].keys.first;
              return CurrentWatchPanel(
                id: anime.details["id"]!,
                name: anime.details["name"]!,
                episodeIndex: list[index].values.first.toString(),
                image: anime.details["image"]!,
              );
            },
          );
  }
}