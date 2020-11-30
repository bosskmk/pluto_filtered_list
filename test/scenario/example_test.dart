import 'package:pluto_filtered_list/pluto_filtered_list.dart';
import 'package:test/test.dart';

void main() {
  FilteredList<int> list;

  setUp(() {
    list = FilteredList(initialList: [1, 2, 3, 4, 5]);
  });

  test('remove', () {
    list.setFilter((e) => e > 3); // [4, 5]
    expect(list, [4, 5]);

    var removedThree = list.remove(3); // false
    expect(removedThree, isFalse);

    var removedFour = list.remove(4); // true
    expect(removedFour, isTrue);

    list.setFilter(null); // [1, 2, 3, 5]
    expect(list, [1, 2, 3, 5]);

    var removedThreeAgain = list.remove(3); // true
    expect(removedThreeAgain, isTrue);
  });

  test('removeFromOriginal', () {
    list.setFilter((e) => e > 3); // [4, 5]
    expect(list, [4, 5]);

    var removedThree = list.removeFromOriginal(3); // true
    expect(removedThree, isTrue);

    var removedFour = list.removeFromOriginal(4); // true
    expect(removedFour, isTrue);

    list.setFilter(null); // [1, 2, 5]
    expect(list, [1, 2, 5]);

    var removedThreeAgain = list.removeFromOriginal(3); // false
    expect(removedThreeAgain, isFalse);
  });
}