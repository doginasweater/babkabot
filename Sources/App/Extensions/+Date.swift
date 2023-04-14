import Foundation

extension DateFormatter {
  static let MMddyy: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "MM/dd/yy"

    return formatter
  }()
}

extension Date {
  func format(using formatter: DateFormatter) -> String {
    formatter.string(from: self)
  }
}
