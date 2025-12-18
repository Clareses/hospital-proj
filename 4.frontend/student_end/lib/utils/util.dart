Map<String, Object> toObjectMap(Map<String, dynamic> input) {
  final result = <String, Object>{};
  input.forEach((key, value) {
    if (value != null) {
      result[key] = value as Object;
    }
  });
  return result;
}
