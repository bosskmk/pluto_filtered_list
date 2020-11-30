part of '../pluto_filtered_list.dart';

/// Callback function to set in [setFilter].
typedef FilteredListFilter<E> = bool Function(E element);

/// Properties and methods extended to [List].
abstract class AbstractFilteredList<E> implements ListBase<E> {
  /// Pure unfiltered list.
  List<E> get originalList;

  /// Filtered list. Same as [originalList] if filter is null.
  List<E> get filteredList;

  /// Whether to set a filter.
  bool get hasFilter;

  /// Method to set the filter.
  void setFilter(FilteredListFilter<E> filter);

  /// [List.remove] method removes an element from the filtered scope.
  /// Use removeFromOriginal to remove elements from all list scopes.
  bool removeFromOriginal(Object element);

  /// [List.removeWhere] method removes an element from the filtered scope.
  /// Use removeWhereFromOriginal to remove elements from all list scopes.
  void removeWhereFromOriginal(bool Function(E element) test);

  /// [List.retainWhere] method removes an element from the filtered scope.
  /// Use retainWhereFromOriginal to remove elements from all list scopes.
  void retainWhereFromOriginal(bool Function(E element) test);

  /// [List.clear] method removes an element from the filtered scope.
  /// Use clearFromOriginal to remove elements from all list scopes.
  void clearFromOriginal();
}

/// An extension class of List that applies a filter to a List and can access,
/// modify, or delete the list in that state.
class FilteredList<E> extends ListBase<E> implements AbstractFilteredList<E> {
  /// Pass the list to be set initially to initialList.
  /// If not passed, an empty list is created.
  ///
  /// ```dart
  /// FilteredList();
  /// FilteredList(initialList: [1, 2, 3]);
  /// ```
  FilteredList({
    List<E> initialList,
  }) : _list = initialList ?? [];

  final List<E> _list;

  FilteredListFilter<E> _filter;

  List<E> get _effectiveList => hasFilter ? _filteredList : _originalList;

  List<E> get _filteredList =>
      hasFilter ? _list.where(_filter).toList() : _list;

  List<E> get _originalList => _list;

  @override
  List<E> get originalList => [..._list];

  @override
  List<E> get filteredList => [..._filteredList];

  @override
  bool get hasFilter => _filter != null;

  @override
  int get length => _effectiveList.length;

  @override
  set length(int length) {
    _list.length = length;
  }

  @override
  void setFilter(FilteredListFilter<E> filter) => _filter = filter;

  @override
  void add(E element) => _list.add(element);

  @override
  void addAll(Iterable<E> iterable) => _list.addAll(iterable);

  @override
  void sort([int Function(E a, E b) compare]) {
    _isolated(() {
      super.sort(compare);
    });
  }

  @override
  bool remove(Object element) {
    if (_isNotInList(element, _effectiveList)) {
      return false;
    }

    return removeFromOriginal(element);
  }

  @override
  bool removeFromOriginal(Object element) {
    var result;

    _isolated(() {
      result = super.remove(element);
    });

    return result;
  }

  @override
  void removeWhere(bool Function(E element) test) {
    var list = _effectiveList;

    _isolated(() {
      super.removeWhere((E element) {
        return _isInList(element, list) && test(element);
      });
    });
  }

  @override
  void removeWhereFromOriginal(bool Function(E element) test) {
    _isolated(() {
      super.removeWhere(test);
    });
  }

  @override
  void retainWhere(bool Function(E element) test) {
    var list = _effectiveList;

    _isolated(() {
      super.retainWhere((E element) {
        var isInList = _isInList(element, list);
        return !isInList || (_isInList(element, list) && test(element));
      });
    });
  }

  @override
  void retainWhereFromOriginal(bool Function(E element) test) {
    _isolated(() {
      super.retainWhere(test);
    });
  }

  @override
  void clear() {
    var list = _effectiveList;

    _isolated(() {
      super.removeWhere((E element) {
        return _isInList(element, list);
      });
    });
  }

  @override
  void clearFromOriginal() {
    length = 0;
  }

  @override
  void shuffle([Random random]) {
    _isolated(() {
      super.shuffle(random);
    });
  }

  @override
  void removeRange(int start, int end) {
    // todo : implement
    throw UnimplementedError('removeRange');
  }

  @override
  void fillRange(int start, int end, [E fill]) {
    // todo : implement
    throw UnimplementedError('fillRange');
  }

  @override
  void replaceRange(int start, int end, Iterable<E> newContents) {
    // todo : implement
    throw UnimplementedError('replaceRange');
  }

  @override
  void insert(int index, E element) {
    // todo : If a filter is applied to the list, adjust the index position.
    _isolated(() {
      super.insert(index, element);
    });
  }

  @override
  E removeAt(int index) {
    // todo : If a filter is applied, it is only deleted from the list.
    // todo : If a filter is applied to the list, adjust the index position.
    E result;

    _isolated(() {
      result = super.removeAt(index);
    });

    return result;
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    // todo : If a filter is applied to the list, adjust the index position.
    _isolated(() {
      super.insertAll(index, iterable);
    });
  }

  @override
  E operator [](int index) {
    return _effectiveList[index];
  }

  @override
  void operator []=(int index, E value) {
    if (!hasFilter) {
      _list[index] = value;
      return;
    }

    final originalValue = _effectiveList[index];

    final valueIndexes = _list
        .asMap()
        .entries
        .map((e) => _compare(e.value, originalValue) ? e.key : null)
        .where((element) => element != null)
        .toList(growable: false);

    final found = valueIndexes.length;

    if (found == 1) {
      _list[valueIndexes[0]] = value;
    } else if (found > 1) {
      _list[valueIndexes.elementAt(index)] = value;
    } else {
      throw Exception(
          'With the filter applied, the value cannot be found in the list by that index.');
    }
  }

  bool _compare(dynamic a, dynamic b) {
    if (a is String || a is int || a is double || a is bool) {
      return a == b;
    } else if (a is Set || a is Map || a is List || a is Iterable) {
      return DeepCollectionEquality().equals(a, b);
    }

    return a == b;
  }

  void _isolated(void Function() callback) {
    if (!hasFilter) {
      callback();
      return;
    }

    final storeFilter = _filter;

    setFilter(null);

    callback();

    setFilter(storeFilter);
  }

  bool _isInList(Object element, List<E> list) {
    return list.firstWhere(
          (e) => e == element,
          orElse: () => null,
        ) !=
        null;
  }

  bool _isNotInList(Object element, List<E> list) {
    return !_isInList(element, list);
  }
}
