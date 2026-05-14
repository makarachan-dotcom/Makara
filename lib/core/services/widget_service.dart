import 'package:shared_preferences/shared_preferences.dart';

/// Service for providing data to iOS Home Screen Widgets.
///
/// iOS WidgetKit integration requires:
/// 1. A Widget Extension target in the Xcode project
/// 2. App Groups capability for shared data between app and widget
/// 3. Swift code in the widget extension reading from UserDefaults
///
/// This service writes widget data to SharedPreferences/UserDefaults
/// via App Groups, which the widget extension reads from.
class WidgetService {
  static const String _appGroupId = 'group.com.makara.makarapremiumapp';
  static const String _nextAlarmKey = 'widget_next_alarm';
  static const String _nextStudyKey = 'widget_next_study';
  static const String _studyStreakKey = 'widget_study_streak';

  /// Update next alarm time for widget display
  static Future<void> updateNextAlarm({
    required int hour,
    required int minute,
    String? label,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    await prefs.setString(_nextAlarmKey, '$timeStr|${label ?? ''}');
  }

  /// Update next study session for widget display
  static Future<void> updateNextStudy({
    required String subject,
    required int hour,
    required int minute,
    required int durationMinutes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    await prefs.setString(_nextStudyKey, '$subject|$timeStr|$durationMinutes');
  }

  /// Update study streak for widget display
  static Future<void> updateStudyStreak(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_studyStreakKey, days);
  }

  /// Get app group ID for iOS configuration
  static String get appGroupId => _appGroupId;
}

/// iOS Widget Extension Swift Template (for reference):
///
/// ```swift
/// // MakaraWidget.swift — add as Widget Extension target in Xcode
///
/// import WidgetKit
/// import SwiftUI
///
/// struct MakaraWidgetEntry: TimelineEntry {
///     let date: Date
///     let nextAlarm: String
///     let nextStudy: String
/// }
///
/// struct Provider: TimelineProvider {
///     func placeholder(in context: Context) -> MakaraWidgetEntry {
///         MakaraWidgetEntry(date: Date(), nextAlarm: "06:30", nextStudy: "គណិតវិទ្យា")
///     }
///
///     func getSnapshot(in context: Context, completion: @escaping (MakaraWidgetEntry) -> Void) {
///         let entry = loadEntry()
///         completion(entry)
///     }
///
///     func getTimeline(in context: Context, completion: @escaping (Timeline<MakaraWidgetEntry>) -> Void) {
///         let entry = loadEntry()
///         let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(900)))
///         completion(timeline)
///     }
///
///     func loadEntry() -> MakaraWidgetEntry {
///         let defaults = UserDefaults(suiteName: "group.com.makara.makarapremiumapp")
///         let alarm = defaults?.string(forKey: "widget_next_alarm") ?? "--:--"
///         let study = defaults?.string(forKey: "widget_next_study") ?? ""
///         return MakaraWidgetEntry(date: Date(), nextAlarm: alarm, nextStudy: study)
///     }
/// }
///
/// struct MakaraWidgetView: View {
///     var entry: MakaraWidgetEntry
///
///     var body: some View {
///         VStack(alignment: .leading, spacing: 8) {
///             HStack {
///                 Image(systemName: "alarm")
///                     .foregroundColor(.secondary)
///                 Text(entry.nextAlarm.split(separator: "|").first ?? "--:--")
///                     .font(.title2).bold()
///             }
///             if !entry.nextStudy.isEmpty {
///                 HStack {
///                     Image(systemName: "book")
///                         .foregroundColor(.secondary)
///                     Text(entry.nextStudy.split(separator: "|").first ?? "")
///                         .font(.caption)
///                 }
///             }
///         }
///         .padding()
///     }
/// }
///
/// @main
/// struct MakaraWidget: Widget {
///     let kind = "MakaraWidget"
///     var body: some WidgetConfiguration {
///         StaticConfiguration(kind: kind, provider: Provider()) { entry in
///             MakaraWidgetView(entry: entry)
///         }
///         .configurationDisplayName("ម៉ាការ៉ា")
///         .description("រោទ៍ និងកាលវិភាគសិក្សា")
///         .supportedFamilies([.systemSmall, .systemMedium])
///     }
/// }
/// ```
