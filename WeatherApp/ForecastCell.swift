//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Benedict Cohen on 20/06/2016.
//  Copyright © 2016 Benedict Cohen. All rights reserved.
//

import UIKit


class ForecastCell: UITableViewCell {

    //Sub views
    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var summaryLabel: UILabel!
    

    static let reuseIdentifier = "ForecastCell"

}
