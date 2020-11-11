import 'package:eWoke/components/badge.dart';
import 'package:eWoke/models/tvshow.dart';
import 'package:eWoke/models/tvshow_details.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/models/episode.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const FONTFAMILY = 'Raleway';

const greenColor = const Color(0xFF00C797);
const lightGreenColor = const Color(0xFF80E6CE);
const blueColor = const Color(0xFF8196FF);
const greyTextColor = const Color(0xFF565656);

const fireColor = const Color(0xFFF3403F);
const lightFireColor = const Color(0xFFFF8EB4);
const pinkColor = const Color(0xffff3847);
const lightPinkColor = const Color(0xFFFFAEB4);

const goldColor = const Color(0xffffd230);
const lightGoldColor = const Color(0xffffe27a);

const orangeColor = const Color(0xFFff2819);
const bgColor = const Color(0xFFF9F9F9);


const EPISODES_URL = "https://api.tvmaze.com/shows/";
const SEARCH_URL = "http://api.tvmaze.com/search/shows?q=";
const FULL_SCHEDULE_URL = "https://api.tvmaze.com/schedule/full";
//Concat these two to get episodes by date
const SHOW_URL = "https://api.tvmaze.com/shows/";
const SCHEDULE_URL = "/episodesbydate?date=";

const IMDBSHOW_URL = "http://api.tvmaze.com/lookup/shows?imdb=";

const double sliverRadius = 35.0;

const PLACEHOLDER_IMAGE = "https://wolper.com.au/wp-content/uploads/2017/10/image-placeholder.jpg";


List<String> sexCategories = ["Female", "Male"];


List<WatchedTVShow> watchedShowList = new List<WatchedTVShow>();
List<TVShowDetails> showDetailList = new List<TVShowDetails>();
List<WatchedTVShow> favorites = new List<WatchedTVShow>();
List<List<Episode>> scheduledEpisodes = [];
List<TVShow> popularShows = [];
List<WatchedTVShow> list = new List<WatchedTVShow>();

List<WatchedTVShow> allWatchedShows = new List<WatchedTVShow>();


List<List<TVShow>>limitedShows = [];


const Map<String, Badge> allBadges = {
  "fresh" : Badge(description: "Fresh", icon: FontAwesomeIcons.fire, colors:[fireColor, Colors.orange]),
  "paused" : Badge(description: "Paused watching",icon: FontAwesomeIcons.pause, colors:[Colors.purple, Colors.indigo]),
  "justStarted" : Badge(description: "Just started",icon: FontAwesomeIcons.airFreshener, colors:[goldColor, lightGoldColor]),
  "watching" : Badge(description: "Watching",icon: FontAwesomeIcons.hourglassHalf, colors:[greyTextColor, Colors.white54]),
  "finished" : Badge(description: "Finished",icon: FontAwesomeIcons.checkDouble, colors:[greenColor, Colors.greenAccent]),
  "hasMoreEpisodes" : Badge(description: "Running",icon: FontAwesomeIcons.pizzaSlice, colors:[Colors.orangeAccent, Colors.orange]),
  "waiting" : Badge(description: "Waiting for new episodes",icon: FontAwesomeIcons.stopwatch20, colors:[Colors.lightBlue, blueColor]),
  "favorite" : Badge(description: "Favorite",icon: FontAwesomeIcons.solidHeart, colors:[pinkColor,lightPinkColor]),
};


const List DISCOVER_DATA = [ ["Overall Progress", 0xFF595959, 0xFFB1B1B1, FontAwesomeIcons.spinner], ["Most popular shows",0xFFFF006F, 0xFFFFDBE2, FontAwesomeIcons.fire], ["Watchlist", 0xFF59b4ff, 0xffbfe2ff, FontAwesomeIcons.binoculars] ,["Favorites", 0xFFFFAEB4, 0xfffff5e2,FontAwesomeIcons.solidHeart]];
List<String> searchHistory = [];
const List SORT_CATEGORIES = [ "Title", "Year", "Runtime" , "Progress", "Rating"];

const Map<String, String> statusCodes = {
  "Ended" : "END",
  "Running" : "RUN",
  "To Be Determined" : "TBD",
  "In Development" : "ID"
};


