//
//  Station.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/15.
//

import Foundation

struct StationData: Codable {
    var Stations: [Stations]
}


struct Stations: Codable {
    var StationID: String
    var StationName: StationName
    var StationAddress: String
}


