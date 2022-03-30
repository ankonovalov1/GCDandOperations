import Foundation

struct Heroes: Codable {
    var results: [Hero]?
}

struct Hero: Codable {
    var name: String?
    var gender: String?
}
