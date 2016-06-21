//
//  NetworkClient.swift
//  WeatherApp
//
//  Created by Benedict Cohen on 20/06/2016.
//  Copyright © 2016 Benedict Cohen. All rights reserved.
//

import Foundation


class NetworkClient {

    enum Error: ErrorType {
        case MissingResponseData
    }

    let session: NSURLSession


    init(session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration()) ) {
        self.session = session
    }


    func fetch5DayLondonForecast(completionHandler: (Result<[Forecast]>) -> Void ) {

        guard let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?q=London,uk&units=metric&mode=json&appid=71de97e02805ed8db40cdf68476ff979") else {
            fatalError("Unable to create URL")
        }

        let task = session.dataTaskWithURL(url) { (data, urlResponse, error) in
            //Did the request fail?
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Error(error))
                }
                return
            }

            //Attempt to parse the data
            guard let data = data else {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Error(NetworkClient.Error.MissingResponseData))
                }
                return
            }
            let forecasts: [Forecast]
            do {
                let parser = ForecastParser()
                forecasts = try parser.parseForecastResponse(data)
            } catch {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Error(error))
                }
                return
            }

            //Success!
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(.Success(forecasts))
            }
        }

        task.resume()
    }
}
