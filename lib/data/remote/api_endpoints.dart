/// Centralised list of remote endpoints used by the data layer.
///
/// We use the public `dummyjson.com` API as a free mock backend that
/// returns realistic JSON payloads and supports token based auth.
class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/auth/me';

  /// We re-use `recipes` as our "bowl entries" collection. Each recipe is
  /// mapped to a [BowlEntry] in the DTO layer.
  static const String recipes = '$baseUrl/recipes';
  static String recipeById(String id) => '$baseUrl/recipes/$id';
  static const String addRecipe = '$baseUrl/recipes/add';
  static String usersByEmail(String email) =>
      '$baseUrl/users/filter?key=email&value=$email';
}
