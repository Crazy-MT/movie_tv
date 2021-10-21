abstract class MovieTv{
  String title;
  String url;
  String response = "";
  String lastResponse = "";

  Future getResponse();
}