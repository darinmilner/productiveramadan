// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:uuid/uuid.dart';
// import 'package:state_notifier/state_notifier.dart';
//
// //var _uuid = Uuid();
//
// class Day {
//   bool hasSalat;
//   bool hasTarawih;
//   int numberOfSunnahRakat;
//   int minutesReadQuran;
//
//   bool isComplete;
//
//   Day(
//       {
//         this.hasSalat = false,
//       this.hasTarawih = false,
//       this.numberOfSunnahRakat = 0,
//       this.minutesReadQuran = 0
//       });
//
//   @override
//   String toString() {
//     return "Daily Ramadan Tasks (Five time Salat: $hasSalat, tarawih: $hasTarawih)";
//   }
// }
//
// class DayList extends StateNotifier {
//   DayList([List<Day> state]) : super(state ?? []);
//
//   bool isComplete;
//   void toggle(String item) {
//     state[item] = !state[item];
//   }
//
// // final completeProvider = StateNotifierProvider<DayList>((ref)  {
// // // DayList dayListValue(List values)
// // });
//
// final dayListProvider = StateNotifierProvider<DayList>((ref) {
//   return DayList([
//     Day(
//         hasSalat: false,
//         hasTarawih: false,
//         numberOfSunnahRakat: 0,
//         minutesReadQuran: 0),
//   ]);
//
//
//
// });
