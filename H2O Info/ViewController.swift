//
//  ViewController.swift
//  H2O Info
//
//  Created by Sullivan, Ryan P on 7/11/18.
//  Copyright © 2018 Sullivan, Ryan P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var airTempLabel: UILabel!
    @IBOutlet weak var poolTempLabel: UILabel!
    @IBOutlet weak var poolSetPointLabel: UILabel!
    @IBOutlet weak var poolSetPointStepper: UIStepper!
    @IBAction func circuit4SwitchToggle(_ sender: UISwitch) {
        let urlString = "http://pool.rainseed.net:3000/circuit/4/toggle"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let reposonseData = try JSONDecoder().decode(CallReponse.self, from: data)
                self.Circuit4Switch.setOn(self.makeBool(x: reposonseData.value), animated: true)
                print(reposonseData.status)
                print(reposonseData.text)
            }
            catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    @IBAction func poolSetPointAction(_ sender: Any) {
        poolSetPointLabel.text = "\(Int(poolSetPointStepper.value))º"
    }
    @IBOutlet weak var Circuit2Label: UILabel!
    @IBOutlet weak var Circuit2Switch: UISwitch!
    @IBOutlet weak var Circuit3Label: UILabel!
    @IBOutlet weak var Circuit3Switch: UISwitch!
    @IBOutlet weak var Circuit4Label: UILabel!
    @IBOutlet weak var Circuit4Switch: UISwitch!
    @IBOutlet weak var controllerTimeLabel: UILabel!
    @IBAction func syncDateTimeButton(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "M/dd/yyyy '-' h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
//         http://pool.rainseed.net:3000/datetime/set/time/18/14/date/32/13/07/18/0
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dow = calendar.component(.weekday, from: date)
        sender.setTitle(formatter.string(from: Date()), for: [])
        print("Hour:\(hour)")
        print("Min:\(minutes)")
        print("Dow:\(pentairDowConvert(i: dow))")
        
        formatter.dateFormat = "YY"
        print("Year:\(formatter.string(from: Date()))")
        print("/datetime/set/time/\(hour)/\(minutes)/date/\(pentairDowConvert(i: dow))/\(day)/\(month)/\(formatter.string(from: date))/0")
        
    
    }
    @IBOutlet weak var currentTimeButton: UIButton!
    @IBOutlet weak var rePollDataButton: UIButton!
    @IBAction func rePollDataPush(_ sender: UIButton) {
        getPoolData()
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

//        let urlString = "http://www.rainseed.net/jsonpool/test.json"
        let urlString = "http://pool.rainseed.net:3000/all"

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of ServerReponse object
                let poolData = try JSONDecoder().decode(ServerReponse.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.controllerTimeLabel.text = "\(poolData.time.controllerDateStr) - \(poolData.time.controllerTime)"
                    
                    self.airTempLabel.text = "\(poolData.temperature.airTemp)º"
                    self.poolTempLabel.text = "\(poolData.temperature.poolTemp)º"
                    self.poolSetPointLabel.text = "\(poolData.temperature.poolSetPoint)º"
                    self.poolSetPointStepper.value = Double(poolData.temperature.poolSetPoint)
                    
                    self.Circuit2Label.text = poolData.circuit["2"]?.friendlyName
                    self.Circuit2Switch.setOn(self.makeBool(x: poolData.circuit["2"]!.status), animated: true)
                    
                    self.Circuit3Label.text = poolData.circuit["3"]?.friendlyName
                    self.Circuit3Switch.setOn(self.makeBool(x: poolData.circuit["3"]!.status), animated: true)
                    
                    self.Circuit4Label.text = poolData.circuit["4"]?.friendlyName
                    self.Circuit4Switch.setOn(self.makeBool(x: poolData.circuit["4"]!.status), animated: true)
                 
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
        //End implementing URLSession
        self.view.setNeedsLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeBool(x: Int) -> Bool {
        if x == 1 {
            return true
        }
        else { return false }
    }
    
    func pentairDowConvert(i: Int) -> Int {
        var dow = 0
        switch i {
            case 1: dow = 1
            case 2: dow = 2
            case 3: dow = 4
            case 4: dow = 8
            case 5: dow = 16
            case 6: dow = 32
            case 7: dow = 64
            default: dow = 0
        }
        return dow
    }
    
    func getPoolData() {
        let urlString = "http://pool.rainseed.net:3000/all"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of ServerReponse object
                let poolData = try JSONDecoder().decode(ServerReponse.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.controllerTimeLabel.text = "\(poolData.time.controllerDateStr) - \(poolData.time.controllerTime)"
                    
                    self.airTempLabel.text = "\(poolData.temperature.airTemp)º"
                    self.poolTempLabel.text = "\(poolData.temperature.poolTemp)º"
                    self.poolSetPointLabel.text = "\(poolData.temperature.poolSetPoint)º"
                    self.poolSetPointStepper.value = Double(poolData.temperature.poolSetPoint)
                    
                    self.Circuit2Label.text = poolData.circuit["2"]?.friendlyName
                    self.Circuit2Switch.setOn(self.makeBool(x: poolData.circuit["2"]!.status), animated: true)
                    
                    self.Circuit3Label.text = poolData.circuit["3"]?.friendlyName
                    self.Circuit3Switch.setOn(self.makeBool(x: poolData.circuit["3"]!.status), animated: true)
                    
                    self.Circuit4Label.text = poolData.circuit["4"]?.friendlyName
                    self.Circuit4Switch.setOn(self.makeBool(x: poolData.circuit["4"]!.status), animated: true)
                    
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
    }



}

