class Base<T> {
  int page;
  int perPage;
  int totalResults;
  List<T> photos;

  Base(this.page, this.perPage, this.totalResults, this.photos);
}
