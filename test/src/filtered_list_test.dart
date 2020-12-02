import 'package:pluto_filtered_list/pluto_filtered_list.dart';
import 'package:test/test.dart';

void main() {
  group('Int List 를 짝수로 필터링.', () {
    List<int> originalList;

    FilteredList<int> list;

    setUp(() {
      originalList = [1, 2, 3, 4, 5, 6, 7, 8, 9];

      list = FilteredList(initialList: originalList);

      list.setFilter((element) => element % 2 == 0);
    });

    test(
      'originalList 가 필터 적용 되지 않은 값이 리턴 되어야 한다.',
      () {
        expect(list.originalList.length, 9);

        list.setFilter(null);

        expect(list.originalList.length, 9);
      },
    );

    test(
      'filteredList 가 필터 적용 된 값이 리턴 되어야 한다.',
      () {
        expect(list.filteredList.length, 4);

        list.setFilter(null);

        expect(list.filteredList.length, 0);
      },
    );

    test(
      'length 가 적용 되어야 한다.',
      () {
        expect(list.length, 4);

        list.setFilter(null);

        expect(list.length, 9);
      },
    );

    test(
      '특정 index 의 값을 리턴 해야 한다.',
      () {
        expect(list[0], 2);
        expect(list.first, 2);

        expect(list[3], 8);
        expect(list.last, 8);

        list.setFilter(null);

        expect(list[0], 1);
        expect(list.first, 1);

        expect(list[8], 9);
        expect(list.last, 9);
      },
    );

    test(
      'Destructuring 리턴 값이 반영 되어야 한다.',
      () {
        expect([...list], [2, 4, 6, 8]);

        list.setFilter(null);

        expect([...list], [1, 2, 3, 4, 5, 6, 7, 8, 9]);
      },
    );

    group('요소를 수정.', () {
      setUp(() {
        list[1] = 40;
      });

      test(
        '수정 한 요소가 반영 되어야 한다.',
        () {
          expect(list, [2, 40, 6, 8]);

          list.setFilter(null);

          expect(list, [1, 2, 3, 40, 5, 6, 7, 8, 9]);
        },
      );

      test(
        'sort 시 수정 한 요소가 반영 되어야 한다.',
        () {
          list.sort();

          expect(list, [2, 6, 8, 40]);

          final reverse = (a, b) => a < b ? 1 : (a > b ? -1 : 0);

          list.sort(reverse);

          expect(list, [40, 8, 6, 2]);

          list.setFilter(null);

          list.sort();

          expect(list, [1, 2, 3, 5, 6, 7, 8, 9, 40]);
        },
      );
    });

    group('요소를 추가.', () {
      setUp(() {
        list.add(10);
      });

      test(
        '추가 한 요소가 반영 되어야 한다.',
        () {
          expect(list, [2, 4, 6, 8, 10]);

          list.setFilter(null);

          expect(list, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
        },
      );

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 5);

          list.setFilter(null);

          expect(list.length, 10);
        },
      );
    });

    group('remove 로 요소를 삭제.', () {
      setUp(() {
        // filtering 된 상태에서 필터링 범위 밖의 리스트는 삭제 되지 않는다.
        var removeOne = list.remove(1);
        expect(removeOne, isFalse);

        var removeTwo = list.remove(2);
        expect(removeTwo, isTrue);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 8);

          expect(list, [1, 3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('removeFromOriginal 로 요소를 삭제.', () {
      setUp(() {
        var removeOne = list.removeFromOriginal(1);
        expect(removeOne, isTrue);

        var removeTwo = list.removeFromOriginal(2);
        expect(removeTwo, isTrue);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 7);

          expect(list, [3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('removeWhere 로 요소를 삭제.', () {
      setUp(() {
        // filtering 된 상태에서 필터링 범위 밖의 리스트는 삭제 되지 않는다.
        list.removeWhere((element) => element == 1);
        list.removeWhere((element) => element == 2);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 8);

          expect(list, [1, 3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('removeWhereFromOriginal 로 요소를 삭제.', () {
      setUp(() {
        list.removeWhereFromOriginal((element) => element == 1);
        list.removeWhereFromOriginal((element) => element == 2);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 7);

          expect(list, [3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('retainWhere 로 요소를 삭제.', () {
      setUp(() {
        // filtering 된 상태에서 필터링 범위 밖의 리스트는 삭제 되지 않는다.
        list.retainWhere((element) => element > 2);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 8);

          expect(list, [1, 3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('retainWhereFromOriginal 로 요소를 삭제.', () {
      setUp(() {
        list.retainWhereFromOriginal((element) => element > 2);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 7);

          expect(list, [3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('clear 로 요소를 삭제.', () {
      setUp(() {
        // filtering 된 상태에서 필터링 범위 밖의 리스트는 삭제 되지 않는다.
        list.clear();
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 0);

          expect(list, []);

          list.setFilter(null);

          expect(list.length, 5);

          expect(list, [1, 3, 5, 7, 9]);
        },
      );
    });

    group('clearFromOriginal 로 요소를 삭제.', () {
      setUp(() {
        list.clearFromOriginal();
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 0);

          expect(list, []);

          list.setFilter(null);

          expect(list.length, 0);

          expect(list, []);
        },
      );
    });

    group('removeLast 로 요소를 삭제.', () {
      setUp(() {
        list.removeLast();
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [2, 4, 6]);

          list.setFilter(null);

          expect(list.length, 8);

          expect(list, [1, 2, 3, 4, 5, 6, 7, 9]);
        },
      );
    });

    group('removeLastFromOriginal 로 요소를 삭제.', () {
      setUp(() {
        list.removeLastFromOriginal();
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 4);

          expect(list, [2, 4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 8);

          expect(list, [1, 2, 3, 4, 5, 6, 7, 8]);
        },
      );
    });

    group('shuffle 로 요소를 변경.', () {
      setUp(() {
        list.shuffle();
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 4);

          expect(list.contains(2), isTrue);
          expect(list.contains(4), isTrue);
          expect(list.contains(6), isTrue);
          expect(list.contains(8), isTrue);

          list.setFilter(null);

          expect(list.length, 9);

          expect(list.contains(1), isTrue);
          expect(list.contains(2), isTrue);
          expect(list.contains(3), isTrue);
          expect(list.contains(4), isTrue);
          expect(list.contains(5), isTrue);
          expect(list.contains(6), isTrue);
          expect(list.contains(7), isTrue);
          expect(list.contains(8), isTrue);
          expect(list.contains(9), isTrue);
        },
      );
    });

    test(
      'asMap.',
      () {
        final filteredMap = list.asMap();

        expect(filteredMap, {0: 2, 1: 4, 2: 6, 3: 8});

        list.setFilter(null);

        final map = list.asMap();

        expect(map, {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 8, 8: 9});
      },
    );

    group('insert 로 2 앞에  -2 요소를 추가.', () {
      setUp(() {
        list.insert(0, -2);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 5);

          expect(list, [-2, 2, 4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 10);

          expect(list, [1, -2, 2, 3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });

    group('removeAt 으로 4 요소를 삭제.', () {
      setUp(() {
        list.removeAt(1);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 3);

          expect(list, [2, 6, 8]);

          list.setFilter(null);

          expect(list.length, 8);

          expect(list, [1, 2, 3, 5, 6, 7, 8, 9]);
        },
      );

      test(
        '필터링 된 범위 밖의 index 접근 시 오류를 발생 시켜야 한다.',
        () {
          expect(list.length, 3);

          expect(() => list.removeAt(3), throwsA(TypeMatcher<RangeError>()));

          list.setFilter(null);

          expect(list.length, 8);

          expect(() => list.removeAt(8), throwsA(TypeMatcher<RangeError>()));
        },
      );
    });

    group('insertAll 로 2 앞에  [-3, -2] 요소를 추가.', () {
      setUp(() {
        list.insertAll(0, [-3, -2]);
      });

      test(
        'length 가 반영 되어야 한다.',
        () {
          expect(list.length, 5);

          expect(list, [-2, 2, 4, 6, 8]);

          list.setFilter(null);

          expect(list.length, 11);

          expect(list, [1, -3, -2, 2, 3, 4, 5, 6, 7, 8, 9]);
        },
      );
    });
  });
}
