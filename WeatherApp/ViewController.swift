//
//  ViewController.swift
//  WeatherApp
//
//  Created by Benedict Cohen on 20/06/2016.
//  Copyright © 2016 Benedict Cohen. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource {

    var client = NetworkClient() //TODO: This should be passed in my the object that creates this object.


    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var refreshButton: UIBarButtonItem!


    private static let forecastTimeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE HH:mm"
        return formatter
    }()

    private var isFetching = false
    private var error: ErrorType?
    private var forecasts: [Forecast]?



    //MARK:- Instance life cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("Not implemented")
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "London 5 Day Forecast"
    }


    //MARK:- View life cycle

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        fetchForecast()
    }


    func refreshView() {
        //In a proper app we'd have to take the error into account too

        self.refreshButton.enabled = !isFetching
        self.tableView.reloadData()
    }


    //MARK:- Data fetching

    @IBAction func fetchForecast() {

        guard isFetching == false else {
            return
        }

        isFetching = true

        client.fetch5DayLondonForecast { result in
            switch result {
            case .Error(let error):
                //We don't clear the forecasts so that we can still show some data even if it's stale.
                self.error = error

            case .Success(let forecasts):
                self.forecasts = forecasts
                self.error = nil
            }
            self.isFetching = false
            self.refreshView()
        }

        refreshView()
    }


    //MARK:- TableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts?.count ?? 0
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ForecastCell.reuseIdentifier, forIndexPath: indexPath) as! ForecastCell
        let forecast = forecasts![indexPath.row]

        configureCell(cell, forForecast: forecast)

        return cell
    }


    func configureCell(cell: ForecastCell, forForecast forecast: Forecast) {
        cell.dateLabel!.text = ViewController.forecastTimeFormatter.stringFromDate(forecast.date)
        cell.summaryLabel!.text = String(NSString(format: "%@. %.0f°C", forecast.summary, forecast.temperature))
    }

}

