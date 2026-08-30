extension ListX<T> on List<T> {
  bool updateWhere(
    bool Function(T item) test,
    T newItem,
  ) {
    final index = indexWhere(test);
    if (index == -1) return false;

    this[index] = newItem;
    return true;
  }
}
