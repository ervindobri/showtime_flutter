import 'package:flutter/foundation.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterController {
  var selectedRuntime = 69;
  static List<String> genres = [
    "Action",
    "Drama",
    "Comedy",
    "Adventure",
    "Fantasy",
    "Horror",
    "Crime",
    "Thriller",
    "Espionage"
  ];
  var genreItems =
      genres.map((genre) => MultiSelectItem<String>(genre, genre)).toList();

  late List<String?> selectedGenres;

  ValueNotifier<SfRangeValues> runtimeRangeValues =
      ValueNotifier<SfRangeValues>(const SfRangeValues(20.0, 60.0));
  late SfRangeValues selectedRuntimeRangeValues;
}
