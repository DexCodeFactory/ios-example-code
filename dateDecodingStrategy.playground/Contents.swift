import UIKit

struct DateModel: Codable {
    let expiry_date: Date
    let empty_date: Date
}

extension DateFormatter {
    static var apiDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}

let jsonData =
"""
{
   "expiry_date": "2020-11-02T02:50:12.208Z",
   "empty_date": ""
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
//decoder.dateDecodingStrategy = .formatted(.apiDateFormatter)
decoder.dateDecodingStrategy = .custom { decoder in
    let dateString = try decoder.singleValueContainer().decode(String.self)
    if let date = DateFormatter.apiDateFormatter.date(from: dateString) {
        return date
    } else {
        return .distantFuture
    }
}

do {
    let stat: DateModel = try decoder.decode(DateModel.self, from: jsonData)
    print(stat.expiry_date)
    print(stat.empty_date)
} catch {
    print(error)
}
