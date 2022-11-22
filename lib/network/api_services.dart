import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';

class ApiService {
  static final ApiService _apiService = ApiService.internal();
  ApiService.internal();

  factory ApiService() {
    return _apiService;
  }

  // Dio dio = Dio();
  late Dio dio;
  Dio dioDownloader = Dio();

  void initDio(String baseUrl) {
    dio = Dio();

    dio.options.baseUrl = baseUrl;
    // dio.options.baseUrl = NetworkConfig.baseUrl;
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;

    AppSharedPreference().getStringData(AppConstants.API_TOKEN).then((value) {
      dio.options.headers['Authorization'] = 'Bearer $value';
    });

    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);

    Options options = buildCacheOptions(
      const Duration(days: 10),
      forceRefresh: true,
    );
  }

  /*void initDio() {

    dio.options.baseUrl = NetworkConfig.baseUrl;
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;
  }*/

  /*void initDio() {
    dio.options.baseUrl = 'https://listen-api.listennotes.com/api/v2';
    // dio.options.baseUrl = 'https://api.publicapis.org/';
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
  }*/

  Future<dynamic> fetchSearchResults(Map<String, dynamic> query) async {
    print(query);
    var response = await dio.post('/mobuser/podcast/search',
        data: query,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-ListenAPI-Key': AppConstants.token,
        }));

    return response.data;
  }

  /*Future<dynamic> fetchCategories() async {
    var response = await dio.get(
      '/category',
      options: buildCacheOptions(const Duration(days: 10),
          forceRefresh: true,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          })),
    );
    return response.data;
  }*/

  Future<dynamic> fetchCategories() async {
    var response = await dio.get(
      '/category',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        //'X-ListenAPI-Key': AppConstants.token,
      }),
    );
    return response.data;
  }

  Future<dynamic> getServerItems(String apiSuffix) async {
    var response = await dio.get(apiSuffix,
        options: Options(
          headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          //'X-ListenAPI-Key': AppConstants.token,
        }));
    return response.data;
  }

  Future<dynamic> fetchPodcastsByCategories(Map<String, dynamic> query) async {
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/category',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  //******************************list out report ******************************************* *//

  Future<dynamic> fetchItems(String apiSuffix) async {
    Response response;
    try {
      response = await dio.get(
        apiSuffix,
          options: Options(
            headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> fetchPodcasts(
      String apiSuffix, Map<String, dynamic> query) async {
    query['age_restriction'] = AppConstants.age_restricted ? 0 : 1;

    print(query);

    Response response;
    try {
      response = await dio.post(apiSuffix,
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> fetchRjs(apiSuffix, Map<String, dynamic> query) async {
    Response response;
    try {
      response = await dio.post(apiSuffix,
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> postData(apiSuffix, Map<String, dynamic> query,
      {bool ageNeeded = true}) async {
    if (ageNeeded) {
      query['age_restriction'] = AppConstants.age_restricted ? 0 : 1;
    }

    print(query);

    Response response;
    try {
      response = await dio.post(
        apiSuffix,
          data: query,
          /* options: buildCacheOptions(const Duration(days: 10),
              forceRefresh: true,
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                //'X-ListenAPI-Key': AppConstants.token,
              }))*/
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      // print('creates listing from api..........................................$response');
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> putData(apiSuffix, Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.put(apiSuffix,
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> deleteData(apiSuffix, Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.delete(apiSuffix,
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> fetchTrendingPodcasts() async {
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/trending',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> fetchTop50Podcasts() async {
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/top50',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> fetchTop50Newjs() async {
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/top50',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> postPodcastView(Map<String, dynamic> query) async {
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/viewed',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> searchPodcastByKeyword(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/search',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> podcastListByRj(Map<String, dynamic> query) async {
    // print('query..............................................$query');

    Response response;
    try {
      response = await dio.post('/mobuser/podcast/rj',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      // print('printed...........................................$response');
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> fetchTop50NewRjs() async {
    Response response;
    try {
      response = await dio.post('/mobuser/rj/top50',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> emailSignIn(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/mobuser/login',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> registerUser(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/mobuser/signup',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> registerSocialUser(Map<String, dynamic> query) async {
    print("social......................................$query");
    Response response;
    try {
      response = await dio.post('/mobuser/socialsignin',
          data: query,
          options: Options(
            headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print('sociallogin...........................$response');
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> sendOtp(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/sms/otp',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> sendNewOtp(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/sms/newotp',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> validOtp(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/mobuser/otpsignin',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> validNewOtp(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/sms/validate/app',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> otpSignupNew(Map<String, dynamic> query) async {
    print(query);
    Response response;
    try {
      response = await dio.post('/mobuser/otpsignup',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  Future<dynamic> validResetOtp(Map<String, dynamic> query) async {
    Response response;
    try {
      response = await dio.post('/sms/validate',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  ///*************post comment ***************** *////

  Future<dynamic> postComment(Map<String, Object> query) async {
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/comment',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            //'X-ListenAPI-Key': AppConstants.token,
          }));
      print('post45656Comment.................................$query');
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
    }
  }

  ////************************list comments******************************** *//////////////

  Future<dynamic> fetchComments(Map<String, dynamic> query) async {
    print('fetching comments ..................... $query');
    Response response;
    try {
      response = await dio.post('/mobuser/podcast/commentreplylist',
          data: query,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',

            //'X-ListenAPI-Key': AppConstants.token,
          }));
      // print('Response...................${response.data}');
      // print('RES => ${response.data}');
      return response.data;
    } on DioError catch (e, str) {
      // print('Error');
      // print(str);
      print(e.response?.data);
    }
  }



  Future<dynamic> uploadFile(String filePath) async {
    Response response;
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "filename": await MultipartFile.fromFile(filePath, filename: fileName),
      });

      response = await dio.post('/s3bucket/upload', data: formData);

      print('Response $response');

      return response.data;
    } on DioError catch (e, str) {
      print('Error uploading $str');
      print(e.response?.data);
      return null;
    }
  }




  Future<String> generateToken() async {
    var response = await dio.get(ApiKeys.GENERATE_TOKEN,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    print(response);
    final responseData = ResponseData.fromJson(response.data);

    if (responseData.status == "Success") {
      print("TOKEN_SERVICE" + responseData.response);
      dio.options.headers['Authorization'] = 'Bearer ${responseData.response}';
      return responseData.response;
    }

    return '';
  }

  void updateApiToken(token) {
    dio.options.headers['Authorization'] = 'Bearer $token';

    AppSharedPreference().saveStringData(AppConstants.API_TOKEN, token);
  }
}
