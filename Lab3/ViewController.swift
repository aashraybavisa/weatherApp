//
//  ViewController.swift
//  Lab3
//
//  Created by Aashray Bavisa on 2023-11-17.
//

import UIKit
import CoreLocation
import Foundation

// MARK: - Constants

let blueColor = UIColor(red: 25/255, green: 195/255, blue: 251/255, alpha: 1)
let yellowColor = UIColor(red: 255/255, green: 205/255, blue: 0/255, alpha: 1)
let grayColor = UIColor(red: 227/255, green: 244/255, blue: 254/255, alpha: 1)

let pallateStates: [String: Array<UIColor>] = [
    "1": [yellowColor, grayColor, blueColor],
    "2": [blueColor, yellowColor, grayColor],
]

let weatherStates: [String: [String: String]] = [
    "1000": [
        "day": "Sunny",
        "sf": "sun.max.fill"
    ],
    "1003": [
        "day": "Partly cloudy",
        "sf": "cloud.sun.fill"
    ],
    "1006": [
        "day": "Cloudy",
        "sf": "cloud.fill"
    ],
    "1009": [
        "day": "Overcast",
        "sf": "cloud.fill"
    ],
    "1030": [
        "day": "Mist",
        "sf": "cloud.fog.fill"
    ],
    "1063": [
        "day": "Patchy rain possible",
        "sf": "cloud.drizzle.fill"
    ],
    "1066": [
        "day": "Patchy snow possible",
        "sf": "cloud.snow.fill"
    ],
    "1069": [
        "day": "Patchy sleet possible",
        "sf": "cloud.sleet.fill"
    ],
    "1072": [
        "day": "Patchy freezing drizzle possible",
        "sf": "cloud.drizzle.fill"
    ],
    "1087": [
        "day": "Thundery outbreaks possible",
        "sf": "cloud.bolt.fill"
    ],
    "1114": [
        "day": "Blowing snow",
        "sf": "wind.snow"
    ],
    "1117": [
        "day": "Blizzard",
        "sf": "wind.snow"
    ],
    "1135": [
        "day": "Fog",
        "sf": "cloud.fog.fill"
    ],
    "1147": [
        "day": "Freezing fog",
        "sf": "cloud.fog.fill"
    ],
    "1150": [
        "day": "Patchy light drizzle",
        "sf": "cloud.drizzle.fill"
    ],
    "1153": [
        "day": "Light drizzle",
        "sf": "cloud.drizzle.fill"
    ],
    "1168": [
        "day": "Freezing drizzle",
        "sf": "cloud.drizzle.fill"
    ],
    "1171": [
        "day": "Heavy freezing drizzle",
        "sf": "cloud.drizzle.fill"
    ],
    "1180": [
        "day": "Patchy light rain",
        "sf": "cloud.drizzle.fill"
    ],
    "1183": [
        "day": "Light rain",
        "sf": "cloud.rain.fill"
    ],
    "1186": [
        "day": "Moderate rain at times",
        "sf": "cloud.heavyrain.fill"
    ],
    "1189": [
        "day": "Moderate rain",
        "sf": "cloud.heavyrain.fill"
    ],
    "1192": [
        "day": "Heavy rain at times",
        "sf": "cloud.heavyrain.fill"
    ],
    "1195": [
        "day": "Heavy rain",
        "sf": "cloud.heavyrain.fill"
    ],
    "1198": [
        "day": "Light freezing rain",
        "sf": "cloud.sleet.fill"
    ],
    "1201": [
        "day": "Moderate or heavy freezing rain",
        "sf": "cloud.sleet.fill"
    ],
    "1204": [
        "day": "Light sleet",
        "sf": "cloud.sleet.fill"
    ],
    "1207": [
        "day": "Moderate or heavy sleet",
        "sf": "cloud.sleet.fill"
    ],
    "1210": [
        "day": "Patchy light snow",
        "sf": "cloud.snow.fill"
    ],
    "1213": [
        "day": "Light snow",
        "sf": "cloud.snow.fill"
    ],
    "1216": [
        "day": "Patchy moderate snow",
        "sf": "cloud.snow.fill"
    ],
    "1219": [
        "day": "Moderate snow",
        "sf": "cloud.snow.fill"
    ],
    "1222": [
        "day": "Patchy heavy snow",
        "sf": "cloud.snow.fill"
    ],
    "1225": [
        "day": "Heavy snow",
        "sf": "cloud.snow.fill"
    ],
    "1237": [
        "day": "Ice pellets",
        "sf": "cloud.hail.fill"
    ],
    "1240": [
        "day": "Light rain shower",
        "sf": "cloud.rain.fill"
    ],
    "1243": [
        "day": "Moderate or heavy rain shower",
        "sf": "cloud.heavyrain.fill"
    ],
    "1246": [
        "day": "Torrential rain shower",
        "sf": "cloud.downpour.fill"
    ],
    "1249": [
        "day": "Light sleet showers",
        "sf": "cloud.sleet.fill"
    ],
    "1252": [
        "day": "Moderate or heavy sleet showers",
        "sf": "cloud.sleet.fill"
    ],
    "1255": [
        "day": "Light snow showers",
        "sf": "cloud.snow.fill"
    ],
    "1258": [
        "day": "Moderate or heavy snow showers",
        "sf": "cloud.snow.fill"
    ],
    "1261": [
        "day": "Light showers of ice pellets",
        "sf": "cloud.hail.fill"
    ],
    "1264": [
        "day": "Moderate or heavy showers of ice pellets",
        "sf": "cloud.hail.fill"
    ],
    "1273": [
        "day": "Patchy light rain with thunder",
        "sf": "cloud.bolt.rain.fill"
    ],
    "1276": [
        "day": "Moderate or heavy rain with thunder",
        "sf": "cloud.bolt.heavyrain.fill"
    ],
    "1279": [
        "day": "Patchy light snow with thunder",
        "sf": "cloud.bolt.snow.fill"
    ],
    "1282": [
        "day": "Moderate or heavy snow with thunder",
        "sf": "cloud.bolt.heavysnow.fill"
    ]
]

