//
//  Images.swift
//  SpinCarProgrammingTest
//
//  Created by Aaron Treinish on 9/4/19.
//  Copyright © 2019 Treinish. All rights reserved.
//

import Foundation

// MARK: - Images
struct ImagesResult: Codable {
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case images = "value"
    }
}

// MARK: - Value
struct Image: Codable {
    let thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnailUrl"
    }
}
