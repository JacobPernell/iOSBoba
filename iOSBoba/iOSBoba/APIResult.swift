//
//  APIResponse.swift
//  iOSBoba
//
//  Created by Jacob Pernell on 10/16/21.
//

import Foundation

// MARK: - APIResult
struct APIResult: Codable {
    let total: Int
    let businesses: [Business]
    let region: Region
}

// MARK: - Business
struct Business: Codable {
    let rating: Double?
    let price, phone, id, alias: String?
    let displayPhone: String?
    let isClosed: Bool?
    let categories: [Category]?
    let reviewCount: Int?
    let name: String?
    let url: String?
    let coordinates: Center?
    let imageURL: String?
    let distance: Double?
    let transactions: [String]?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case rating
        case price, phone, id, alias
        case displayPhone = "display_phone"
        case isClosed = "is_closed"
        case categories
        case reviewCount = "review_count"
        case name, url
        case coordinates
        case imageURL = "image_url"
        case distance
        case transactions
        case location
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    let city, country, state, zipCode: String
    let address1: String?
    let address2, address3: String?
    let displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case city, country, address2, address3, state, address1
        case zipCode = "zip_code"
        case displayAddress = "display_address"
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Center
}
