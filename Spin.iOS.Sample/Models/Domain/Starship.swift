//
//  Starship.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

struct Starship: Decodable {
    let name: String
    let model: String
    let starshipClass: String
    let manufacturer: String
    let costInCredits: String
    let length: String
    let crew: String
    let passengers: String
    let maxAtmospheringSpeed: String
    let hyperdriveRating: String
    let mglt: String
    let cargoCapacity: String
    let films: [String]
    let pilots: [String]
    let url: String
    let created: String
    let edited: String
    
    enum CodingKeys: String, CodingKey {
            case name
            case model
            case starshipClass = "starship_class"
            case manufacturer
            case costInCredits = "cost_in_credits"
            case length
            case crew
            case passengers
            case maxAtmospheringSpeed = "max_atmosphering_speed"
            case hyperdriveRating = "hyperdrive_rating"
            case mglt = "MGLT"
            case cargoCapacity = "cargo_capacity"
            case films
            case pilots
            case url
            case created
            case edited
    }
}
