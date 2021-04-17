//
//  TagsModel.swift
//  FlickrSwift
//
//  Created by Владислав Мокров on 12.04.2021.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let period: String
    let count: Int
    let hottags: Hottags
    let stat: String
}

// MARK: - Hottags
struct Hottags: Codable {
    let tag: [Tag]
}

// MARK: - Tag
struct Tag: Codable {
    let content: String
    let thmData: ThmData
    enum CodingKeys: String, CodingKey {
        case content = "_content"
        case thmData = "thm_data"
    }
}

// MARK: - ThmData
struct ThmData: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, secret, server: String
    let farm: Int
    let owner: String
    let username: JSONNull?
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension Welcome {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Welcome.self, from: data)
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

