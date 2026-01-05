import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    let appGroupId = "group.com.schedulelab.dutytable"

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            dateString: "날짜 정보 없음",
            todayDuties: "-",
            tomorrowDate: "내일",
            tomorrowDuties: "-",
            calendarJson: "{}",
            firstDayOffset: "0",
            lastDay: "31",
            currentMonthText: "데이터 불러오는 중",
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let sharedDefaults = UserDefaults(suiteName: appGroupId)
        return SimpleEntry(
            date: Date(),
            dateString: sharedDefaults?.string(forKey: "date_key") ?? "1월 3일 (토)",
            todayDuties: sharedDefaults?.string(forKey: "today_duties") ?? "데이",
            tomorrowDate: sharedDefaults?.string(forKey: "tomorrow_date") ?? "1월 4일 (일)",
            tomorrowDuties: sharedDefaults?.string(forKey: "tomorrow_duties") ?? "이브닝",
            calendarJson: sharedDefaults?.string(forKey: "calendar_json") ?? "{}",
            firstDayOffset: sharedDefaults?.string(forKey: "first_day_offset") ?? "0",
            lastDay: sharedDefaults?.string(forKey: "last_day") ?? "31",
            currentMonthText: sharedDefaults?.string(forKey: "current_month_text") ?? "2026년 1월",
            configuration: configuration
        )
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let sharedDefaults = UserDefaults(suiteName: appGroupId)
        let entry = SimpleEntry(
            date: Date(),
            dateString: sharedDefaults?.string(forKey: "date_key") ?? "",
            todayDuties: sharedDefaults?.string(forKey: "today_duties") ?? "일정 없음",
            tomorrowDate: sharedDefaults?.string(forKey: "tomorrow_date") ?? "",
            tomorrowDuties: sharedDefaults?.string(forKey: "tomorrow_duties") ?? "",
            calendarJson: sharedDefaults?.string(forKey: "calendar_json") ?? "{}",
            firstDayOffset: sharedDefaults?.string(forKey: "first_day_offset") ?? "0",
            lastDay: sharedDefaults?.string(forKey: "last_day") ?? "31",
            currentMonthText: sharedDefaults?.string(forKey: "current_month_text") ?? "",
            configuration: configuration
        )
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let dateString: String
    let todayDuties: String
    let tomorrowDate: String
    let tomorrowDuties: String
    let calendarJson: String
    let firstDayOffset: String
    let lastDay: String
    let currentMonthText: String
    let configuration: ConfigurationAppIntent
}

struct MyWidgetEntryView : View {
  var entry: Provider.Entry
      @Environment(\.widgetFamily) var family

      var body: some View {
          // 전체를 GeometryReader로 감싸면 정확한 크기 계산이 가능하지만,
          // 여기서는 가독성을 위해 VStack의 maxWidth를 활용합니다.
          VStack(alignment: .leading, spacing: 0) {
              switch family {
              case .systemSmall: smallView
              case .systemMedium: mediumView
              case .systemLarge: largeView
              default: smallView
              }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity) // 프레임 확장
          .containerBackground(.fill.tertiary, for: .widget)
      }

