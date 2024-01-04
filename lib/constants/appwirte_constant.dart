class AppWriteConstants {
  static const String projectID = '6574b0cbab31d5258614';
  static const String endPoint = 'https://cloud.appwrite.io/v1';
  static const String databaseID = '6575ee1193ab9ff673e9';
  static const String UserCollectionID = '657868521b30915d1853';
  static const String tweetCollectionID = '657c5defd0077ae2e0f8';
  static const String storageID = '658bd9389f64adfad889';

  static getImageURL(String imageID) =>
      "$endPoint/storage/buckets/$storageID/files/$imageID/view?project=$projectID";
}
