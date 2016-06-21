//
//  Result.swift
//  WeatherApp
//
//  Created by Benedict Cohen on 21/06/2016.
//  Copyright © 2016 Benedict Cohen. All rights reserved.
//


enum Result<T> {

    case Error(ErrorType)
    case Success(T)
    
}
