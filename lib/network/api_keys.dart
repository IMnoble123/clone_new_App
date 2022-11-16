import 'package:podcast_app/network/common_network_calls.dart';

class ApiKeys {
  static const SEARCH_NEW_SUFFIX = "/mobuser/podcast/searchv2";

  static const TRENDING_PODCAST_SUFFIX = "/mobuser/podcast/trending";
  static const TOP_50_PODCAST_SUFFIX = "/mobuser/podcast/top50";
  static const TOP_10_PODCAST_SUFFIX = "/mobuser/podcast/top50";
  static const WHERE_U_STOPED_SUFFIX = "/mobuser/podcast/top50";

  static const CATEGORIES_SUFFIX_PAGINATION = "/category/list";

  // static const COLLECTIONS_LIST_SUFFIX = "/mobuser/podcast/playlist";
  static const COLLECTIONS_LIST_SUFFIX = "/mobuser/folderlist";
  static const CREATE_COLLECTION_SUFFIX = "/mobuser/playlistfolder";

  static const DELETE_PODCAST_FROM_COLLECTION_SUFFIX =
      "/mobuser/playlistfolder/file";

  // static const YOUR_LISTENED_PODCAST_SUFFIX="/mobuser/podcast/listened";
  static const YOUR_LISTENED_PODCAST_SUFFIX = "/mobuser/podcast/listenedlist";
  static const CATOGEROY_PODCAST_SUFFIX = "/mobuser/podcast/category";
  static const TOP_50_RJS_SUFFIX = "/mobuser/rj/top50";
  static const SEND_OTP_SUFFIX = "/sms/otp";
  static const SEND_NEW_OTP_SUFFIX = "/sms/newotp";

  static const USER_RATING_SUFFIX = "/mobuser/rjrating";
  static const RJ_BYID_SUFFIX = "/mobuser/rj/view";

  static const ADS_SUFFIX = "/mobuser/addspot";

  static const FCM_TOKEN_SUFFIX = "/mobuser/fcm/create";

  static const RESET_PASSWORD_SUFFIX = "/mobuser/resetpassword";

  static const GENERATE_TOKEN = "/token/generate";

  static const DELETE_COMMENT = "/mobuser/comment";

  static const COUNTRIES_SUFFIX = "/country";

  static const POST_COMMENT = "/mobuser/podcast/comment";
  static const POST_COMMENT_REPLY = "/mobuser/comment/reply";
  static const POST_COMMENT_LDH = "/mobuser/podcast/commentldh";
  static const POST_REPLY_LDH = "/mobuser/podcast/replyldh";

  static const LIST_SHOWS_SUFFIX = "/mobuser/showslist";
  static const PODCASTS_BY_SHOW_SUFFIX = "/mobuser/shows/podcastlist";

  static const LIKE_DIS_LIKE_HEART_SUFFIX = "/mobuser/podcast/ldh";

  static const FAV_SUFFIX = "/mobuser/podcast/bookmark";
  static const FAV_LIST_SUFFIX = "/mobuser/podcast/bookmarklist";

  static const ADD_PODCAST_TO_COLLECTION_SUFFIX =
      "/mobuser/playlistfolder/podcast";

  static const PODCASTS_LIST_BY_COLLECTION_SUFFIX =
      "/mobuser/folder/podcastlist";

  static const PODCAST_BY_ID_SUFFIX = "/mobuser/podcastlist/byid";

  static const RJ_FILTER_CATEGORIES_SUFFIX = "/mobuser/rj/categorylist";

  static const CREATE_CHAT_SUFFIX = "/chat/create";
  static const CHAT_LIST_SUFFIX = "/chat/message/list";
  static const CHAT_UNREAD_SUFFIX = "/chat/message/unreadcount";
  static const UPDATE_CHAT_SUFFIX = "/chat/userunread/update";

  static const SUBSCRIBE_SUFFIX = "/mobuser/rj/subscribed";
  static const SUBSCRIBED_LIST_SUFFIX = "/mobuser/subscribedlistrj/podcast";

  static const FETCH_RPOFILE_SUFFIX = "/mobuser/profile/view";
  static const UPDATE_RPOFILE_SUFFIX = "/mobuser/profile/update";
  static const NOTIFICATIONS_SUFFIX = "/mobuser/notificationlist";
  static const VIEW_NOTIFICATIONS_SUFFIX = "/mobuser/notification/update";

  static const COMMENTS_REPORT = "/mobuser/reported/master";
  static const COMMENT_REPORTED = "/mobuser/reported";

  static Map<String, dynamic> getMobileQuery(String mobileNumber) {
    return {"mobile": mobileNumber};
  }

