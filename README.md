## PlutoFilteredList - v0.0.1-alpha.0

<br>

A List where filters can be applied to the List and elements can be accessed or modified in that state.

<br>

### [Pub.Dev](https://pub.dev/packages/pluto_filtered_list)
> Check out how to install from the official distribution site.

<br>

### [Issue](https://github.com/bosskmk/pluto_filtered_list/issues)
> Report any questions or errors.

<br>

### Example
```dart
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
```

<br>

### Pluto series
> develop packages that make it easy to develop admin pages or CMS with Flutter.
* [PlutoGrid](https://github.com/bosskmk/pluto_grid)
* [PlutoMenuBar](https://github.com/bosskmk/pluto_menu_bar)