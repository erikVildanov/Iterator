import Foundation

public struct Item: Decodable {
    public let id: Int
    public let time: Date
    public let name: String
}
