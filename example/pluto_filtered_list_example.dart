import 'package:pluto_filtered_list/pluto_filtered_list.dart';

void main() {
  var filteredList = FilteredList<String>();
  // or set with initialList.
  // FilteredList(initialList: [1, 2, 3]);

  filteredList.add('one');

  print(filteredList); // ['one']

  filteredList.addAll(['two', 'three', 'four', 'five']);

  print(filteredList); // ['one', 'two', 'three', 'four', 'five']

  filteredList.setFilter((element) => element.length == 4); // ['four', 'five']

  print(filteredList.length); // 2

  print(filteredList[0]); // 'four'

  print(filteredList[1]); // 'five'

  filteredList.setFilter(null); // ['one', 'two', 'three', 'four', 'five']

  print(filteredList.length); // 5

  print(filteredList[0]); // 'one'

  print(filteredList[1]); // 'two'
}
