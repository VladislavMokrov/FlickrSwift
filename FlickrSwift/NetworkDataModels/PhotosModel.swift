//
//  PhotosModel.swift
//  FlickrSwift
//
//  Created by Владислав Мокров on 15.04.2021.
//

import Foundation

// MARK: - Welcome
struct WelcomePh: Codable {
    let photos: PhotosPh
    let stat: String
}

// MARK: - Photos
struct PhotosPh: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [PhotoPh]
}

// MARK: - Photo
struct PhotoPh: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension WelcomePh {
    init(data: Data) throws {
        self = try JSONDecoder().decode(WelcomePh.self, from: data)
    }
}
