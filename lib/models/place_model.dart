class VisitedPlaceModel {
  final String placeId;
  final String distance;
  final String placeName;
  final String placeAddress;
  final String placeCategoryName;
  final String placeCategoryGroupCode;
  final String placeCategoryGroupName;

  VisitedPlaceModel.fromJson(Map<String, dynamic> json)
      : placeId = json["id"],
        distance = json["distance"],
        placeName = json["place_name"],
        placeAddress = json["address_name"],
        // 음식점 > 간식 > 제과,베이커리 이런 형식이기 때문에 필요에 따라 파싱
        placeCategoryName = json["category_name"],
        placeCategoryGroupCode = json["category_group_code"],
        placeCategoryGroupName = json["category_group_name"];

  Map<String, Object?> toJson() {
    return {
      'placeId': placeId,
      'distance': distance,
      'placeName': placeName,
      'placeAddress': placeAddress,
      'placeCategoryName': placeCategoryName,
      'placeCategoryGroupCode': placeCategoryGroupCode,
      'placeCategoryGroupName': placeCategoryGroupName,
    };
  }
}
