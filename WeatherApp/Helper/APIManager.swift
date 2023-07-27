import UIKit

class APIManager {
    
    static let shared = APIManager()
    init(){}
    
    func getCurrentWeather<T : Decodable >(urlString : String ,latitude : String,longitude : String,type : T.Type ,completion : @escaping (Result<T,DataError>) -> Void) {
        guard let url = URL(string: urlString + "lat=\(latitude)&lon=\(longitude)&appid=\(Constant.APPID.appId)") else {
            return 
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                return
            }
            do {
                let currentWeather = try JSONDecoder().decode(T.self, from: data)
//                if let weather = currentWeather as? WeatherData {
//                    DatabaseHelper.shared.saveCurrentWeather(currentWeather: weather)
//                }
                completion(.success(currentWeather))
            }catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}
