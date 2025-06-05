// lib/search_history.dart
import 'package:hive/hive.dart';

class SearchHistory {
  final Box box;

  SearchHistory(this.box);

  List<String> getHistory() {
    return box.get('history', defaultValue: <String>[])!.cast<String>();
  }

  void addHistoryItem(String item) {
    final history = getHistory();
    if (!history.contains(item)) { // Avoid duplicates
      history.add(item);
      box.put('history', history);
    }
  }

  void deleteHistoryItem(int index) {
    final history = getHistory();
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      box.put('history', history);
    }
  }

  void clearHistory() {
    box.put('history', <String>[]);
  }
}