List<Map<dynamic,String>> countryCodes = [
  {"code":"ab","name":"Abkhaz","nativeName":"аҧсуа"},
  {"code":"aa","name":"Afar","nativeName":"Afaraf"},
  {"code":"af","name":"Afrikaans","nativeName":"Afrikaans"},
  {"code":"ak","name":"Akan","nativeName":"Akan"},
  {"code":"sq","name":"Albanian","nativeName":"Shqip"},
  {"code":"am","name":"Amharic","nativeName":"አማርኛ"},
  {"code":"ar","name":"Arabic","nativeName":"العربية"},
  {"code":"an","name":"Aragonese","nativeName":"Aragonés"},
  {"code":"hy","name":"Armenian","nativeName":"Հայերեն"},
  {"code":"as","name":"Assamese","nativeName":"অসমীয়া"},
  {"code":"av","name":"Avaric","nativeName":"авар мацӀ, магӀарул мацӀ"},
  {"code":"ae","name":"Avestan","nativeName":"avesta"},
  {"code":"ay","name":"Aymara","nativeName":"aymar aru"},
  {"code":"az","name":"Azerbaijani","nativeName":"azərbaycan dili"},
  {"code":"bm","name":"Bambara","nativeName":"bamanankan"},
  {"code":"ba","name":"Bashkir","nativeName":"башҡорт теле"},
  {"code":"eu","name":"Basque","nativeName":"euskara, euskera"},
  {"code":"be","name":"Belarusian","nativeName":"Беларуская"},
  {"code":"bn","name":"Bengali","nativeName":"বাংলা"},
  {"code":"bh","name":"Bihari","nativeName":"भोजपुरी"},
  {"code":"bi","name":"Bislama","nativeName":"Bislama"},
  {"code":"bs","name":"Bosnian","nativeName":"bosanski jezik"},
  {"code":"br","name":"Breton","nativeName":"brezhoneg"},
  {"code":"bg","name":"Bulgarian","nativeName":"български език"},
  {"code":"my","name":"Burmese","nativeName":"ဗမာစာ"},
  {"code":"ca","name":"Catalan; Valencian","nativeName":"Català"},
  {"code":"ch","name":"Chamorro","nativeName":"Chamoru"},
  {"code":"ce","name":"Chechen","nativeName":"нохчийн мотт"},
  {"code":"ny","name":"Chichewa; Chewa; Nyanja","nativeName":"chiCheŵa, chinyanja"},
  {"code":"zh","name":"Chinese","nativeName":"中文 (Zhōngwén), 汉语, 漢語"},
  {"code":"cv","name":"Chuvash","nativeName":"чӑваш чӗлхи"},
  {"code":"kw","name":"Cornish","nativeName":"Kernewek"},
  {"code":"co","name":"Corsican","nativeName":"corsu, lingua corsa"},
  {"code":"cr","name":"Cree","nativeName":"ᓀᐦᐃᔭᐍᐏᐣ"},
  {"code":"hr","name":"Croatian","nativeName":"hrvatski"},
  {"code":"cs","name":"Czech","nativeName":"česky, čeština"},
  {"code":"da","name":"Danish","nativeName":"dansk"},
  {"code":"dv","name":"Divehi; Dhivehi; Maldivian;","nativeName":"ދިވެހި"},
  {"code":"nl","name":"Dutch","nativeName":"Nederlands, Vlaams"},
  {"code":"en","name":"English","nativeName":"English"},
  {"code":"eo","name":"Esperanto","nativeName":"Esperanto"},
  {"code":"et","name":"Estonian","nativeName":"eesti, eesti keel"},
  {"code":"ee","name":"Ewe","nativeName":"Eʋegbe"},
  {"code":"fo","name":"Faroese","nativeName":"føroyskt"},
  {"code":"fj","name":"Fijian","nativeName":"vosa Vakaviti"},
  {"code":"fi","name":"Finnish","nativeName":"suomi, suomen kieli"},
  {"code":"fr","name":"French","nativeName":"français, langue française"},
  {"code":"ff","name":"Fula; Fulah; Pulaar; Pular","nativeName":"Fulfulde, Pulaar, Pular"},
  {"code":"gl","name":"Galician","nativeName":"Galego"},
  {"code":"ka","name":"Georgian","nativeName":"ქართული"},
  {"code":"de","name":"German","nativeName":"Deutsch"},
  {"code":"el","name":"Greek, Modern","nativeName":"Ελληνικά"},
  {"code":"gn","name":"Guaraní","nativeName":"Avañeẽ"},
  {"code":"gu","name":"Gujarati","nativeName":"ગુજરાતી"},
  {"code":"ht","name":"Haitian; Haitian Creole","nativeName":"Kreyòl ayisyen"},
  {"code":"ha","name":"Hausa","nativeName":"Hausa, هَوُسَ"},
  {"code":"he","name":"Hebrew (modern)","nativeName":"עברית"},
  {"code":"hz","name":"Herero","nativeName":"Otjiherero"},
  {"code":"hi","name":"Hindi","nativeName":"हिन्दी, हिंदी"},
  {"code":"ho","name":"Hiri Motu","nativeName":"Hiri Motu"},
  {"code":"hu","name":"Hungarian","nativeName":"Magyar"},
  {"code":"ia","name":"Interlingua","nativeName":"Interlingua"},
  {"code":"id","name":"Indonesian","nativeName":"Bahasa Indonesia"},
  {"code":"ie","name":"Interlingue","nativeName":"Originally called Occidental; then Interlingue after WWII"},
  {"code":"ga","name":"Irish","nativeName":"Gaeilge"},
  {"code":"ig","name":"Igbo","nativeName":"Asụsụ Igbo"},
  {"code":"ik","name":"Inupiaq","nativeName":"Iñupiaq, Iñupiatun"},
  {"code":"io","name":"Ido","nativeName":"Ido"},
  {"code":"is","name":"Icelandic","nativeName":"Íslenska"},
  {"code":"it","name":"Italian","nativeName":"Italiano"},
  {"code":"iu","name":"Inuktitut","nativeName":"ᐃᓄᒃᑎᑐᑦ"},
  {"code":"ja","name":"Japanese","nativeName":"日本語 (にほんご／にっぽんご)"},
  {"code":"jv","name":"Javanese","nativeName":"basa Jawa"},
  {"code":"kl","name":"Kalaallisut, Greenlandic","nativeName":"kalaallisut, kalaallit oqaasii"},
  {"code":"kn","name":"Kannada","nativeName":"ಕನ್ನಡ"},
  {"code":"kr","name":"Kanuri","nativeName":"Kanuri"},
  {"code":"ks","name":"Kashmiri","nativeName":"कश्मीरी, كشميري‎"},
  {"code":"kk","name":"Kazakh","nativeName":"Қазақ тілі"},
  {"code":"km","name":"Khmer","nativeName":"ភាសាខ្មែរ"},
  {"code":"ki","name":"Kikuyu, Gikuyu","nativeName":"Gĩkũyũ"},
  {"code":"rw","name":"Kinyarwanda","nativeName":"Ikinyarwanda"},
  {"code":"ky","name":"Kirghiz, Kyrgyz","nativeName":"кыргыз тили"},
  {"code":"kv","name":"Komi","nativeName":"коми кыв"},
  {"code":"kg","name":"Kongo","nativeName":"KiKongo"},
  {"code":"ko","name":"Korean","nativeName":"한국어 (韓國語), 조선말 (朝鮮語)"},
  {"code":"ku","name":"Kurdish","nativeName":"Kurdî, كوردی‎"},
  {"code":"kj","name":"Kwanyama, Kuanyama","nativeName":"Kuanyama"},
  {"code":"la","name":"Latin","nativeName":"latine, lingua latina"},
  {"code":"lb","name":"Luxembourgish, Letzeburgesch","nativeName":"Lëtzebuergesch"},
  {"code":"lg","name":"Luganda","nativeName":"Luganda"},
  {"code":"li","name":"Limburgish, Limburgan, Limburger","nativeName":"Limburgs"},
  {"code":"ln","name":"Lingala","nativeName":"Lingála"},
  {"code":"lo","name":"Lao","nativeName":"ພາສາລາວ"},
  {"code":"lt","name":"Lithuanian","nativeName":"lietuvių kalba"},
  {"code":"lu","name":"Luba-Katanga","nativeName":""},
  {"code":"lv","name":"Latvian","nativeName":"latviešu valoda"},
  {"code":"gv","name":"Manx","nativeName":"Gaelg, Gailck"},
  {"code":"mk","name":"Macedonian","nativeName":"македонски јазик"},
  {"code":"mg","name":"Malagasy","nativeName":"Malagasy fiteny"},
  {"code":"ms","name":"Malay","nativeName":"bahasa Melayu, بهاس ملايو‎"},
  {"code":"ml","name":"Malayalam","nativeName":"മലയാളം"},
  {"code":"mt","name":"Maltese","nativeName":"Malti"},
  {"code":"mi","name":"Māori","nativeName":"te reo Māori"},
  {"code":"mr","name":"Marathi (Marāṭhī)","nativeName":"मराठी"},
  {"code":"mh","name":"Marshallese","nativeName":"Kajin M̧ajeļ"},
  {"code":"mn","name":"Mongolian","nativeName":"монгол"},
  {"code":"na","name":"Nauru","nativeName":"Ekakairũ Naoero"},
  {"code":"nv","name":"Navajo, Navaho","nativeName":"Diné bizaad, Dinékʼehǰí"},
  {"code":"nb","name":"Norwegian Bokmål","nativeName":"Norsk bokmål"},
  {"code":"nd","name":"North Ndebele","nativeName":"isiNdebele"},
  {"code":"ne","name":"Nepali","nativeName":"नेपाली"},
  {"code":"ng","name":"Ndonga","nativeName":"Owambo"},
  {"code":"nn","name":"Norwegian Nynorsk","nativeName":"Norsk nynorsk"},
  {"code":"no","name":"Norwegian","nativeName":"Norsk"},
  {"code":"ii","name":"Nuosu","nativeName":"ꆈꌠ꒿ Nuosuhxop"},
  {"code":"nr","name":"South Ndebele","nativeName":"isiNdebele"},
  {"code":"oc","name":"Occitan","nativeName":"Occitan"},
  {"code":"oj","name":"Ojibwe, Ojibwa","nativeName":"ᐊᓂᔑᓈᐯᒧᐎᓐ"},
  {"code":"cu","name":"Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic","nativeName":"ѩзыкъ словѣньскъ"},
  {"code":"om","name":"Oromo","nativeName":"Afaan Oromoo"},
  {"code":"or","name":"Oriya","nativeName":"ଓଡ଼ିଆ"},
  {"code":"os","name":"Ossetian, Ossetic","nativeName":"ирон æвзаг"},
  {"code":"pa","name":"Panjabi, Punjabi","nativeName":"ਪੰਜਾਬੀ, پنجابی‎"},
  {"code":"pi","name":"Pāli","nativeName":"पाऴि"},
  {"code":"fa","name":"Persian","nativeName":"فارسی"},
  {"code":"pl","name":"Polish","nativeName":"polski"},
  {"code":"ps","name":"Pashto, Pushto","nativeName":"پښتو"},
  {"code":"pt","name":"Portuguese","nativeName":"Português"},
  {"code":"qu","name":"Quechua","nativeName":"Runa Simi, Kichwa"},
  {"code":"rm","name":"Romansh","nativeName":"rumantsch grischun"},
  {"code":"rn","name":"Kirundi","nativeName":"kiRundi"},
  {"code":"ro","name":"Romanian, Moldavian, Moldovan","nativeName":"română"},
  {"code":"ru","name":"Russian","nativeName":"русский язык"},
  {"code":"sa","name":"Sanskrit (Saṁskṛta)","nativeName":"संस्कृतम्"},
  {"code":"sc","name":"Sardinian","nativeName":"sardu"},
  {"code":"sd","name":"Sindhi","nativeName":"सिन्धी, سنڌي، سندھی‎"},
  {"code":"se","name":"Northern Sami","nativeName":"Davvisámegiella"},
  {"code":"sm","name":"Samoan","nativeName":"gagana faa Samoa"},
  {"code":"sg","name":"Sango","nativeName":"yângâ tî sängö"},
  {"code":"sr","name":"Serbian","nativeName":"српски језик"},
  {"code":"gd","name":"Scottish Gaelic; Gaelic","nativeName":"Gàidhlig"},
  {"code":"sn","name":"Shona","nativeName":"chiShona"},
  {"code":"si","name":"Sinhala, Sinhalese","nativeName":"සිංහල"},
  {"code":"sk","name":"Slovak","nativeName":"slovenčina"},
  {"code":"sl","name":"Slovene","nativeName":"slovenščina"},
  {"code":"so","name":"Somali","nativeName":"Soomaaliga, af Soomaali"},
  {"code":"st","name":"Southern Sotho","nativeName":"Sesotho"},
  {"code":"es","name":"Spanish; Castilian","nativeName":"español, castellano"},
  {"code":"su","name":"Sundanese","nativeName":"Basa Sunda"},
  {"code":"sw","name":"Swahili","nativeName":"Kiswahili"},
  {"code":"ss","name":"Swati","nativeName":"SiSwati"},
  {"code":"sv","name":"Swedish","nativeName":"svenska"},
  {"code":"ta","name":"Tamil","nativeName":"தமிழ்"},
  {"code":"te","name":"Telugu","nativeName":"తెలుగు"},
  {"code":"tg","name":"Tajik","nativeName":"тоҷикӣ, toğikī, تاجیکی‎"},
  {"code":"th","name":"Thai","nativeName":"ไทย"},
  {"code":"ti","name":"Tigrinya","nativeName":"ትግርኛ"},
  {"code":"bo","name":"Tibetan Standard, Tibetan, Central","nativeName":"བོད་ཡིག"},
  {"code":"tk","name":"Turkmen","nativeName":"Türkmen, Түркмен"},
  {"code":"tl","name":"Tagalog","nativeName":"Wikang Tagalog, ᜏᜒᜃᜅ᜔ ᜆᜄᜎᜓᜄ᜔"},
  {"code":"tn","name":"Tswana","nativeName":"Setswana"},
  {"code":"to","name":"Tonga (Tonga Islands)","nativeName":"faka Tonga"},
  {"code":"tr","name":"Turkish","nativeName":"Türkçe"},
  {"code":"ts","name":"Tsonga","nativeName":"Xitsonga"},
  {"code":"tt","name":"Tatar","nativeName":"татарча, tatarça, تاتارچا‎"},
  {"code":"tw","name":"Twi","nativeName":"Twi"},
  {"code":"ty","name":"Tahitian","nativeName":"Reo Tahiti"},
  {"code":"ug","name":"Uighur, Uyghur","nativeName":"Uyƣurqə, ئۇيغۇرچە‎"},
  {"code":"uk","name":"Ukrainian","nativeName":"українська"},
  {"code":"ur","name":"Urdu","nativeName":"اردو"},
  {"code":"uz","name":"Uzbek","nativeName":"zbek, Ўзбек, أۇزبېك‎"},
  {"code":"ve","name":"Venda","nativeName":"Tshivenḓa"},
  {"code":"vi","name":"Vietnamese","nativeName":"Tiếng Việt"},
  {"code":"vo","name":"Volapük","nativeName":"Volapük"},
  {"code":"wa","name":"Walloon","nativeName":"Walon"},
  {"code":"cy","name":"Welsh","nativeName":"Cymraeg"},
  {"code":"wo","name":"Wolof","nativeName":"Wollof"},
  {"code":"fy","name":"Western Frisian","nativeName":"Frysk"},
  {"code":"xh","name":"Xhosa","nativeName":"isiXhosa"},
  {"code":"yi","name":"Yiddish","nativeName":"ייִדיש"},
  {"code":"yo","name":"Yoruba","nativeName":"Yorùbá"},
  {"code":"za","name":"Zhuang, Chuang","nativeName":"Saɯ cueŋƅ, Saw cuengh"}
];
















