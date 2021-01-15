## PlutoFilteredList - v0.0.2

[![codecov](https://codecov.io/gh/bosskmk/pluto_filtered_list/branch/main/graph/badge.svg)](https://codecov.io/gh/bosskmk/pluto_filtered_list)

<br>

A List where filters can be applied to the List and elements can be accessed or modified in that state.

<br>

### [Pub.Dev](https://pub.dev/packages/pluto_filtered_list)
> Check out how to install from the official distribution site.

<br>

### [Issue](https://github.com/bosskmk/pluto_filtered_list/issues)
> Report any questions or errors.

<br>

### Todo

* Not implemented yet.
  - removeRange, fillRange, replaceRange.

<br>

### Done

  ```dart
  var list = FilteredList(initialList: [1, 2, 3, 4, 5]);
  ```

* insert : If the filter is applied, the index at which the element is added is adjusted.
  ```dart
  list.setFilter((e) => e > 3); // [4, 5]
  list.insert(0, 35); // [35, 4, 5]

  list.setFilter(null); // [1, 2, 3, 35, 4, 5]
  list.insert(0, -1); // [-1, 1, 2, 3, 35, 4, 5]
  ```
* removeAt : If the filter is applied, the index at which the element is removed is adjusted.
  ```dart
  list.setFilter((e) => e > 3); // [4, 5]
  list.removeAt(0); // [5]

  list.setFilter(null); // [1, 2, 3, 5]
  list.removeAt(0); // [2, 3, 5]
  ```
* insertAll : If the filter is applied, the index at which the element is added is adjusted.
  ```dart
  list.setFilter((e) => e > 3); // [4, 5]
  list.insertAll(0, [35, 36, 37]); // [35, 36, 37, 4, 5]

  list.setFilter(null); // [1, 2, 3, 35, 36, 37, 4, 5]
  list.insertAll(0, [-1, -2, -3]); // [-1, -2, -3, 1, 2, 3, 35, 36, 37, 4, 5]
  ```
* remove : If the filter has been applied, the element is removed from the range where the filter is applied.
  ```dart
  list.setFilter((e) => e > 3); // [4, 5]
  var removedThree = list.remove(3); // false
  var removedFour = list.remove(4); // true
  
  list.setFilter(null); // [1, 2, 3, 5]
  var removedThreeAgain = list.remove(3); // true
  ```
* removeFromOriginal : Removes elements across the entire scope regardless of filter application.
  ```dart
  list.setFilter((e) => e > 3); // [4, 5]
  var removedThree = list.removeFromOriginal(3); // true
  var removedFour = list.removeFromOriginal(4); // true
  
  list.setFilter(null); // [1, 2, 5]
  var removedThreeAgain = list.removeFromOriginal(3); // false
  ```
* removeWhere : If the filter has been applied, the element is removed from the range where the filter is applied.
* removeWhereFromOriginal : Removes elements across the entire scope regardless of filter application.
* retainWhere : If the filter has been applied, the element is retained from the range where the filter is applied.
* retainWhereFromOriginal : Retains elements across the entire scope regardless of filter application.
* clear : If the filter has been applied, the element is cleared from the range where the filter is applied.
* clearFromOriginal : Clears elements across the entire scope.
* removeLast : The last element is deleted while the filter is applied.
* removeLastFromOriginal : Delete the last element from the entire list.
* shuffle : Shuffles elements across the entire scope.

### Example
```dart
/// Create an empty list.
var filteredList = FilteredList<String>();

/// Contains the methods of List.
/// add, remove, clear, where, ...
filteredList.add('one');

print(filteredList); // ['one']

filteredList.addAll(['two', 'three', 'four', 'five']);

print(filteredList); // ['one', 'two', 'three', 'four', 'five']

/// Set the filter.
/// Implement a callback function that returns a bool type.
/// The example filters a string of length 4, as shown below.
filteredList.setFilter((element) => element.length == 4); // ['four', 'five']

/// Only elements of length 4 in the list were filtered out,
/// resulting in the length of the list being 2.
print(filteredList.length); // 2

print(filteredList[0]); // 'four'

print(filteredList[1]); // 'five'

/// You can turn off the filter by passing null to setFilter.
filteredList.setFilter(null); // ['one', 'two', 'three', 'four', 'five']

/// The filter is cleared, so the length of the original list is 5.
print(filteredList.length); // 5

print(filteredList[0]); // 'one'

print(filteredList[1]); // 'two'
```

<br>

### Pluto series
> develop packages that make it easy to develop admin pages or CMS with Flutter.
* [PlutoGrid](https://github.com/bosskmk/pluto_grid)
* [PlutoMenuBar](https://github.com/bosskmk/pluto_menu_bar)