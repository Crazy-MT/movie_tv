import 'package:diff_match_patch/diff_match_patch.dart';

class Utils {
  List<Diff> diffStr(String str1, String str2) {
    List d = diff(str1, str2);

    for(Diff diff in d) {
      print('MTMTMT Utils.diffStr ${diff.text} ');
    }
    return d;
  }
}

Utils util = new Utils();