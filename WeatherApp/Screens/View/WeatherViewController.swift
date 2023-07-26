//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mani Yechuri on 2023/07/18.
//

import UIKit
import SystemConfiguration

class WeatherViewController: UIViewController {

    @IBOutlet weak var forecastDataView: UIView!
    @IBOutlet weak var currentTemperatureView: UIView!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var labelMaximumDegrees: UILabel!
    @IBOutlet weak var labelCurrentDegrees: UILabel!
    @IBOutlet weak var labelMinimumDegrees: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDegrees: UILabel!
    @IBOutlet weak var temperatureImage: UIImageView!
    
    private let currentWeatherViewModel = CurrentWeatherViewModel()
    private let forecastWeatherViewModel = ForecastWeatherViewModel()
    var weatherData = [DisplayForecastData]()
    lazy var currentColor = UIColor.CloudyColor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
}

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "WeatherTablecell", for: indexPath) as! WeatherTablecell
        cell.weatherData = weatherData[indexPath.row]
        cell.customView.backgroundColor = self.currentColor
        return cell
    }
    
}

extension WeatherViewController {
    func configuration(){
        forecastTableView.register(UINib(nibName: "WeatherTablecell", bundle: nil), forCellReuseIdentifier: "WeatherTablecell")
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.reloadData()
        initViewModel()
        observeEvent()
    }
    
    func initViewModel(){
        if NetworkMonitor.shared.isConnected {
            MyLocationManager.shared.getUserLocation { [weak self] location in
                self?.currentWeatherViewModel.fetchCurrentWeather(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
            }
        }else {
            self.initForecastWeatherModel()
            self.observeForecastEvents()
            let weatherData = DatabaseHelper.shared.fetchCurrentWeatherData()
            self.updateWeatherUI(currentWeather: weatherData[0])
        }
    }
    
    func initForecastWeatherModel() {
        if NetworkMonitor.shared.isConnected {
            MyLocationManager.shared.getUserLocation { [weak self] location in
                self?.forecastWeatherViewModel.fetchForecastWeatherData(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
            }
        }else {
            let data = DatabaseHelper.shared.fetchForecastWeatherData()
            self.weatherData = data
            self.forecastTableView.reloadData()
        }
    }
    
    func observeEvent(){
        currentWeatherViewModel.eventHandler = {[weak self] event in
            guard let self else {return}
            switch event {
            case .stopLoading : break
            case .loading : break
            case .dataLoaded :
                guard let weatherData = self.currentWeatherViewModel.currentWeather else {return}
                self.updateWeatherUI(currentWeather: weatherData)
                self.initForecastWeatherModel()
                self.observeForecastEvents()
            case .error(let error):
                debugPrint("Error while fetching current Weather : \(String(describing: error))")
            }
        }
    }
    
    func observeForecastEvents(){
        lazy var imageString = ""
        forecastWeatherViewModel.eventHandler = {[weak self] event in
            guard let self else {return}
            switch event {
            case .stopLoading : break
            case .loading : break
            case .dataLoaded :
                guard let weatherData = self.forecastWeatherViewModel.forecastWeatherData else {return}
                DispatchQueue.main.async {
                    self.weatherData.removeAll()
                    for data in weatherData.list {
                        for climate in data.weather {
                            if climate.main == WeatherCondition.Clouds.rawValue {
                                imageString = "partlysunny"
                            }else if climate.main == WeatherCondition.Clear.rawValue {
                                imageString = "clear"
                            }else if climate.main == WeatherCondition.Rain.rawValue {
                                imageString = "rain"
                            }
                        }
                        let weekday = Helper.shared.getWeekdayFromDate(Date(timeIntervalSince1970: data.dt))
                        let date = Helper.shared.convertStringToDate(dateString: data.dt_txt)
                        self.weatherData.append(DisplayForecastData(weekday: weekday, image: imageString, degree: Helper.shared.convertKelvinToCelsius(temp: data.main.temp, from: .kelvin, to: .celsius), date: date))
                    }
                    self.forecastTableView.reloadData()
                }
            case .error(let error):
                debugPrint("Error while fetching forecast Weather : \(String(describing: error))")
            }
        }
    }
    
    func updateWeatherUI(currentWeather : WeatherData){
        DispatchQueue.main.async {
            guard let mainWeather = currentWeather.weather else {return}
            if mainWeather[0].main == WeatherCondition.Clouds.rawValue {
                self.temperatureImage.image = UIImage(named: "sea_cloudy")
                self.labelTemperature.text = WeatherCondition.Clouds.rawValue
                self.currentColor = UIColor.CloudyColor
            }else if mainWeather[0].main == WeatherCondition.Rain.rawValue {
                self.temperatureImage.image = UIImage(named: "sea_rainy")
                self.labelTemperature.text = WeatherCondition.Rain.rawValue
                self.currentColor = UIColor.RainyColor
            }else if mainWeather[0].main == WeatherCondition.Clear.rawValue {
                self.temperatureImage.image = UIImage(named: "sea_sunny")
                self.labelTemperature.text = WeatherCondition.Clear.rawValue
                self.currentColor = UIColor.SunnyColor
            }
            self.currentTemperatureView.backgroundColor = self.currentColor
            self.forecastDataView.backgroundColor = self.currentColor
            self.labelCurrentDegrees.text = Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp ?? 0.0, from: .kelvin, to: .celsius)
            self.labelDegrees.text = Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp ?? 0.0, from: .kelvin, to: .celsius)
            self.labelMaximumDegrees.text = Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp_max ?? 0.0, from: .kelvin, to: .celsius)
            self.labelMinimumDegrees.text = Helper.shared.convertKelvinToCelsius(temp: currentWeather.main?.temp_min ?? 0.0, from: .kelvin, to: .celsius)
        }
    }
}
