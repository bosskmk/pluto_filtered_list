import 'package:pluto_filtered_list/pluto_filtered_list.dart';

void main() {
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
}