    var smallView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.dateString)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.blue)
            Divider().padding(.vertical, 2)
            ForEach(entry.todayDuties.components(separatedBy: ","), id: \.self) { duty in
                Text("• \(duty.trimmingCharacters(in: .whitespaces))")
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(10)
    }

    var mediumView: some View {
        HStack(alignment: .top, spacing: 12) {
            smallView
            Divider().padding(.vertical, 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.tomorrowDate)
                    .font(.system(size: 11, weight: .bold))
                    
                Divider().padding(.vertical, 2)
                ForEach(entry.tomorrowDuties.components(separatedBy: ","), id: \.self) { duty in
                    Text("• \(duty.trimmingCharacters(in: .whitespaces))")
                        .font(.system(size: 13))
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding(.trailing, 10).padding(.vertical, 10)
        }
    }

  @ViewBuilder
  var largeView: some View {
      let calendarData = decodeCalendar(entry.calendarJson)
      let offset = Int(entry.firstDayOffset) ?? 0
      let lastDay = Int(entry.lastDay) ?? 31
      let todayDay = Calendar.current.component(.day, from: entry.date)
      
      // 1. 전체 슬롯 계산 (빈 칸 + 날짜)
      let totalSlots: [Int?] = Array(repeating: nil, count: offset) + Array(1...lastDay).map { $0 }
      
      // 2. 7개씩 묶어서 주(Week) 단위로 분리
      let weeks: [[Int?]] = stride(from: 0, to: totalSlots.count, by: 7).map {
          Array(totalSlots[$0..<min($0 + 7, totalSlots.count)])
      }

      VStack(spacing: 0) {
          // --- [헤더 섹션] ---
          VStack(spacing: 4) {
              Text(entry.currentMonthText)
                  .font(.system(size: 18, weight: .black))
                  .foregroundColor(.primary)
              
              HStack(spacing: 0) {
                  let days = ["일", "월", "화", "수", "목", "금", "토"]
                  ForEach(days, id: \.self) { d in
                      Text(d)
                          .font(.system(size: 11, weight: .bold))
                          .frame(maxWidth: .infinity)
                          .foregroundColor(d == "일" ? .red : d == "토" ? .blue : .secondary)
                  }
              }
          }
          .padding(.top, 12)
          .padding(.bottom, 8)
          .padding(.horizontal, 8)
          // ------------------

          // --- [달력 본문 섹션] ---
          GeometryReader { geometry in
              let rowCount = CGFloat(weeks.count)
              let cellHeight = geometry.size.height / rowCount
              
              VStack(spacing: 0) {
                  ForEach(0..<weeks.count, id: \.self) { weekIndex in
                      HStack(spacing: 0) {
                          let week = weeks[weekIndex]
                          
                          ForEach(0..<7, id: \.self) { dayIndex in
                              Group {
                                  if dayIndex < week.count, let day = week[dayIndex] {
                                      // 실제 날짜 칸
                                      VStack(spacing: 2) {
                                          Text("\(day)")
                                              .font(.system(size: 11, weight: .bold))
                                              .foregroundColor(day == todayDay ? .white : .primary)
                                              .frame(width: 20, height: 20)
                                              .background(
                                                  Circle().fill(day == todayDay ? Color.accentColor : Color.clear)
                                              )
                                          
                                          if let rawData = calendarData["\(day)"] {
                                              let info = parseDutyData(rawData)
                                              Text(info.title)
                                                  .font(.system(size: 9, weight: .heavy))
                                                  .lineLimit(1)
                                                  .frame(maxWidth: .infinity)
                                                  .frame(height: 16)
                                                  .background(info.color)
                                                  .cornerRadius(3)
                                                  .padding(.horizontal, 2)
                                          } else {
                                              Spacer().frame(height: 16)
                                          }
                                          Spacer(minLength: 0)
                                      }
                                  } else {
                                      // 빈 칸 (offset 및 마지막 주 남은 칸)
                                      Color.clear
                                  }
                              }
                              .frame(maxWidth: .infinity)
                              .frame(height: cellHeight, alignment: .top)
                          }
                      }
                  }
              }
              // 전체 그리드를 상단 정렬하여 첫 줄이 밀리지 않게 함
              .frame(maxHeight: .infinity, alignment: .top)
          }
          .padding(.horizontal, 5)
          .padding(.bottom, 6)
      }
  }

    func decodeCalendar(_ json: String) -> [String: String] {
        guard let data = json.data(using: .utf8) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data) as? [String: String]) ?? [:]
    }

    func parseDutyData(_ raw: String) -> (title: String, color: Color) {
        let parts = raw.components(separatedBy: "|")
        return (parts.first ?? "", Color(hex: parts.last ?? "#808080"))
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DutyTable 위젯")
        .description("오늘과 이번 달 일정을 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
