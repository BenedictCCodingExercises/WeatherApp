//
//  ForecastParser.swift
//  WeatherApp
//
//  Created by Benedict Cohen on 21/06/2016.
//  Copyright © 2016 Benedict Cohen. All rights reserved.
//

import Foundation


typealias JSON = [String: AnyObject]


class ForecastParser {

    enum Error: ErrorType {
        case InvalidJSON
    }


    func parseForecastResponse(responseData: NSData) throws -> [Forecast] {

        //Is the data valid?
        guard let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: []) else {
            throw ForecastParser.Error.InvalidJSON
        }

        //Get the forecasts node
        guard let forecastsJSON = json["list"] as? [JSON] else {
            throw ForecastParser.Error.InvalidJSON
        }

        return try forecastsJSON.map({ try self.forecastJSONToForecast($0) })
    }


    private func forecastJSONToForecast(json: JSON) throws -> Forecast {
    guard
        //This is *really* ugly. In a production app we'd create helper functions or use a library to parse JSON.
        let summary = (json["weather"] as? [JSON])?.first?["description"] as? String,
        let timestamp = json["dt"] as? NSTimeInterval,
        let temperature = (json["main"] as? JSON)?["temp"] as? Float
        else {
            throw Error.InvalidJSON
        }

        let date = NSDate(timeIntervalSince1970: timestamp)

        return Forecast(date: date, summary: summary, temperature: temperature)
    }
}
