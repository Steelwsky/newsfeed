enum DataSource { cnbc, nytimes }

class RssDataSourceModel {
  RssDataSourceModel({
    this.source,
    this.link,
    this.longName,
    this.shortName,
  });

  final DataSource source;
  final String link;
  final String longName;
  final String shortName;
}

class RssDataSourcesList {
  static List<RssDataSourceModel> _sources;

  RssDataSourcesList() {
    _sources = [
      RssDataSourceModel(
          source: DataSource.cnbc,
          link: 'https://www.cnbc.com/id/100727362/device/rss/rss.html',
          longName: 'CNBC International',
          shortName: 'CNBC'),
      RssDataSourceModel(
          source: DataSource.nytimes,
          link: 'https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml',
          longName: 'The New York Times',
          shortName: 'NY Times'),
    ];
  }

  List<RssDataSourceModel> get sources => _sources;
}