//region OLD_DATA
// const List SHOWS_DATA = [
//   [
//     {
//       "showID": "5995",
//       "name: "The Office",
//       "runtime": 30,
//       "start_date": "2005-03-24",
//       "image_thumbnail_path": "https://m.media-amazon.com/images/M/MV5BMDNkOTE4NDQtMTNmYi00MWE0LWE4ZTktYTc0NzhhNWIzNzJiXkEyXkFqcGdeQXVyMzQ2MDI5NjU@._V1_SY999_CR0,0,665,999_AL_.jpg",
//       "total_seasons": 9,
//       "episodesPerSeason": {
//         "1": 23,
//         "2": 23,
//         "3": 23,
//         "4": 23,
//         "5": 23,
//         "6": 23,
//         "7": 23,
//         "8": 23,
//         "9": 23
//       },
//       "currentSeason": 9,
//       "currentEpisode": 5,
//       "startedWatching": "2020-01-01",
//       "lastWatched": "2020-08-07"
//     },
//     {
//       "showID": "17658",
//       ""name"": "Breaking Bad",
//       "start_date": "2008-01-20",
//       "runtime" : 60,
//       "image_thumbnail_path": "m.media-amazon.com/images/M/MV5BMjhiMzgxZTctNDc1Ni00OTIxLTlhMTYtZTA3ZWFkODRkNmE2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SY1000_CR0,0,718,1000_AL_.jpg",
//       "total_seasons": 5,
//       "episodesPerSeason": {
//         "1": 7,
//         "2": 13,
//         "3": 13,
//         "4": 13,
//         "5": 16
//       },
//       "currentSeason": 5,
//       "currentEpisode": 16,
//       "startedWatching": "2016-04-05",
//       "lastWatched": "2016-08-08"
//     },
//     {
//       "showID": "59970",
//       ""name"": "The Punisher",
//       "start_date": "2017-11-17",
//       "runtime" : 60,
//       "image_thumbnail_path": "https://m.media-amazon.com/images/M/MV5BMTExODIwOTUxNzFeQTJeQWpwZ15BbWU4MDE5MDA0MTcz._V1_SY1000_CR0,0,674,1000_AL_.jpg",
//       "total_seasons": 2,
//       "episodesPerSeason": {
//         "1": 13,
//         "2": 13
//       },
//       "currentSeason": 1,
//       "currentEpisode": 9,
//       "startedWatching": "2020-01-01",
//       "lastWatched": "2020-08-05"
//     }
//   ]
// ];
// endregion