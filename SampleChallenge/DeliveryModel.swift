//
//  DeliveryModel.swift
//  SampleChallenge
//
//  Created by ashif khan on 19/09/18.
//  Copyright © 2018 ashif khan. All rights reserved.
//

import Foundation
struct LocationModel: Codable {
    let lat: Double?
    let lng: Double?
    let address: String?
    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
        case address
    }
}
struct DeliveryModel: Codable {
    let id: Int?
    let description: String?
    let imageUrl: String?
    let location: LocationModel?
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case imageUrl
        case location
    }
}
