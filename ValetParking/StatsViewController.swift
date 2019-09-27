//
//  StatsViewController.swift
//  ValetParking
//
//  Created by My Technology on 14/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

//
//  ViewController.swift
//  Charts Examples
//
//  Created by Anna Hazard on 5/28/17.
//  Copyright © 2017 Anna Hazard. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController {
    
    var agentStats = AgentStatsMain()
    var agentStatData = [AgentStatsData]()
    var agentStatsArray = [Int]()
    var agentStringArray = [String]()
    
    @IBOutlet weak var number1: UISlider!
    @IBOutlet weak var number2: UISlider!
    @IBOutlet weak var number3: UISlider!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    
    
    @IBOutlet var lblStatWeek: UILabel!
    @IBOutlet var first: UILabel!
    
    @IBOutlet var second: UILabel!
    
    @IBOutlet var third: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet var titleName: UILabel!
    
    @IBOutlet var fourth: UILabel!
    @IBOutlet var fifth: UILabel!
    
    @IBOutlet var seventh: UILabel!
    @IBOutlet var sixth: UILabel!
    var  i  = 0
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var agentId:String?
    
    var id:String?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.tintColor = Colors.brightOrange
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        
        guard let role = Shared.sharedInfo.userModel.data?.role?.roleType else { return }
        print(Shared.sharedInfo.userModel.data?._id!)
        if role == "valet" {
         id = Shared.sharedInfo.userModel.data?._id!
        }
        else
        {
            id = agentId!
        }
        
        
        
        ApiManager.shared.agentStats(agentId: id!, Days: "7", auth: auth, success: { stats in
            
            self.agentStatData = stats.data!
            //self.barChartUpdate()
            
           
            for stat in stats.data! {
                print(stat.count!)

              if stat.count! > 0 {
                    self.count = 1
                  self.barChartUpdate()
                }
                else {
                    print("no data")
                }

                print(stat.date!)
                self.agentStatsArray.append(stat.count!)
                self.agentStringArray.append(stat.date!)
            }
            
            if self.count == 1 {
               self.barChartUpdate()
            }

            else {
                return
            }
            
            
            
            
        }, failure: {
            error in
        })
        
        
        
        
        nameLbl.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        if role == "valet" {
            titleName.text = Shared.sharedInfo.userModel.data?.fullName!
        }
        else {
            titleName.text = Shared.sharedInfo.userStatsName
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setNavigationBar(){
        self.title = "Valet Stats".localized
       
        
        let headerImage = #imageLiteral(resourceName: "Bg 2")
        self.navigationController?.navigationBar.setBackgroundImage(headerImage, for:.default)
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let bell_button = UIButton(type: .system)
        if lang == "ar" {
            bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        
    }
    
    
    
    
    @objc func notification_message(_ sender: Any)
    {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated:true)
    }
    
    func makeDataSetWithObject(agentState : AgentStatsData, index : Int) -> BarChartDataSet{
        
        let entry1 = BarChartDataEntry(x: Double(index), y: Double(agentState.count! ))
        let dataSet = BarChartDataSet(values: [entry1], label: "Test")
        dataSet.valueTextColor = UIColor.black
         dataSet.colors = [Colors.Mediumblue]
        dataSet.valueTextColor = UIColor.clear
        return dataSet
    }
    
    func dayFromDate(date : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"  //"2017-01-09T11:00:00.000Z"
        let getdate = dateFormatter.date(from: date)
        print(getdate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "E"
        return  dateFormatter2.string(from: getdate!)
        
        
//        let dateFormatter1 = DateFormatter()
////        dateFormatter1.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter1.dateFormat = "yyyy-MM-dd"
//        let getdate1 = dateFormatter.string(from: getdate!)
//
//        print(getdate1)
        
//        let dateFormatterGet = NSDateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let dateFormatterPrint = NSDateFormatter()
//        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//
//        let date: NSDate? = dateFormatterGet.dateFromString("2016-02-29 12:24:26")
//        print(dateFormatterPrint.stringFromDate(date!))
        
////        let formatter  = DateFormatter()
////        formatter.dateFormat = "yyyy-MM-dd"
////        if let todayDate = formatter.date(from: date) {
////            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
////            let myComponents = myCalendar.components(.weekday, from: todayDate)
////            let weekDay = myComponents.weekday
//    }
        
        
        
            
}
    
    
    func barChartUpdate () {
        
        // Basic set up of plan chart
//        var labels = ["wed","tue"]
//
//        let entry1 = BarChartDataEntry(x: 1.0, y: Double(agentStatData[0].count! * 10))
//        let entry2 = BarChartDataEntry(x: 2.0, y: Double(agentStatData[1].count! * 10 ))
//        let entry3 = BarChartDataEntry(x: 3.0, y: Double(agentStatData[2].count! * 10))
//        let entry4 = BarChartDataEntry(x: 4.0, y: Double(agentStatData[3].count! * 10))
//        let entry5 = BarChartDataEntry(x: 5.0, y: Double(agentStatData[4].count! * 10))
//        let entry6 = BarChartDataEntry(x: 6.0, y: Double(agentStatData[5].count! * 10))
//        let entry7 = BarChartDataEntry(x: 7.0, y: Double(agentStatData[6].count! * 10))
//        print(entry1)
        
        var datasets = [BarChartDataSet]()
        
        
        for (index, object)  in agentStatData.enumerated() {
            
            datasets.append(makeDataSetWithObject(agentState: object, index: index))
            
            switch index{
            case 0 :
                first.text = dayFromDate(date: object.date!)
            case 1 :
                second.text = dayFromDate(date: object.date!)
            case 2 :
                third.text = dayFromDate(date: object.date!)
            case 3 :
                fourth.text = dayFromDate(date: object.date!)
            case 4 :
                fifth.text = dayFromDate(date: object.date!)
            case 5 :
                sixth.text = dayFromDate(date: object.date!)
            case 6 :
                seventh.text = dayFromDate(date: object.date!)
            default:
                break
            }

        }
        
        
        
        
//        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3,entry4,entry5,entry6,entry7], label:labels[1])
        
        
        
    
        
//        let data = BarChartData(dataSets: [dataSet])
        let data = BarChartData(dataSets: datasets)
        
    
        
        barChart.xAxis.spaceMin   = -0.9
        barChart.xAxis.spaceMax   = -0.9
        
        barChart.chartDescription?.text = ""
//        barChart.chartYMax = 40.0
//        barChart.update
        barChart.drawGridBackgroundEnabled = false
        barChart.drawValueAboveBarEnabled = false
        barChart.drawBordersEnabled = false
        barChart.legend.enabled = false
        barChart.rightAxis.enabled = false
        barChart.xAxis.enabled = false
        //barChart.chartYMax = 40.0
        barChart.animate(yAxisDuration: 1)
        
        barChart.leftAxis.granularityEnabled = false
        barChart.leftAxis.granularity = 1.0
        
        barChart.drawValueAboveBarEnabled = false
        
        
        
        barChart.leftAxis.granularityEnabled = false
        
        
       
        barChart.data?.setDrawValues(false)
        barChart.barData?.setDrawValues(false)
        
        
        barChart.drawValueAboveBarEnabled = false
        barChart.doubleTapToZoomEnabled = true
        barChart.pinchZoomEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        barChart.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        barChart.fitBars = true
        
        barChart.data = data
        print(barChart.data)
        // barChart.chartDescription?.text = "Number of Widgets by Type"
          barChart.backgroundColor = UIColor.clear
//        dataSet.colors = [Colors.Mediumblue]
//         dataSet.valueTextColor = UIColor.clear
        // Color
        //dataSet.colors = ChartColorTemplates.vordiplom()
        
        // Refresh chart with new data
        barChart.notifyDataSetChanged()
        
    }
    
//    func pieChartUpdate () {
//        
//        // Basic set up of plan chart
//        
//        let entry1 = PieChartDataEntry(value: Double(number1.value), label: "#1")
//        let entry2 = PieChartDataEntry(value: Double(number2.value), label: "#2")
//        let entry3 = PieChartDataEntry(value: Double(number3.value), label: "#3")
//        let dataSet = PieChartDataSet(values: [entry1, entry2, entry3], label: "Widget Types")
//        let data = PieChartData(dataSet: dataSet)
//        pieChart.data = data
//        pieChart.chartDescription?.text = "Share of Widgets by Type"
//        
//        // Color
//        dataSet.colors = ChartColorTemplates.joyful()
//        //dataSet.valueColors = [UIColor.black]
//        pieChart.backgroundColor = UIColor.black
//        pieChart.holeColor = UIColor.clear
//        pieChart.chartDescription?.textColor = UIColor.clear
//        pieChart.legend.textColor = UIColor.white
//        
//        // Text
//        pieChart.legend.font = UIFont(name: "Futura", size: 10)!
//        pieChart.chartDescription?.font = UIFont(name: "Futura", size: 12)!
//        pieChart.chartDescription?.xOffset = pieChart.frame.width
//        pieChart.chartDescription?.yOffset = pieChart.frame.height * (2/3)
//        pieChart.chartDescription?.textAlign = NSTextAlignment.left
//        
//        // Refresh chart with new data
//        pieChart.notifyDataSetChanged()
//        
//        
//        
//        
//    }
//    
    
}