struct WeatherResponse: Codable {
    let location: Location
    let current: Weather
}

struct Location: Codable {
    let name: String
    let country: String
    let localtime: String
}

struct Weather: Codable {
    let temp_f: Float
    let temp_c: Float
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let code: Int
}

let HistoryScreen = "goToHistory"
let encoder = PropertyListEncoder()
let userDocuments = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
let degreeSymbol = "\u{00B0}"

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var measureMode: UISegmentedControl!
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    var myLat = 0.0
    var myLong = 0.0
    var celcius = true
    private var items: [WeatherResponse] = []
    var lastResponse: WeatherResponse!
    

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        locationManager.delegate = self
        searchTextField.delegate = self
    }
    
    // MARK: Location Manager
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            myLat = location.coordinate.latitude
            myLong = location.coordinate.longitude
            print("Latitude: \(myLat), Longitude: \(myLong)")
        }
        loadWeatherByLocation(latitude: myLat, longitude: myLong)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            print("Location manager error (\(clError.code)): \(clError.localizedDescription)")
        } else {
            print("Other location manager error: \(error.localizedDescription)")
        }
    }
    
    // MARK: Navigation
    
    @IBAction func onPressCities(_ sender: UIButton) {
        print("onPressCities")
        self.performSegue(withIdentifier: HistoryScreen, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == HistoryScreen {
            let destination = segue.destination as! HistoryViewController
            destination.currentMode = celcius
        }
    }
    
    // MARK: Weather Loading
    
    private func loadWeatherByLocation(latitude: Double, longitude: Double) {
        let query = "\(latitude),\(longitude)"
        loadWeather(search: query)
    }
    
    private func loadDefaultWeather() {
        let defWeatherCode = "1255"
        test(defWeatherCode)
    }
    
    func test(_ weatherCode: String) {
        guard let weatherState = weatherStates[weatherCode] else {
            print("Invalid weather code: \(weatherCode)")
            return
        }

        let day = weatherState["day"] ?? "Unknown"
        let symbolName = weatherState["sf"] ?? "questionmark"

        print("Weather Day: \(day), Symbol Name: \(symbolName)")

        let pallate = getPallate(weatherCode)
        let config = UIImage.SymbolConfiguration(paletteColors: pallate)
        weatherConditionImage.preferredSymbolConfiguration = config
        weatherConditionImage.image = UIImage(systemName: symbolName)
    }

    
    func getPallate(_ weatherCode: String) -> [UIColor] {
        return weatherCode == "1000" ? pallateStates["1"]! : pallateStates["2"]!
    }
    
    @IBAction func onPressLocation(_ sender: UIButton) {
        setupLocationManager()
    }
    
    @IBAction func onPressSearch(_ sender: UIButton) {
        if let searchText = searchTextField.text, !searchText.isEmpty {
            loadWeather(search: searchText)
        } else {
            print("Invalid search text")
        }
    }
    
    @IBAction func onMeasureTypeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        celcius = selectedIndex == 0
        updateUI(with: lastResponse)
    }
    
    // MARK: Update UI
    
    private func updateUI(with weatherResponse: WeatherResponse) {
        locationLabel.text = "\(weatherResponse.location.name)"
        let temperature = celcius ? "\(weatherResponse.current.temp_c)\(degreeSymbol)C" : "\(weatherResponse.current.temp_f)\(degreeSymbol)F"
        temperatureLabel.text = temperature
        searchTextField.text = weatherResponse.location.name
        weatherConditionLabel.text = weatherResponse.current.condition.text
        let weatherCode = "\(weatherResponse.current.condition.code)"
        test(weatherCode)
    }
    
    // MARK: API Call
    
    private func loadWeather(search: String?) {
        guard let search = search else {
            return
        }
        print(getURL(query: search)! )
        guard let url = getURL(query: search) else {
            print("Could not get URL")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Received Task")
                return
            }
            guard let data = data else {
                print("No data found")
                return
            }
            if let weatherResponse = self.parseJson(data: data) {
                self.lastResponse = weatherResponse
                self.addData(currentWeather: weatherResponse)
                DispatchQueue.main.async {
                    print(weatherResponse)
                    self.updateUI(with: weatherResponse)
                }
            }
        }
        dataTask.resume()
    }
    
    private func getURL(query: String) -> URL? {
        let baseUrl = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let _API_KEY = "6a5af3aed7cd44989f1214607231711"
        guard let url = "\(baseUrl)\(currentEndpoint)?key=\(_API_KEY)&q=\(query)&aqi=no".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: url)
    }
    
    private func parseJson(data: Data) -> WeatherResponse? {
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(WeatherResponse.self, from: data)
        } catch {
            print("Error decoding \(error)")
            return nil
        }
    }
    
    // MARK: Storing Data
    
    private func addData(currentWeather: WeatherResponse) {
        items.append(currentWeather)
        guard let dataPath = userDocuments.first?.appendingPathComponent("MyItems.plist") else {
            return
        }
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataPath)
        }
        catch {
            print("\(error) : addData")
        }
    }
}
