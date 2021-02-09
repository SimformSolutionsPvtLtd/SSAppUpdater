//
//  LookUpResponseModel.swift
//  SSAppUpdater
//
//  Created by Mansi Vadodariya on 20/10/20.
//  Copyright © 2020 Simform Solutions Pvt Ltd. All rights reserved.
//

import UIKit

internal struct LookUpResponseModel: Codable {

    let resultCount: Int?
    let results: [Result]?

}

/// Mapped response codable structure of API.
internal struct Result: Codable {

    let advisories: [String]?
    let appletvScreenshotUrls: [String]?
    let artistId: Int?
    let artistName: String?
    let artistViewUrl: String?
    let artworkUrl100: String?
    let artworkUrl512: String?
    let artworkUrl60: String?
    let averageUserRating: Int?
    let averageUserRatingForCurrentVersion: Int?
    let bundleId: String?
    let contentAdvisoryRating: String?
    let currency: String?
    let currentVersionReleaseDate: String?
    let descriptionField: String?
    let features: [String]?
    let fileSizeBytes: String?
    let formattedPrice: String?
    let genreIds: [String]?
    let genres: [String]?
    let ipadScreenshotUrls: [String]?
    let isGameCenterEnabled: Bool?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let kind: String?
    let languageCodesISO2A: [String]?
    let minimumOsVersion: String?
    let price: Float?
    let primaryGenreId: Int?
    let primaryGenreName: String?
    let releaseDate: String?
    let releaseNotes: String?
    let screenshotUrls: [String]?
    let sellerName: String?
    let sellerUrl: String?
    let supportedDevices: [String]?
    let trackCensoredName: String?
    let trackContentRating: String?
    let trackId: Int?
    let trackName: String?
    let trackViewUrl: String?
    let userRatingCount: Int?
    let userRatingCountForCurrentVersion: Int?
    let version: String?
    let wrapperType: String?

}
