class Result<T> {
  final T? data;
  final String? error;

  Result({required this.data, required this.error});
  bool get isSuccess => data !=null;
}