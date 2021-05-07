//
//  ViewController.swift
//  TheCovidAnalatica
//
//  Created by user186957 on 4/25/21.
//

import UIKit
import CoreLocation
import Charts

class ViewController: UIViewController, CLLocationManagerDelegate {

    //All outlets of my app
    @IBOutlet weak var affectedPercentageView: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var howToAvoidInfection: UIButton!
    @IBOutlet weak var selfAssesment: UIButton!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var casePercentageLabe: UILabel!
    @IBOutlet weak var recoveredPercentageLabel: UILabel!
    
    //all global variables
    var locationManager : CLLocationManager? //Location manager created
    var barChart = BarChartView()// barchart view created
    var worldData = [BarChartDataEntry]()
    var worldTotal : Int = 0 //stores total covid cases till date in world
    var worldActive : Int = 0 //stores total covid active cases in world
    var worldRecovered : Int = 0 //stores total covid recovered cases in world
    var worldDead : Int = 0 //stores total covid deaths till date in world
    
    
    var countryData = [BarChartDataEntry]()


    
    //for open weather call to get country name
     let apiKey = "&appid=06738985fb395fb2d2b802f7274b055b"
     let apiAddress = "https://api.openweathermap.org/data/2.5/weather?q="
    var myCountry = "India" //default country is India.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initiating location manager and setting deligate to self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
    }
    
    //method triggered every time the page appears on screen
    override func viewDidAppear(_ animated: Bool) {
        
        //setting button text from here as multi line text is not possible from storyboard
        howToAvoidInfection.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        howToAvoidInfection.titleLabel!.textAlignment = NSTextAlignment.center
        howToAvoidInfection.setTitle("how to avoid \n infection?", for: UIControl.State.normal)
        
        selfAssesment.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        selfAssesment.titleLabel!.textAlignment = NSTextAlignment.center
        selfAssesment.setTitle("Self \n Assesment", for: UIControl.State.normal)
        
        
    }
    
    
    
    //getting loccation from GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locaation = locations.first else
        {
            return
        }
        
        let lat = locations.first!.coordinate.latitude
        let lon = locations.first!.coordinate.longitude
        
        print("\(locations.first!.coordinate.latitude): \(locations.first!.coordinate.longitude)" )
        
        //Getting city name from user location
        fetchCountry(lat,lon)
        
        onAppStart()
    }
    
    //metod to get country name and store in "mYcountry variable"
    func fetchCountry(_ lat : Double,_ lon : Double)
    {
        let sess = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)"+apiKey)!
        print(url)
        
        //task to get country code from open weather API
        let placeTask = sess.dataTask(with: url){data,response,error in
            if error != nil || data == nil
            {
                print("THere is an error in your Query")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
            else
            {
                print("Error in server response")
                return
            }
            
            //check if data is in JSON
            guard let mime = response.mimeType, mime == "application/json"
            else
            {
                print("Data received from server is not in JSON format")
                return
            }
            
            do{
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                //print(jsonData!)
                
                //default country code is India
                var countryCode = "In"

                if((jsonData?["sys"] as? [String: Any])?["country"] as! String != nil)
                {
                    countryCode = (jsonData?["sys"] as? [String: Any])?["country"] as! String
                    print("Your Country Code: \(countryCode)")
                }
                

                //converting country code to country name
                let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) as! String
                
                print(countryName)
                self.myCountry = countryName
                
                
            }
            catch{
                print("Error in json format received from server!")
            }
        }.resume()
        
    }
    
    //this function populates the world covid details when app starts for first time.
    func onAppStart()
    {
        let sess = URLSession.shared
        let worldUrl = URL(string: "https://corona.lmao.ninja/v2/all?yesterday")!
        let countryUrl = URL(string: "https://corona.lmao.ninja/v2/Countries/\(myCountry)?yesterday&strict&query")!
        
        /*for a country: "https://corona.lmao.ninja/v2/countries/\(myCountry)?daily&strict&query%20" */
        
        print("URL Call 1: \(worldUrl)")
        print("URL Call 2: \(countryUrl)")

        //task to get world covid data
        let worldTask = sess.dataTask(with: worldUrl){ [self]data,response,error in
            if error != nil || data == nil
            {
                print("THere is an error in your Query")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
            else
            {
                print("Error in server response")
                return
            }
            
            //check if data is in JSON
            guard let mime = response.mimeType, mime == "application/json"
            else
            {
                print("Data received from server is not in JSON format")
                return
            }
            
            do{
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                //print(jsonData!)
                
                    worldTotal = (jsonData!["cases"]) as! Int
                    worldActive = (jsonData!["active"]) as! Int
                    worldRecovered = (jsonData!["recovered"]) as! Int
                    worldDead = (jsonData!["deaths"]) as! Int
                
                    print(" New Active Cases: \(worldActive)")
          
                worldData = []
                worldData.append(BarChartDataEntry(x: 0, y: Double(worldTotal)))
                worldData.append(BarChartDataEntry(x: 1, y: Double(worldActive)))
                worldData.append(BarChartDataEntry(x: 2, y: Double(worldRecovered)))
                worldData.append(BarChartDataEntry(x: 3, y: Double(worldDead)))
                
                
                //this will refresh the view to display fresh data
                DispatchQueue.main.async {
                // Display covid data on app startup
                barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * 0.70)
                barChart.center = self.view.center
                self.view.addSubview(barChart)
                
                let xLabels = ["Total", "Active", "Recovered", "Deaths"]
                    barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:xLabels)
                    barChart.xAxis.granularity = 1
                    
                //var newData = [Int64]()
                
                let newSet = BarChartDataSet(entries:worldData)
                newSet.colors = ChartColorTemplates.pastel()
                
                barChart.data = BarChartData(dataSet: newSet)
                    
                    totalLabel.text = "Total: \n \(worldTotal)"
                    recoveredLabel.text = "Recovered: \n \(worldRecovered)"
                    deathLabel.text = "Death: \n \(worldDead)"
                    
                }
               
                
                
            }
            catch{
                print("Error in json format received from server!")
            }
        }.resume()
        
        //this task will now get country specific covid data for the country name we received from the GPS
        let countryTask = sess.dataTask(with: countryUrl){ [self]data,response,error in
            if error != nil || data == nil
            {
                print("THere is an error in your Query")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
            else
            {
                print("Error in server response")
                return
            }
            
            //check if data is in JSON
            guard let mime = response.mimeType, mime == "application/json"
            else
            {
                print("Data received from server is not in JSON format")
                return
            }
            
            do{
                let jsonData1 = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                //print(jsonData!)
                            
                
                
                DispatchQueue.main.async {
                
                    var total : Int = (jsonData1!["cases"]) as! Int
                    var recovered : Int = (jsonData1!["recovered"]) as! Int
                    var death : Int = (jsonData1!["deaths"]) as! Int
                    var active : Int = (jsonData1!["active"]) as! Int
                    
                    descriptionView.text = "\(myCountry) Total: \(total), \(myCountry)  Active: \(active), \(myCountry)  Recovered: \(recovered)."
                    
                    var percent : Double = round(((Double(total)/Double(worldTotal)) * 100)*10) / 10.0
                                                            
                    var recoveryPercent : Double = round(((Double(recovered)/Double(worldRecovered)) * 100)*10) / 10.0
                    
                    casePercentageLabe.text = "\(myCountry) vs World case: \(percent)%"
                    recoveredPercentageLabel.text = "\(myCountry) vs World recovery: \(recoveryPercent)%"
                    
                    
                }
               
                
                
            }
            catch{
                print("Error in json format received from server!")
            }
        }.resume()

        
        
    }


    
}

