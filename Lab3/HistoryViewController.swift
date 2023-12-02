//
//  HistoryViewController.swift
//  Lab3
//
//  Created by Aashray Bavisa on 2023-11-29.
//

import UIKit

let decoder = PropertyListDecoder()

class HistoryViewController: UIViewController {
    
    var currentMode: Bool = true
    @IBOutlet weak var listTableView: UITableView!
    private var items: [WeatherResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        listTableView.dataSource = self
    }
    

    @IBAction func onPressBack(_ sender: UIButton) {
        dismiss(animated: true){
//            print("onPressBack Completed")
        }
    }
    
    private func getData() {
        guard let dataPath = userDocuments.first?.appendingPathComponent("MyItems.plist") else { return }
        do {
            let data = try Data(contentsOf: dataPath)
            let decodedData = try decoder.decode([WeatherResponse].self, from: data)
            items = decodedData
        }
        catch {
            print("\(error) : getData")
        }
    }

}

extension HistoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.locationLabel.text = item.location.name
        cell.temperatureLabel.text = currentMode ? "\(item.current.temp_c)\(degreeSymbol)C" : "\(item.current.temp_f)\(degreeSymbol)F"
        cell.weatherConditionLabel.text = item.current.condition.text
        let weatherCode = "\(item.current.condition.code)"
        setConditionImg(weatherCode, cell)
        cell.dateLabel.text = item.location.localtime
        return cell
    }
    
    func getPallate(_ weatherCode: String) -> [UIColor] {
        return weatherCode == "1000" ? pallateStates["1"]! : pallateStates["2"]!
    }
    
    func setConditionImg(_ weatherCode: String, _ cell: CustomTableViewCell) {
        guard let weatherState = weatherStates[weatherCode] else {
            print("Invalid weather code: \(weatherCode)")
            return
        }
        let symbolName = weatherState["sf"] ?? "questionmark"
        let pallate = getPallate(weatherCode)
        let config = UIImage.SymbolConfiguration(paletteColors: pallate)
        cell.conditionImg.preferredSymbolConfiguration = config
        cell.conditionImg.image = UIImage(systemName: symbolName)
    }
}