  //types are 'top' and 'trending'
  static Map<String, dynamic> getCategoryQuery(String catName, String type) {
    return {
      "category": catName,
      "type": type,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getCommentQuery(
      String podcastId, String message) {
    return {
      "podcast_id": podcastId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "description": message,
      "created_by": CommonNetworkApi().mobileUserName
    };
  }

  static Map<String, dynamic> getCommentReplyQuery(
      String commentId, String message) {
    return {
      "comment_id": commentId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "description": message
    };
  }

  static Map<String, dynamic> getCommentLDHQuery(
      String commentId, String type) {
    return {
      "comment_id": commentId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "type": type,
      "created_by": CommonNetworkApi().mobileUserName
    };
  }

  static Map<String, dynamic> getReplyLDHQuery(String replyId, String type) {
    return {
      "reply_id": replyId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "type": type
    };
  }

  static Map<String, dynamic> getDeleteCommentQuery(String commentId) {
    return {
      "comment_id": commentId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getDeleteReplyQuery(String replyId) {
    return {
      "reply_id": replyId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getShowsQuery(String catName) {
    return {
      "category": catName,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getCatQuery(String catName) {
    return {
      "category": catName,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getMobileUserQuery() {
    return {"mob_user_id": CommonNetworkApi().mobileUserId};
  }



  static Map<String, dynamic> getMobileUserQueryTEST() {
    return {"mob_user_id": "2022"};
  }

  static Map<String, dynamic> getProfileUpdateQuery(String key, String value) {
    return {"mob_user_id": CommonNetworkApi().mobileUserId, key: value};
  }

  static Map<String, dynamic> getFavouriteQuery(
    String podcastId,
  ) {
    return {
      "podcast_id": podcastId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "type": "favourite"
    };
  }

  static Map<String, dynamic> getPodcastsByShowIdQuery(
    String showId,
  ) {
    return {"shows_id": showId, "mob_user_id": CommonNetworkApi().mobileUserId};
  }

  static Map<String, dynamic> getListenLaterQuery(
    String podcastId,
  ) {
    return {
      "podcast_id": podcastId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "type": "listenlater"
    };
  }

  static Map<String, dynamic> getUserRatingQuery(String rating, String rjId) {
    return {
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "rj_user_id": rjId,
      "rating_value": rating
    };
  }

  static Map<String, dynamic> getAddPodcastToCollectionQuery(
      List<String> podcastIds, String collectionId) {
    return {"podcast_id": podcastIds, "mob_playlistfolder_id": collectionId};
  }

  static Map<String, dynamic> getResetPasswordQuery(
      String mobileNumber, String password, String resetToken) {
    return {"mobile": mobileNumber, "password": password, "token": resetToken};
  }

  /*static Map<String, dynamic> getAddPodcastToCollectionQuery(
      String podcastId, String collectionId) {
    return {"podcast_id": podcastId, "mob_playlistfolder_id": collectionId};
  }*/

  static Map<String, dynamic> getPodcastsByPodcastIdQuery(String podcastId) {
    return {
      "podcast_id": podcastId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getPodcastsByCollectionIdQuery(String folderId) {
    return {
      "folder_id": folderId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> getFavouriteListQuery(String type) {
    return {"mob_user_id": CommonNetworkApi().mobileUserId, "type": type};
  }

  static Map<String, dynamic> getLdhQuery(String podcastId, String type) {
    //ldh means - Like,DisLike,Heart
    return {
      "podcast_id": podcastId,
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "type": type
    };
  }

  static Map<String, dynamic> createCollectionQuery(
    String collectionName,
  ) {
    return {
      "name": collectionName,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> deleteCollectionQuery(
    String collectionId,
  ) {
    return {
      "folder_id": collectionId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  static Map<String, dynamic> deletePodcastQuery(
    String folderFileId ) {
    return {
      "folder_file_id": folderFileId,
      "mob_user_id": CommonNetworkApi().mobileUserId
    };
  }

  /*static Map<String, dynamic> getMobileUserQuery(String userId) {
    return {"mob_user_id": userId};
  }*/

  static Map<String, dynamic> getRjUserQuery(String userId) {
    return {"user_id": userId};
  }

  static Map<String, dynamic> getRjByRjIdQuery(String rjId) {
    return {"rj_user_id": rjId, "mob_user_id": CommonNetworkApi().mobileUserId};
  }

  static Map<String, dynamic> getSubscribedQuery(String rjId) {
    return {"rj_user_id": rjId, "mob_user_id": CommonNetworkApi().mobileUserId};
  }

  static Map<String, dynamic> getChatListQuery(String rjId) {
    return {"sender_id": rjId, "mob_user_id": CommonNetworkApi().mobileUserId};
  }

  static Map<String, dynamic> getFcmQuery(String token, String deviceType) {
    return {
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "device_type": deviceType,
      "device_id": token
    };
  }
}
