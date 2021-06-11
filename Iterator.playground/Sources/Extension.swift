import Foundation

extension DateFormatter {
  static let HHmmss: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale.current
    return formatter
  }()
}
