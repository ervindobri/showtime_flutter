part of 'watched.dart';

extension WatchedTVShowExtension on WatchedTVShow {
  WatchedTVShow copyWith(
    String? id,
    String? name,
    DateTime? startDate,
    int? runtime,
    double? rating,
    String? imageThumbnailPath,
    int? totalSeasons,
    Map<String, int>? episodePerSeason,
    int? currentSeason,
    int? currentEpisode,
    String? firstWatchDate,
    String? lastWatchDate,
    bool? favorite,
  ) {
    return WatchedTVShow(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      runtime: runtime ?? this.runtime,
      rating: rating ?? this.rating,
      imageThumbnailPath: imageThumbnailPath ?? this.imageThumbnailPath,
      totalSeasons: totalSeasons ?? this.totalSeasons,
      episodePerSeason: episodePerSeason ?? this.episodePerSeason,
      currentSeason: currentSeason ?? this.currentSeason,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      firstWatchDate: firstWatchDate ?? this.firstWatchDate,
      lastWatchDate: lastWatchDate ?? this.lastWatchDate,
      favorite: favorite ?? this.favorite,
    );
  }
}
