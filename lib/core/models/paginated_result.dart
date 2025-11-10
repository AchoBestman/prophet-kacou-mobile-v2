// lib/app/data/models/paginated_result.dart

class PaginatedResult<T> {
  final List<T> data;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResult({
    required this.data,
    required this.total,
    required this.page,
    required this.perPage,
  })  : totalPages = (total / perPage).ceil(),
        hasNextPage = page < (total / perPage).ceil(),
        hasPreviousPage = page > 1;

  @override
  String toString() {
    return 'PaginatedResult(items: ${data.length}, page: $page/$totalPages, total: $total)';
  }
}