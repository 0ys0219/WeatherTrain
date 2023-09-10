//
//  TrainData.swift
//  WeatherTrain
//
//  Created by 林育生 on 2023/9/11.
//

import Foundation

struct TrainData: Codable {
    var TrainTimetables: [TrainTimetables]
    
}

struct TrainTimetables: Codable {
    var StopTimes: [StopTimes]
}

struct StopTimes: Codable {
    var StationID: String
    var StationName: StationName
    var ArrivalTime: String
    var DepartureTime: String
}

struct StationName: Codable {
    var Zh_tw: String
    var En: String
}


