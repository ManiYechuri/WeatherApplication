//
//  WeatherTablecell.swift
//  WeatherApp
//
//  Created by Mani Yechuri on 2023/07/18.
//

import UIKit

class WeatherTablecell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var labelDegrees: UILabel!
    @IBOutlet weak var labelWeekDay: UILabel!
    
    var weatherData : DisplayForecastData? {
        didSet {
            weatherDetailConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func weatherDetailConfiguration(){
        guard let weatherData else {return}
        climateImage.image = UIImage(named: weatherData.image)
        labelDegrees.text = weatherData.degree
        labelWeekDay.text = weatherData.weekday
    }
    
}
