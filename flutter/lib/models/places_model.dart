class PlacesModel {
  int id;
  String slug;
  String citySlug;
  String display;
  String asciiDisplay;
  String cityName;
  String cityAsciiName;
  String state;
  String country;
  String lat;
  String long;
  String resultType;
  String popularity;
  int sortCriteria;

  PlacesModel(
      {this.id,
      this.slug,
      this.citySlug,
      this.display,
      this.asciiDisplay,
      this.cityName,
      this.cityAsciiName,
      this.state,
      this.country,
      this.lat,
      this.long,
      this.resultType,
      this.popularity,
      this.sortCriteria});

  PlacesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    citySlug = json['city_slug'];
    display = json['display'];
    asciiDisplay = json['ascii_display'];
    cityName = json['city_name'];
    cityAsciiName = json['city_ascii_name'];
    state = json['state'];
    country = json['country'];
    lat = json['lat'];
    long = json['long'];
    resultType = json['result_type'];
    popularity = json['popularity'];
    sortCriteria = json['sort_criteria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['city_slug'] = this.citySlug;
    data['display'] = this.display;
    data['ascii_display'] = this.asciiDisplay;
    data['city_name'] = this.cityName;
    data['city_ascii_name'] = this.cityAsciiName;
    data['state'] = this.state;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['result_type'] = this.resultType;
    data['popularity'] = this.popularity;
    data['sort_criteria'] = this.sortCriteria;
    return data;
  }
}
