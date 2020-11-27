part of '../pluto_filtered_list.dart';

typedef FilteredListFilter<E> = bool Function(E element);

abstract class AbstractFilteredList<E> implements ListBase<E> {
  List<E> get originalList;

  List<E> get filteredList;

  bool get hasFilter;

  void setFilter(FilteredListFilter<E> filter);
}

class FilteredList<E> extends ListBase<E> implements AbstractFilteredList<E> {
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
    // todo : If a filter is applied, it is only deleted from the list.
    var result;

    _isolated(() {
      result = super.remove(element);
    });

    return result;
  }

  @override
  void removeWhere(bool Function(E element) test) {
    // todo : If a filter is applied, it is only deleted from the list.
    _isolated(() {
      super.removeWhere(test);
    });
  }

  @override
  void retainWhere(bool Function(E element) test) {
    // todo : If a filter is applied, it is only deleted from the list.
    _isolated(() {
      super.retainWhere(test);
    });
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
}
