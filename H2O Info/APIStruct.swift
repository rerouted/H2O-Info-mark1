//
//  APIStruct.swift
//  H2O Info
//
//  Created by Sullivan, Ryan P on 7/11/18.
//  Copyright © 2018 Sullivan, Ryan P. All rights reserved.
//

import Foundation

public struct CallReponse: Codable {
    let text: String
    let status: String
    let value: Int
}

public struct ServerReponse: Codable {
    let temperature: Temperature
    let pump: [String:Pump]
    let time: Time
    let chlorinator: Chlorinator
    let circuit: [String:Circuit]
}

public struct Pump: Codable {
    let name: String
    let type: String
    let rpm: Int
    let gpm: Int
    let watts: Int
    let pumpName: String?
    let power: Int
}

public struct Temperature : Codable {
    let poolTemp: Int
    let airTemp: Int
    let poolSetPoint: Int
    let heaterActive: Int
}

public struct Time: Codable {
    let controllerTime: String
    let controllerDateStr: String
    let controllerDay: Int
    let controllerMonth: Int
    let controllerYear: Int
    let controllerDayOfWeekStr: String
    let controllerDayOfWeek: Int
    let automaticallyAdjustDST: Int
    let pump1Time: Int
    let pump2Time: Int
}

public struct Chlorinator: Codable {
    let saltPPM: Int
    let currentOutput: Int
    let outputPoolPercent: Int
    let installed: Int
    let outputSpaPercent: Int
    let superChlorinate: Int
    let status: String
    let name: String
}

public struct Circuit: Codable {
    let number: Int
    let name: String
    let numberStr: String
    let circuitFunction: String
    let status: Int
    let freeze: Int
    let macro: Int
    let delay: Int
    let friendlyName: String
    let light: Light?
}

public struct Light: Codable {
    let position: Int
    let colorStr: String
    let color: Int
    let colorSet: Int
    let colorSetStr: String
    let prevColor: Int
    let prevColorStr: String
    let colorSwimDelay: Int
    let mode: Int
    let modeStr: String
}
