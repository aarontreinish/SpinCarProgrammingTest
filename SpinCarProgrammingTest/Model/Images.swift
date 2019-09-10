//
//  Images.swift
//  SpinCarProgrammingTest
//
//  Created by Aaron Treinish on 9/4/19.
//  Copyright © 2019 Treinish. All rights reserved.
//

import Foundation

// MARK: - Images
struct Images: Codable {
    let value: [Value]

    enum CodingKeys: String, CodingKey {
        case value
    }
}

// MARK: - Value
struct Value: Codable {
    let thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnailUrl"
    }
}
