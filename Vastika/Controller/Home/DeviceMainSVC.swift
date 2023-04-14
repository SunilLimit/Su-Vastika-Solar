//
//  DeviceMainSVC.swift
//  Vastika
//
//  Created by Sunil on 12/01/23.
//

import UIKit
import CoreBluetooth
import Toast_Swift  
import GDGauge
import AVFoundation
import Foundation
import QuartzCore

class DeviceMainSVC: UIViewController {
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var voltageView: UIView!
    @IBOutlet weak var frequencyView: UIView!
    @IBOutlet weak var batteryTypeView: UIView!
    @IBOutlet weak var solarView: UIView!
    @IBOutlet weak var gridView: UIView!
    
    @IBOutlet weak var loadDDView: UIView!
    @IBOutlet weak var batteryView: UIView!
    @IBOutlet weak var byPassView: UIView!
    @IBOutlet weak var linie1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    @IBOutlet weak var line6: UIView!
    @IBOutlet weak var line7: UIView!
    @IBOutlet weak var line8: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgBattery: UIImageView!
    @IBOutlet weak var btnDiagnose: UIButton!
    @IBOutlet weak var imgBoost: UIImageView!
    var firstTimeValidation : Bool = true
    @IBOutlet weak var newVoltageView: UIView!
    @IBOutlet weak var lblOnOFF: UILabel!
    
    @IBOutlet weak var switchVolView: UIView!
    @IBOutlet weak var lblTItleFrequency: UILabel!
    @IBOutlet weak var lblTitleSwitch: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var innerFView: UIView!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgGrid: UIImageView!
    @IBOutlet weak var imgSelectedImg: UIImageView!
    @IBOutlet weak var lblSelectedBatteryName: UILabel!
    @IBOutlet weak var lblSolarValue: UILabel!
    @IBOutlet weak var lblGridValue: UILabel!
    @IBOutlet weak var lblTitleATC: UILabel!
    @IBOutlet weak var lblAtcVAlue: UILabel!
    @IBOutlet weak var lblBoostVolateg: UILabel!
    @IBOutlet weak var lblBatteryPercentage: UILabel!
    @IBOutlet weak var lblByPassValue: UILabel!
    @IBOutlet weak var lblByPasstitle: UILabel!
    var player: AVAudioPlayer?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var lblBatteryVoltage: UILabel!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var lblBatteryVoltageHeight: NSLayoutConstraint!
    var counter = 1
    var tabbedSwitch : Bool = false
    var getErrorString = String()
    var commingErrorCode = String()
    var priousError : String = "0"
    var previousRunningMode : String = "0"
    var errorCounter : Int = 0
    var highAlert : Bool = false
    var counterWarring : Int = 0
    var errorArray = NSMutableArray()
    var countError : Int = 0
    var counterBatterypercent : Int = 0
    var arrayCAl = [String]()
    var gridChargingValueAiSetManually : Int = 0
    var gridForLithium : Int = 0
    var atcTimer : Int = 0
    var gaugeView: GaugeView!
    var secView : GaugeHigh!
    var firstView : GaugeLOWHIgh!
    var previousMode = String()
    
    var dicrDta = NSDictionary()
    var timer : Timer!
    @IBOutlet weak var lblWarrenty: UILabel!
    var timerforMode : Timer!
    var mipvGlobalValue = String()
    var leading : Int  = (150 * 10)

    // l3 iinner view
    var innerViewL3 = UIView()
    var innerViewL4 = UIView()

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrlHeight.constant = (200)
        self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
        self.setUpView(viewT: self.voltageView, curve: 30)
        self.setUpView(viewT: self.frequencyView, curve: 30)
        self.setUpView(viewT: self.batteryTypeView, curve: 30)
        
        self.setUpView(viewT: self.solarView, curve: 20)
        self.setUpView(viewT: self.gridView, curve: 20)
        self.setUpView(viewT: self.loadDDView, curve: 20)
        self.setUpView(viewT: self.batteryView, curve: 20)
        self.setUpView(viewT: self.byPassView, curve: 20)

        self.btnSetting.layer.cornerRadius = self.btnSetting.frame.size.height / 2
        self.btnSetting.clipsToBounds = true
        
        self.btnDiagnose.layer.cornerRadius = self.btnDiagnose.frame.size.height / 2
        self.btnDiagnose.clipsToBounds = true
        
        
       
    }
    
    func setUpHeaderWarrentyDetails()
    {
        let mon = self.dicrDta.object(forKey: "months") as? String
        let day = self.dicrDta.object(forKey: "Days") as? String
        let hr = self.dicrDta.object(forKey: "hours") as? String
        let min = self.dicrDta.object(forKey: "minutes") as? String
        
        if mon != nil && day != nil && hr != nil && min != nil
        {
            var strHeader = String()
            strHeader = "M:" + mon! + "D:" + day!
            strHeader = strHeader + " | " + hr!
            strHeader = strHeader + ":" + min!
            self.lblWarrenty.text = strHeader
        }
        else
        {
            self.lblWarrenty.text = "Device Details"
        }
    }
    
    func setUpView(viewT: UIView, curve : Int)
    {
        viewT.layer.cornerRadius = CGFloat(curve)
        viewT.layer.borderColor = UIColor.lightGray.cgColor
        viewT.layer.borderWidth = 1
        viewT.clipsToBounds = true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.setUpHeaderWarrentyDetails()
        self.setSerialNumber()
        
        self.dicrDta = self.appDelegate.globalDict
      
        
        let status_ups = self.dicrDta.object(forKey: "status_ups") as? String
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let status_error = self.dicrDta.object(forKey: "status_error") as? String
        let errorContains10 = status_error?.contains("10")
        let errorContains11 = status_error?.contains("11")

        if (status_solar == "1" && status_mains == "1" && status_ups == "0" && Mains_Ok == "1") {
            //Mains-solar mode
            self.makeVerticalAnimatedLine(line: self.line3, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line4, postion: "R", color: UIColor.green)
            
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.green)
            
            self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
            self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
            
            self.makeVerticalAnimatedLine(line: self.line7, postion: "T", color: UIColor.orange)
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            
            self.lblHeading.text = "Mains Solar Mode"
            self.previousMode = "Mains Solar Mode"
            if (status_error == "10" && status_mains == "1") {
                    self.lblHeading.text = "UPS Solar Low Voltage"
              } else if (status_error == "11" && status_mains == "1") {
                  self.lblHeading.text = "UPS Solar High Voltage"
              } else {
                  self.lblHeading.text = "Mains - Solar Mode"
                  self.lblByPassValue.isHidden = true
              }
            
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
            self.innerFView.addSubview(gaugeView)
            
            // To setup the gauge view
            gaugeView
                .setupGuage(
                    startDegree: 90,
                    endDegree: 270,
                    sectionGap: 10,
                    minValue: 30,
                    maxValue: 70
                )
                .setupContainer(options: [
                    .showContainerBorder
                ])
                .setupUnitTitle(title: "")
                .buildGauge()
            
            
            self.setUpUIForMainsSolarMode()
        }
        else if (status_solar == "1" && status_mains == "1" && status_ups == "1" && Mains_Ok == "0") {

          
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

           
            
            if (errorContains10 == true && Mains_Ok == "0") {
                self.lblHeading.text = "UPS Solar Low Voltage"
                self.previousMode = "UPS Solar Low Voltage"
                self.firstView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.firstView.backgroundColor = .white
                self.innerFView.addSubview(self.firstView)
                self.setUpUIForUpsSolarMode()
                
              } else if (errorContains11 == true && Mains_Ok == "0") {
                  self.lblHeading.text = "UPS Solar Low Voltage"
                  self.previousMode = "UPS Solar Low Voltage"
                  self.secView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                  self.secView.backgroundColor = .white
                  self.innerFView.addSubview(self.secView)
                  self.setUpUIForUpsSolarMode()
              } else {
                  self.lblHeading.text = "UPS Solar Mode"
                  self.previousMode = "UPS Solar Mode"
                  self.lblByPassValue.isHidden = true
                  // To setup the gauge view
                  gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                  self.innerFView.addSubview(gaugeView)
                  gaugeView
                      .setupGuage(
                          startDegree: 90,
                          endDegree: 270,
                          sectionGap: 10,
                          minValue: 30,
                          maxValue: 70
                      )
                      .setupContainer(options: [
                          .showContainerBorder
                      ])
                      .setupUnitTitle(title: "")
                      .buildGauge()
                  
                  self.setUpUIForUpsSolarMode()
              }
            
           
        }
        else if (status_solar == "1" && status_mains == "1" && status_ups == "1" && Mains_Ok == "1") {
            // solar mode
            self.lblHeading.text = "Solar Mode"
            self.previousMode = "Solar Mode"

            self.setUpUIForMainsMode()
        }
        else if (status_solar == "0" && status_mains == "1" && status_ups == "0" && Mains_Ok == "1") {
            // Mains mode
            self.lblHeading.text = "Mains Mode"
            self.previousMode = "Mains Mode"

            
            self.makeVerticalAnimatedLine(line: self.line3, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line4, postion: "R", color: UIColor.green)
            
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.green)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line7.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line8, postion: "T", color: UIColor.green)

            
            
            
            self.secView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
            self.secView.backgroundColor = .white
            self.newVoltageView.addSubview(self.secView)
            
            // To setup the gauge view
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
            self.innerFView.addSubview(gaugeView)
            gaugeView
                .setupGuage(
                    startDegree: 90,
                    endDegree: 270,
                    sectionGap: 10,
                    minValue: 30,
                    maxValue: 70
                )
                .setupContainer(options: [
                    .showContainerBorder
                ])
                .setupUnitTitle(title: "")
                .buildGauge()
            
            
            self.setUpUIForMainsMode()
        }
        else if (status_solar == "1" && status_mains == "0" && status_ups == "1" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Solar Mode"
            self.previousMode = "UPS Solar Mode"
            
            let loadwa = self.dicrDta.object(forKey: "load_wattage") as? String
            let pvw = self.dicrDta.object(forKey: "pvw") as? String
            let newPVW = CGFloat((pvw?.toDouble())!)
            let newWattage = CGFloat((loadwa?.toDouble())!)
                
            if newPVW > newWattage
            {
                self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.line7, postion: "T", color: UIColor.orange)
                self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)

            }
            else
            {
                self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.orange)
                self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)

            }
            
            
           
            
            // To setup the gauge view
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
            self.innerFView.addSubview(gaugeView)
            gaugeView
                .setupGuage(
                    startDegree: 90,
                    endDegree: 270,
                    sectionGap: 10,
                    minValue: 30,
                    maxValue: 70
                )
                .setupContainer(options: [
                    .showContainerBorder
                ])
                .setupUnitTitle(title: "")
                .buildGauge()
            
            self.setUpUIForUpsSolarMode()

        }
        else if (status_solar == "1" && status_mains == "0" && status_ups == "0" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Solar Mode"
            self.previousMode = "UPS Solar Mode"
            
            self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
            self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
            
            self.makeVerticalAnimatedLine(line: self.line7, postion: "T", color: UIColor.orange)
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line5.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line6.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)

            
            // To setup the gauge view
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
            self.innerFView.addSubview(gaugeView)
            gaugeView
                .setupGuage(
                    startDegree: 90,
                    endDegree: 270,
                    sectionGap: 10,
                    minValue: 30,
                    maxValue: 70
                )
                .setupContainer(options: [
                    .showContainerBorder
                ])
                .setupUnitTitle(title: "")
                .buildGauge()
            
            self.setUpUIForUpsSolarMode()
        }
        else if (status_solar == "0" && status_mains == "0" && status_ups == "1" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Mode"
            self.previousMode = "UPS Mode"

            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

            
            // To setup the gauge view
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
            self.innerFView.addSubview(gaugeView)
            
            gaugeView
                .setupGuage(
                    startDegree: 90,
                    endDegree: 270,
                    sectionGap: 10,
                    minValue: 30,
                    maxValue: 70
                )
                .setupContainer(options: [
                    .showContainerBorder
                ])
                .setupUnitTitle(title: "")
                .buildGauge()
            self.setUpUIForUpsMode()

        }
        else if (status_solar == "0" && status_mains == "0" && status_ups == "0" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS  Mode"
            self.previousMode = "UPS  Mode"
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

            
            // To setup the gauge view
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
            self.innerFView.addSubview(gaugeView)
            
            gaugeView
                .setupGuage(
                    startDegree: 90,
                    endDegree: 270,
                    sectionGap: 10,
                    minValue: 30,
                    maxValue: 70
                )
                .setupContainer(options: [
                    .showContainerBorder
                ])
                .setupUnitTitle(title: "")
                .buildGauge()
            self.setUpUIForUpsMode()

        }
        else if (status_solar == "0" && status_mains == "1" && status_ups == "1" && Mains_Ok == "0") {
            if (errorContains10 == true && status_mains == "1") {
                
                self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
                self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
                
                self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                
                self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

            
                self.lblHeading.text = "UPS Low Voltage"
                self.previousMode = "UPS Low Voltage"

                self.firstView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.firstView.backgroundColor = .white
                self.innerFView.addSubview(self.firstView)
              } else if (errorContains11 == true && status_mains == "1") {
                  
                  self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
                  self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
                  
                  self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                  self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                  self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                  self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                  
                  self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                  self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)
                  
                  
                  self.previousMode = "UPS High Voltage"
                  self.lblHeading.text = "UPS High Voltage"
                  self.secView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                  self.secView.backgroundColor = .white
                  self.innerFView.addSubview(self.secView)
              } else {
                  self.lblHeading.text = "UPS Mode"
              }
            
            
            self.setUpUIForUpsLowVoltageMode()

        }
        else
        {
            self.lblHeading.text = "UPS  Mode"
            self.previousMode = "UPS Mode"
            self.setUpUIForUpsMode()
        }

        
        
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
            let atcValue = self.dicrDta.object(forKey: "at") as? String
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        self.timerforMode = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(setUPMode), userInfo: nil, repeats: true)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func setSerialNumber()
    {
            //self.lblMode.text = "UPS Mode (Mains Fail)"
        let inverter_type = self.dicrDta.object(forKey: "inverter_type") as? String
        let dvcId = self.dicrDta.object(forKey: "device_id") as? String
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        
        if (inverter_type == "1"){
            self.lblSerialNumber.text =  "S/No.:" + (dvcId ?? "0")
        }else  if (inverter_type == "2"){
            self.lblSerialNumber.text =  "S/No.:" + (dvcId ?? "0")
        }else  if (inverter_type == "3"){
            self.lblSerialNumber.text = "S/No.:" + (dvcId ?? "0")
        }else  if (inverter_type == "4"){
            self.lblSerialNumber.text  =  "S/No.:" + (dvcId ?? "0")
        }else if (inverter_type == "5"){
            self.lblSerialNumber.text  =  "S/No.:" + (dvcId ?? "0")
        }else{
            self.lblSerialNumber.text =  "S/No.:" + (dvcId ?? "0")
        }
    }
    
    
    // MARK: - UIAction Method -------
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter += 1
            var sec : Int = 0
            var min : Int = 0
            var hr  : Int = 0
            
            sec = counter % 60
            min = counter / 60
            hr = min / 60
            var timerTime : String = ""
            if hr == 0
            {
                timerTime = "00:"
            }
            else
            {
                timerTime = String(hr) + ":"
            }
            if min == 0
            {
                timerTime = timerTime + "00:"
            }
            else
            {
                timerTime = timerTime + String(min) + ":"
            }
            
            timerTime = timerTime + String(sec)
            self.lblTimer.text = timerTime
            
        }
    }
    
    @IBAction func tapOpenSetting(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            self.bottomView.isHidden = false
            self.bottomViewHeight.constant = 50
        }
        else
        {
            self.bottomView.isHidden = true
            self.bottomViewHeight.constant = 0
        }
        
    }
    
    
    
    @IBAction func tapBackj(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updatedVoltageInpercentage()
    {
        self.atcTimer = self.atcTimer + 2

        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        
        if self.counterBatterypercent == 5
       {
           
           var ind = 0
           for item in self.arrayCAl
           {
               if ind == 4
               {
                   continue
               }
               self.arrayCAl[ind] =  self.arrayCAl[ind + 1]
               ind = ind + 1
           }
           self.arrayCAl.removeLast()
           self.arrayCAl.append(battery_percent!)
           print(self.arrayCAl)
           var avgValue : Double = 0
           for item in self.arrayCAl
           {
               avgValue = avgValue + Double(item)!
           }
           
           avgValue = avgValue / Double(self.arrayCAl.count)
           print(avgValue)
           self.lblBatteryPercentage.text =  String(avgValue) + "%"
       
       }
       else
       {
           self.arrayCAl.append(battery_percent!)
           print(self.arrayCAl)
           self.counterBatterypercent = self.counterBatterypercent + 1
           self.lblBatteryPercentage.text = "Updating"
       }
        
    }
    
    func setUpBatteryAndBoostVoltage()
        {
            
            if self.appDelegate.batteryName == "Tubular"
            {
                self.imgSelectedImg.image = UIImage(named: "tubular")
                self.lblSelectedBatteryName.text = "Tubular"
            }
            else if self.appDelegate.batteryName == "Lithium Ion"
            {
                self.imgSelectedImg.image = UIImage(named: "lithium_Ion")
                self.lblSelectedBatteryName.text = "Lithium Ion"
            }
            else
            {
                self.imgSelectedImg.image = UIImage(named: "sealed_maintenance_free")
                self.lblSelectedBatteryName.text = "Sealed Maintenance Free"
            }
            
        }

    
    func removeAllSubLayesFormView()
    {
        self.linie1.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line2.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line3.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line4.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line5.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line6.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line7.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.line8.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

    }
    
    @objc func setUPMode()
    {
        self.dicrDta = self.appDelegate.globalDict
      
        
        let status_ups = self.dicrDta.object(forKey: "status_ups") as? String
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let status_error = self.dicrDta.object(forKey: "status_error") as? String

        let errorContains10 = status_error?.contains("10")
        let errorContains11 = status_error?.contains("11")

        
        if errorCounter == 6
        {
            self.gettingErrorCode()
            errorCounter = 0
        }
        else
        {
            errorCounter = errorCounter + 3
        }
        

        if (status_solar == "1" && status_mains == "1" && status_ups == "0" && Mains_Ok == "1") {
            //Mains-solar mode

            self.removeAllSubLayesFormView()
            self.makeVerticalAnimatedLine(line: self.line3, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line4, postion: "R", color: UIColor.green)
            
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.green)
            
            self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
            self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
            
            self.makeVerticalAnimatedLine(line: self.line7, postion: "T", color: UIColor.orange)
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            
            
            self.lblHeading.text = "Mains Solar Mode"
            
            if (errorContains10 == true && status_mains == "1") {
                    self.lblHeading.text = "UPS Solar Low Voltage"
              } else if (errorContains11 == true && status_mains == "1") {
                  self.lblHeading.text = "UPS Solar High Voltage"
              } else {
                  self.lblHeading.text = "Mains - Solar Mode"
                  self.lblByPassValue.isHidden = true
              }
            
            if self.previousMode != "Mains Solar Mode"
            {
                self.previousMode = "Mains Solar Mode"
                for view in self.innerFView.subviews {
                    view.removeFromSuperview()
                }
                // To setup the gauge view
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                self.innerFView.addSubview(gaugeView)
                // To setup the gauge view
                gaugeView
                    .setupGuage(
                        startDegree: 90,
                        endDegree: 270,
                        sectionGap: 10,
                        minValue: 30,
                        maxValue: 70
                    )
                    .setupContainer(options: [
                        .showContainerBorder
                    ])
                    .setupUnitTitle(title: "")
                    .buildGauge()
                
            }
            
            self.setUpUIForMainsSolarMode()
        }
        else if (status_solar == "1" && status_mains == "1" && status_ups == "1" && Mains_Ok == "0") {
            //Mains-solar mode
            self.removeAllSubLayesFormView()
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

           
            
            if (errorContains10 == true && Mains_Ok == "0") {
                self.lblHeading.text = "UPS Solar Low Voltage"
                if self.previousMode != "UPS Solar Low Voltage"
                {
                    self.previousMode = "UPS Solar Low Voltage"
                    for view in self.innerFView.subviews {
                        view.removeFromSuperview()
                    }
                    
                    self.firstView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                    self.firstView.backgroundColor = .white
                    self.innerFView.addSubview(self.firstView)
                }
                self.setUpUIForUpsSolarMode()
                
              } else if (errorContains11 == true && Mains_Ok == "0") {
                  self.lblHeading.text = "UPS Solar High Voltage"
                  if self.previousMode != "UPS Solar High Voltage"
                  {
                      self.previousMode = "UPS Solar High Voltage"
                      for view in self.newVoltageView.subviews {
                          view.removeFromSuperview()
                      }
                      for view in self.innerFView.subviews {
                          view.removeFromSuperview()
                      }
                      
                      self.secView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                      self.secView.backgroundColor = .white
                      self.innerFView.addSubview(self.secView)
                      // To setup the gauge view
                      gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                      self.innerFView.addSubview(gaugeView)
                      gaugeView
                          .setupGuage(
                              startDegree: 90,
                              endDegree: 270,
                              sectionGap: 10,
                              minValue: 30,
                              maxValue: 70
                          )
                          .setupContainer(options: [
                              .showContainerBorder
                          ])
                          .setupUnitTitle(title: "")
                          .buildGauge()
                  }
                  self.setUpUIForUpsSolarMode()
                  
              } else {
                  self.lblHeading.text = "UPS Solar Mode"
                  self.lblByPassValue.isHidden = true
                  if self.previousMode != "UPS Solar Mode"
                  {
                      self.previousMode = "UPS Solar Mode"
                      for view in self.innerFView.subviews {
                          view.removeFromSuperview()
                      }
                      // To setup the gauge view
                      gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                      self.innerFView.addSubview(gaugeView)
                      gaugeView
                          .setupGuage(
                              startDegree: 90,
                              endDegree: 270,
                              sectionGap: 10,
                              minValue: 30,
                              maxValue: 70
                          )
                          .setupContainer(options: [
                              .showContainerBorder
                          ])
                          .setupUnitTitle(title: "")
                          .buildGauge()
                  }
                  self.setUpUIForUpsSolarMode()
              }
            
           
        }
        else if (status_solar == "1" && status_mains == "1" && status_ups == "1" && Mains_Ok == "1") {
            // solar mode
            self.lblHeading.text = "Solar Mode"
            self.setUpUIForMainsMode()
        }
        else if (status_solar == "0" && status_mains == "1" && status_ups == "0" && Mains_Ok == "1") {
            // Mains mode
            self.lblHeading.text = "Mains Mode"
            self.removeAllSubLayesFormView()
            self.makeVerticalAnimatedLine(line: self.line3, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line4, postion: "R", color: UIColor.green)
            
            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.green)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.green)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line7.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line8, postion: "T", color: UIColor.green)

            
            if self.previousMode != "Mains Mode"
            {
                self.previousMode = "Mains Mode"
                for view in self.newVoltageView.subviews {
                    view.removeFromSuperview()
                }
                for view in self.innerFView.subviews {
                    view.removeFromSuperview()
                }
                
                self.secView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.secView.backgroundColor = .white
                self.newVoltageView.addSubview(self.secView)
                // To setup the gauge view
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                self.innerFView.addSubview(gaugeView)
                gaugeView
                    .setupGuage(
                        startDegree: 90,
                        endDegree: 270,
                        sectionGap: 10,
                        minValue: 30,
                        maxValue: 70
                    )
                    .setupContainer(options: [
                        .showContainerBorder
                    ])
                    .setupUnitTitle(title: "")
                    .buildGauge()
            }
            self.setUpUIForMainsMode()
        }
        else if (status_solar == "1" && status_mains == "0" && status_ups == "1" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Solar Mode"
            
            self.removeAllSubLayesFormView()
            
            let loadwa = self.dicrDta.object(forKey: "load_wattage") as? String
            let pvw = self.dicrDta.object(forKey: "pvw") as? String
            let newPVW = CGFloat((pvw?.toDouble())!)
            let newWattage = CGFloat((loadwa?.toDouble())!)
                
            if newPVW > newWattage
            {
                self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.line7, postion: "T", color: UIColor.orange)
                self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)

            }
            else
            {
                self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
                self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
                
                self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.orange)
                self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)

            }
            
            
            
            if self.previousMode != "UPS Solar Mode"
            {
                self.previousMode = "UPS Solar Mode"
                for view in self.innerFView.subviews {
                    view.removeFromSuperview()
                }
                // To setup the gauge view
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                self.innerFView.addSubview(gaugeView)
                gaugeView
                    .setupGuage(
                        startDegree: 90,
                        endDegree: 270,
                        sectionGap: 10,
                        minValue: 30,
                        maxValue: 70
                    )
                    .setupContainer(options: [
                        .showContainerBorder
                    ])
                    .setupUnitTitle(title: "")
                    .buildGauge()
            }
            self.setUpUIForUpsSolarMode()
        }
        else if (status_solar == "1" && status_mains == "0" && status_ups == "0" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Solar Mode"
            
            self.removeAllSubLayesFormView()
            
           
            self.makeVerticalAnimatedLine(line: self.linie1, postion: "T", color: UIColor.orange)
            self.makeHorizotalAnimatedLine(line: self.line2, postion: "L", color: UIColor.orange)
            
            self.makeVerticalAnimatedLine(line: self.line7, postion: "T", color: UIColor.orange)
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line5.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line6.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)

            
            if self.previousMode != "UPS Solar Mode"
            {
                self.previousMode = "UPS Solar Mode"
                for view in self.innerFView.subviews {
                    view.removeFromSuperview()
                }
                // To setup the gauge view
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                self.innerFView.addSubview(gaugeView)
                gaugeView
                    .setupGuage(
                        startDegree: 90,
                        endDegree: 270,
                        sectionGap: 10,
                        minValue: 30,
                        maxValue: 70
                    )
                    .setupContainer(options: [
                        .showContainerBorder
                    ])
                    .setupUnitTitle(title: "")
                    .buildGauge()
            }
            self.setUpUIForUpsSolarMode()
        }
        else if (status_solar == "0" && status_mains == "0" && status_ups == "1" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Mode"
            self.removeAllSubLayesFormView()

            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

            // To setup the gauge view
            
            if self.previousMode != "UPS Mode"
            {
                self.previousMode = "UPS Mode"
                for view in self.innerFView.subviews {
                    view.removeFromSuperview()
                }
                
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                self.innerFView.addSubview(gaugeView)
                gaugeView
                    .setupGuage(
                        startDegree: 90,
                        endDegree: 270,
                        sectionGap: 10,
                        minValue: 30,
                        maxValue: 70
                    )
                    .setupContainer(options: [
                        .showContainerBorder
                    ])
                    .setupUnitTitle(title: "")
                    .buildGauge()
                
            }
           
           
            self.setUpUIForUpsMode()

        }
        else if (status_solar == "0" && status_mains == "0" && status_ups == "0" && Mains_Ok == "0") {
            self.lblHeading.text = "UPS Mode"
           
            // To setup the gauge view
            self.removeAllSubLayesFormView()

            self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
            self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
            
            self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
            
            self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
            self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

            
            if self.previousMode != "UPS Mode"
            {
                self.previousMode = "UPS Mode"
                for view in self.innerFView.subviews {
                    view.removeFromSuperview()
                }
                
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
                self.innerFView.addSubview(gaugeView)
                gaugeView
                    .setupGuage(
                        startDegree: 90,
                        endDegree: 270,
                        sectionGap: 10,
                        minValue: 30,
                        maxValue: 70
                    )
                    .setupContainer(options: [
                        .showContainerBorder
                    ])
                    .setupUnitTitle(title: "")
                    .buildGauge()
            }
           
           
            self.setUpUIForUpsMode()

        }
        else if (status_solar == "0" && status_mains == "1" && status_ups == "1" && Mains_Ok == "0") {
            
            
            if (errorContains10 == true && status_mains == "1") {
                self.removeAllSubLayesFormView()
                self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
                self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
                
                self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                
                self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

                
                self.lblHeading.text = "UPS Low Voltage"
                if self.previousMode != "UPS Low Voltage"
                {
                    self.previousMode = "UPS Low Voltage"
                    for view in self.innerFView.subviews {
                        view.removeFromSuperview()
                    }
                    
                    self.firstView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                    self.firstView.backgroundColor = .white
                    self.innerFView.addSubview(self.firstView)
                }
                
              } else if (errorContains11 == true && status_mains == "1") {
                  self.removeAllSubLayesFormView()
                  self.makeVerticalAnimatedLine(line: self.line5, postion: "T", color: UIColor.blue)
                  self.makeHorizotalAnimatedLine(line: self.line6, postion: "L", color: UIColor.blue)
                  
                  self.linie1.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                  self.line2.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                  self.line3.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                  self.line4.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .horizontal)
                  
                  self.line8.makeDashedBorderLine(color: .red, strokeLength: 7, gapLength: 5, width: 3, orientation: .vertical)
                  self.makeVerticalAnimatedLine(line: self.line7, postion: "B", color: UIColor.blue)

                  
                  self.lblHeading.text = "UPS High Voltage"
                  if self.previousMode != "UPS High Voltage"
                  {
                      self.previousMode = "UPS High Voltage"
                      for view in self.innerFView.subviews {
                          view.removeFromSuperview()
                      }
                      self.secView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                      self.secView.backgroundColor = .white
                      self.innerFView.addSubview(self.secView)
                  }
                  
              } else {
                  self.lblHeading.text = "UPS Mode"
              }
            self.setUpUIForUpsLowVoltageMode()

        }
        else
        {
            self.lblHeading.text = "UPS  Mode"
            self.setUpUIForUpsLowVoltageMode()
        }

        
        
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
            let atcValue = self.dicrDta.object(forKey: "at") as? String
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
    }
    
    func setUpUIForMainsSolarMode()
    {
    
        // Mains Solar Mode
        
        self.switchVolView.isHidden = false
        self.newVoltageView.isHidden = true
        self.imgBattery.loadGif(name: "battery")
        self.setUpBatteryAndBoostVoltage()
        self.lblTitleSwitch.text = "Switch"
        self.lblTItleFrequency.text = "Frequency"
        self.lblByPasstitle.text = "ByPass"
        self.loadDDView.isHidden = false
        // Charge sharing power
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let status_error = self.dicrDta.object(forKey: "status_error") as? String
        
        if battery_percent == "100.00"
        {
            self.imgBattery.image = UIImage(named: "battery_full")
            self.lblBatteryPercentage.text = "Charging 100%"
            self.lblBatteryVoltageHeight.constant = 0
        }
        else
        {
            self.lblBatteryVoltageHeight.constant = 0
            self.imgBattery.loadGif(name: "battery")
            self.lblBatteryPercentage.text = "Charging " + battery_percent! + " %"
        }
        
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "0"
        {
            self.btnSwitch.setImage(UIImage(named: "off_CR"), for: .normal)
            self.lblOnOFF.text = "Off"
        }
        else
        {
            self.btnSwitch.setImage(UIImage(named: "on_CR"), for: .normal)
            self.lblOnOFF.text = "On"
        }
        
        let ernp = status_error?.contains("2")
        if ernp == true
        {
            self.lblOnOFF.text = "Switch"
        }
        
        
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
        
        self.lblSolarValue.text = pvw! + " W"
        
        self.lblGridValue.text = mipv! + " V"
        
        
        self.imgBoost.image = UIImage(named: "boost_CR")
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)

        if cmpV < 0
        {
            self.lblAtcVAlue.isHidden = true
            if strBattryType == "Lithium Ion"
            {
                self.lblBoostVolateg.text = String("14.6") + " V"
            }
        }
        else
        {
            self.lblTitleATC.isHidden = false
            if strBattryType == "Lithium Ion"
            {
                let bValue = self.dicrDta.object(forKey: "dcbus") as? String
                let bIntValue = Int(bValue!)
                if bIntValue == 12
                {
                    self.lblBoostVolateg.text = String(14.6) + " V"
                }
                else if bIntValue == 24
                {
                    self.lblBoostVolateg.text = String(29.2) + " V"
                }
                else
                {
                    self.lblBoostVolateg.text = String(54) + " V"
                }
               
            }
            else
            {
                self.lblBoostVolateg.text = String(format: "%.2f", (boostValue)) + " V"
            }
        }
        
       
        
        self.imgBoost.image = UIImage(named: "169367")
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
           
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        var inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
        
        
        if Int((inputfre?.floatValue.rounded())!) <= 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) == 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblFrequency.text = "60.00 Hz"
            freVoltage = 57.0
            inputfre = String(60.0)
        }
        else
        {
            freVoltage = 44.0
            self.lblFrequency.text = (inputfre!) + " Hz"
        }
        
        self.innerFView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 1) {
                       // self.firstView.value = Int(freVoltage)
                        self.gaugeView.updateValueTo(CGFloat((freVoltage)))
                    }
                }
        
        
      
    }
    
    
    
    func setUpUIForSolarMode()
    {
        // Charge sharing power
        self.switchVolView.isHidden = false
        self.newVoltageView.isHidden = true
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        let pvw = self.dicrDta.object(forKey: "bw") as? String
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
        let totalCharging: Double = (bw?.toDouble())! //+ (pvw?.toDouble())!
        let intCharing = Int(totalCharging)
        if (battery_percent?.toDouble())! == 100.00
        {
             if strBattryType == "Lithium Ion"
            {
                 if self.gridForLithium == 0
                 {
                     self.gridForLithium += 1
                     self.lblGridValue.text = " 1 W"
                 }
                 else
                 {
                     self.gridForLithium = 0
                     self.lblGridValue.text = " 2 W"
                 }
            }
            else
            {
                if (self.gridChargingValueAiSetManually == 0) {
                        self.lblGridValue.text = " 15 W"
                        self.gridChargingValueAiSetManually += 1
                } else if (self.gridChargingValueAiSetManually == 1) {
                        self.lblGridValue.text = " 18 W"
                        self.gridChargingValueAiSetManually += 1
                } else if (self.gridChargingValueAiSetManually == 2) {
                        self.lblGridValue.text = " 14 W"
                        self.gridChargingValueAiSetManually += 1
                } else if (self.gridChargingValueAiSetManually == 3) {
                        self.lblGridValue.text = " 11 W"
                        self.gridChargingValueAiSetManually += 1
                } else if (self.gridChargingValueAiSetManually == 4) {
                        self.lblGridValue.text = " 8 W"
                        self.gridChargingValueAiSetManually += 1
                } else if (self.gridChargingValueAiSetManually == 5) {
                        self.lblGridValue.text = " 12 W"
                        self.gridChargingValueAiSetManually += 1
                } else if (self.gridChargingValueAiSetManually == 6) {
                        self.lblGridValue.text = " 15 W"
                        self.gridChargingValueAiSetManually += 1
                } else {
                    self.gridChargingValueAiSetManually = 0
                }
            }
        }
        else
        {
            self.lblGridValue.text =   String(intCharing) + " W"
        }
        
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "0"
        {
            self.btnSwitch.setImage(UIImage(named: "off_CR"), for: .normal)
            self.lblOnOFF.text = "Off"
        }
        else
        {
            self.btnSwitch.setImage(UIImage(named: "on_CR"), for: .normal)
            self.lblOnOFF.text = "On"
        }
        let status_error = self.dicrDta.object(forKey: "status_error") as? String
        let ernp = status_error?.contains("2")
        if ernp == true
        {
            self.lblOnOFF.text = "Switch"
        }
        
        // Grid charging power
        if battery_percent == "100.00"
        {
            self.imgGrid.loadGif(name: "comGridImg")
        }
        else
        {
            self.imgGrid.loadGif(name: "chargingGrid")
        }
        
        
        let bosstValue = self.dicrDta.object(forKey: "Boost_Voltage") as? String
        //self.lblBoost.text = String(format: "%.1f", (bosstValue?.toDouble())!) + " V"
        
        self.imgBoost.image = UIImage(named: "boost_CR")
        
        
        let batteryType = self.dicrDta.object(forKey: "setting_battery_type") as? String
       

        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)

        if cmpV < 0
        {
            self.lblAtcVAlue.isHidden = true
            if strBattryType == "Lithium Ion"
            {
                self.lblBoostVolateg.text = String("14.6") + " V"
            }
        }
        else
        {
            self.lblTitleATC.isHidden = false
            if strBattryType == "Lithium Ion"
            {
                let bValue = self.dicrDta.object(forKey: "dcbus") as? String
                let bIntValue = Int(bValue!)
                if bIntValue == 12
                {
                    self.lblBoostVolateg.text = String(14.6) + " V"
                }
                else if bIntValue == 24
                {
                    self.lblBoostVolateg.text = String(29.2) + " V"
                }
                else
                {
                    self.lblBoostVolateg.text = String(54) + " V"
                }
               
            }
            else
            {
                self.lblBoostVolateg.text = String(format: "%.2f", (boostValue)) + " V"
            }
        }
        
       
        
        self.imgBoost.image = UIImage(named: "169367")
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
           
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        var inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
        
        
        if Int((inputfre?.floatValue.rounded())!) <= 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) == 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblFrequency.text = "60.00 Hz"
            freVoltage = 57.0
            inputfre = String(60.0)
        }
        else
        {
            freVoltage = 44.0
            self.lblFrequency.text = (inputfre!) + " Hz"
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 1) {
                       // self.firstView.value = Int(freVoltage)
                        self.gaugeView.updateValueTo(CGFloat((freVoltage ?? 0.0)))
                    }
                }
       
    }
    
    func setUpUIForMainsMode()
    {
        // Mains Solar Mode
        
        self.switchVolView.isHidden = true
        self.newVoltageView.isHidden = false
        self.lblFrequency.isHidden = false
        self.innerFView.isHidden = false
        
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        let voltageInt = Float((mipv?.floatValue.rounded())!)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 1) {
                        self.secView.value = Int(voltageInt)
                    }
                }
        
        self.imgBattery.loadGif(name: "battery")
        self.setUpBatteryAndBoostVoltage()
        self.lblTItleFrequency.text = "Frequency"
        self.lblByPasstitle.text = "ByPass"
        self.loadDDView.isHidden = false
        // Charge sharing power
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let status_error = self.dicrDta.object(forKey: "status_error") as? String
        
        let upsType = self.dicrDta.object(forKey: "setting_ups_type") as? String

        switch (upsType) {
            case "2":
                self.lblTitleSwitch.text = "Voltage | N"
              break;
            case "3":
               
                self.lblTitleSwitch.text = "Voltage | W"
                break
            case "1":
                self.lblTitleSwitch.text = "Voltage | W"
                break;
            default:
                self.lblTitleSwitch.text = "Voltage | N"
                break
        }
        
        
        if battery_percent == "100.00"
        {
            self.imgBattery.image = UIImage(named: "battery_full")
            self.lblBatteryPercentage.text = "Charging 100%"
            self.lblBatteryVoltageHeight.constant = 0
        }
        else
        {
            self.lblBatteryVoltageHeight.constant = 0
            self.imgBattery.loadGif(name: "battery")
            self.lblBatteryPercentage.text = "Charging " + battery_percent! + " %"
        }
        
        
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
        
        self.lblSolarValue.text = pvw! + " W"
        
        self.lblGridValue.text = mipv! + " V"
        
        
        self.imgBoost.image = UIImage(named: "boost_CR")
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)

        if cmpV < 0
        {
            self.lblAtcVAlue.isHidden = true
            if strBattryType == "Lithium Ion"
            {
                self.lblBoostVolateg.text = String("14.6") + " V"
            }
        }
        else
        {
            self.lblTitleATC.isHidden = false
            if strBattryType == "Lithium Ion"
            {
                let bValue = self.dicrDta.object(forKey: "dcbus") as? String
                let bIntValue = Int(bValue!)
                if bIntValue == 12
                {
                    self.lblBoostVolateg.text = String(14.6) + " V"
                }
                else if bIntValue == 24
                {
                    self.lblBoostVolateg.text = String(29.2) + " V"
                }
                else
                {
                    self.lblBoostVolateg.text = String(54) + " V"
                }
               
            }
            else
            {
                self.lblBoostVolateg.text = String(format: "%.2f", (boostValue)) + " V"
            }
        }
        
       
        
        self.imgBoost.image = UIImage(named: "169367")
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
           
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        var inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
        print(inputfre)
        
        if Int((inputfre?.floatValue.rounded())!) <= 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) == 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblFrequency.text = "60.00 Hz"
            freVoltage = 57.0
            inputfre = String(60.0)
        }
        else
        {
            freVoltage = 44.0
            self.lblFrequency.text = (inputfre!) + " Hz"
        }
        
        
        self.innerFView.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 1) {
                       // self.firstView.value = Int(freVoltage)
                        self.gaugeView.updateValueTo(CGFloat((freVoltage)))
                    }
                }
        
       
        
        if (status_error == "10" && status_mains == "1") {
                //"UPS Solar Low Voltage"
          } else if (status_error == "11" && status_mains == "1") {
              // "UPS Solar High Voltage"
          } else {
              // "Mains - Solar Mode"
              self.lblByPassValue.isHidden = true
          }
        
        
    }
    
    func setUpUIForUpsSolarMode()
    {
        // Mains Solar Mode
        self.switchVolView.isHidden = false
        self.newVoltageView.isHidden = true
        self.setUpBatteryAndBoostVoltage()
        self.lblTitleSwitch.text = "Switch"
        self.lblTItleFrequency.text = "Frequency"
        self.lblByPasstitle.text = "Load"
        self.loadDDView.isHidden = true
        // Charge sharing power
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let status_error = self.dicrDta.object(forKey: "status_error") as? String
        let bvValue = self.dicrDta.object(forKey: "bv") as? String

        let loadwa = self.dicrDta.object(forKey: "load_wattage") as? String

        let newPVW = CGFloat((pvw?.toDouble())!)
        let newWattage = CGFloat((loadwa?.toDouble())!)
        
        if newPVW > newWattage
        {
            self.lblBatteryVoltageHeight.constant = 0
            self.imgBattery.loadGif(name: "battery")
            self.lblBatteryPercentage.text = "Charging " + battery_percent! + " %"
        }
        else
        {
            self.lblBatteryVoltageHeight.constant = 21
            self.imgBattery.loadGif(name: "medium_battery")
            self.lblBatteryVoltage.isHidden = false
            self.lblBatteryVoltage.text = bvValue! + " V"
            self.lblBatteryPercentage.text = "Discharging..."
        }
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "0"
        {
            self.btnSwitch.setImage(UIImage(named: "off_CR"), for: .normal)
            self.lblOnOFF.text = "Off"
        }
        else
        {
            self.btnSwitch.setImage(UIImage(named: "on_CR"), for: .normal)
            self.lblOnOFF.text = "On"
        }
        
        let ernp = status_error?.contains("2")
        if ernp == true
        {
            self.lblOnOFF.text = "Switch"
        }
        
        
        self.lblByPassValue.text = loadwa! + " W"
        self.lblByPassValue.isHidden = false
        
        
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
        
        self.lblSolarValue.text = pvw! + " W"
        
        self.lblGridValue.text = mipv! + " V"
        
        
        self.imgBoost.image = UIImage(named: "boost_CR")
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)

        if cmpV < 0
        {
            self.lblAtcVAlue.isHidden = true
            if strBattryType == "Lithium Ion"
            {
                self.lblBoostVolateg.text = String("14.6") + " V"
            }
        }
        else
        {
            self.lblTitleATC.isHidden = false
            if strBattryType == "Lithium Ion"
            {
                let bValue = self.dicrDta.object(forKey: "dcbus") as? String
                let bIntValue = Int(bValue!)
                if bIntValue == 12
                {
                    self.lblBoostVolateg.text = String(14.6) + " V"
                }
                else if bIntValue == 24
                {
                    self.lblBoostVolateg.text = String(29.2) + " V"
                }
                else
                {
                    self.lblBoostVolateg.text = String(54) + " V"
                }
               
            }
            else
            {
                self.lblBoostVolateg.text = String(format: "%.2f", (boostValue)) + " V"
            }
        }
        
       
        
        self.imgBoost.image = UIImage(named: "169367")
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
           
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        var inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
        
        
        if Int((inputfre?.floatValue.rounded())!) <= 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) == 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblFrequency.text = "60.00 Hz"
            freVoltage = 57.0
            inputfre = String(60.0)
        }
        else
        {
            freVoltage = 44.0
            self.lblFrequency.text = (inputfre!) + " Hz"
        }
        
        if status_mains == "1"
        {
            if status_error == "10" && Mains_Ok == "0"
            {
                self.lblTItleFrequency.text = "Voltage"
                self.lblFrequency.isHidden = true
                let mipv = self.dicrDta.object(forKey: "mipv") as? String
                let voltageInt = Float((mipv?.floatValue.rounded())!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 1) {
                                self.firstView.value = Int(voltageInt)
                            }
                        }
            }
            else if status_error == "11" && Mains_Ok == "0"
            {
                let mipv = self.dicrDta.object(forKey: "mipv") as? String
                let voltageInt = Float((mipv?.floatValue.rounded())!)
                self.lblTItleFrequency.text = "Voltage"
                self.lblFrequency.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 1) {
                                self.secView.value = Int(voltageInt)
                            }
                        }
            }
        }
        else
        {
            self.lblTItleFrequency.text = "Frequency"
            self.lblFrequency.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UIView.animate(withDuration: 1) {
                            self.gaugeView.updateValueTo(CGFloat((freVoltage ?? 0.0)))
                        }
                    }
        }
        
        
       
    }
    
    func setUpUIForUpsLowVoltageMode()
    {
        // Mains Solar Mode
        self.switchVolView.isHidden = false
        self.newVoltageView.isHidden = true
        self.setUpBatteryAndBoostVoltage()
        self.lblTitleSwitch.text = "Switch"
        self.lblTItleFrequency.text = "Voltage"
        self.lblByPasstitle.text = "Load"
        self.loadDDView.isHidden = true
        self.lblFrequency.isHidden = true
        
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "0"
        {
            self.btnSwitch.setImage(UIImage(named: "off_CR"), for: .normal)
            self.lblOnOFF.text = "Off"
        }
        else
        {
            self.btnSwitch.setImage(UIImage(named: "on_CR"), for: .normal)
            self.lblOnOFF.text = "On"
        }
        
        
        let status_error = self.dicrDta.object(forKey: "status_error") as? String

        let ernp = status_error?.contains("2")
        if ernp == true
        {
            self.lblOnOFF.text = "Switch"
        }
        
        
        var mipv = self.dicrDta.object(forKey: "mipv") as? String
        let voltageInt = Float((mipv?.floatValue.rounded())!)
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String

        if (status_error == "10" && status_mains == "1") {
            self.lblHeading.text = "UPS Low Voltage"
            if self.mipvGlobalValue != mipv!
            {
                self.mipvGlobalValue = mipv!
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 1) {
                                self.firstView.value = Int(voltageInt)
                            }
                        }
            }
          } else if (status_error == "11" && status_mains == "1") {
              self.lblHeading.text = "UPS High Voltage"
              if self.mipvGlobalValue != mipv!
              {
                  self.mipvGlobalValue = mipv!
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                              UIView.animate(withDuration: 1) {
                                  self.secView.value = Int(voltageInt)
                              }
                          }
              }
            
          }
        
        
        // Charge sharing power
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let bvValue = self.dicrDta.object(forKey: "bv") as? String

        let loadwa = self.dicrDta.object(forKey: "load_wattage") as? String

        self.lblByPassValue.text = loadwa! + " W"
        self.lblByPassValue.isHidden = false
        
        self.imgBattery.loadGif(name: "medium_battery")
        self.lblBatteryPercentage.text = "Discharging..."
        self.lblBatteryVoltageHeight.constant = 21
        self.lblBatteryVoltage.text = bvValue! + " V"
        
        
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
        
        self.lblSolarValue.text = "0.00 W"
        
        self.lblGridValue.text = mipv! + " V"
        
        
        self.imgBoost.image = UIImage(named: "boost_CR")
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)

        if cmpV < 0
        {
            self.lblAtcVAlue.isHidden = true
            if strBattryType == "Lithium Ion"
            {
                self.lblBoostVolateg.text = String("14.6") + " V"
            }
        }
        else
        {
            self.lblTitleATC.isHidden = false
            if strBattryType == "Lithium Ion"
            {
                let bValue = self.dicrDta.object(forKey: "dcbus") as? String
                let bIntValue = Int(bValue!)
                if bIntValue == 12
                {
                    self.lblBoostVolateg.text = String(14.6) + " V"
                }
                else if bIntValue == 24
                {
                    self.lblBoostVolateg.text = String(29.2) + " V"
                }
                else
                {
                    self.lblBoostVolateg.text = String(54) + " V"
                }
               
            }
            else
            {
                self.lblBoostVolateg.text = String(format: "%.2f", (boostValue)) + " V"
            }
        }
        
       
        
        self.imgBoost.image = UIImage(named: "169367")
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
           
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        var inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
        
        
        if Int((inputfre?.floatValue.rounded())!) <= 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) == 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblFrequency.text = "60.00 Hz"
            freVoltage = 57.0
            inputfre = String(60.0)
        }
        else
        {
            freVoltage = 44.0
            self.lblFrequency.text = (inputfre!) + " Hz"
        }
        
    }
    
    func setUpUIForUpsMode()
    {
        // Mains Solar Mode
        self.switchVolView.isHidden = false
        self.newVoltageView.isHidden = true
        self.setUpBatteryAndBoostVoltage()
        self.lblTitleSwitch.text = "Switch"
        self.lblTItleFrequency.text = "Frequency"
        self.lblByPasstitle.text = "Load"
        self.loadDDView.isHidden = true
        self.lblFrequency.isHidden = false

        
        // Charge sharing power
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        let status_mains = self.dicrDta.object(forKey: "status_mains") as? String
        let status_solar = self.dicrDta.object(forKey: "status_solar") as? String
        let Mains_Ok = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let status_error = self.dicrDta.object(forKey: "status_error") as? String
        let bvValue = self.dicrDta.object(forKey: "bv") as? String

        let loadwa = self.dicrDta.object(forKey: "load_wattage") as? String

        self.lblByPassValue.text = loadwa! + " W"
        self.lblByPassValue.isHidden = false
        
        self.imgBattery.loadGif(name: "medium_battery")
        self.lblBatteryPercentage.text = "Discharging..."
        self.lblBatteryVoltageHeight.constant = 21
        self.lblBatteryVoltage.text = bvValue! + " V"
        
        
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "0"
        {
            self.btnSwitch.setImage(UIImage(named: "off_CR"), for: .normal)
            self.lblOnOFF.text = "Off"
        }
        else
        {
            self.btnSwitch.setImage(UIImage(named: "on_CR"), for: .normal)
            self.lblOnOFF.text = "On"
        }
        
        let ernp = status_error?.contains("2")
        if ernp == true
        {
            self.lblOnOFF.text = "Switch"
        }
        
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
        
        self.lblSolarValue.text = "0.00 W"
        
        self.lblGridValue.text = "0.00 V"
        
        
        self.imgBoost.image = UIImage(named: "boost_CR")
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)

        if cmpV < 0
        {
            self.lblAtcVAlue.isHidden = true
            if strBattryType == "Lithium Ion"
            {
                self.lblBoostVolateg.text = String("14.6") + " V"
            }
        }
        else
        {
            self.lblTitleATC.isHidden = false
            if strBattryType == "Lithium Ion"
            {
                let bValue = self.dicrDta.object(forKey: "dcbus") as? String
                let bIntValue = Int(bValue!)
                if bIntValue == 12
                {
                    self.lblBoostVolateg.text = String(14.6) + " V"
                }
                else if bIntValue == 24
                {
                    self.lblBoostVolateg.text = String(29.2) + " V"
                }
                else
                {
                    self.lblBoostVolateg.text = String(54) + " V"
                }
               
            }
            else
            {
                self.lblBoostVolateg.text = String(format: "%.2f", (boostValue)) + " V"
            }
        }
        
       
        
        self.imgBoost.image = UIImage(named: "169367")
        
        let atcActive = self.dicrDta.object(forKey: "FC_ATC_Sensor") as? String
        if atcActive == "1"
        {
            if self.atcTimer > 12
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
                let cpV = Int((at?.toDouble())!)
                if cpV < 0
                {
                    self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                }
                
            }
            else
            {
                if self.firstTimeValidation == true
                {
                    self.firstTimeValidation = false
                    self.atcTimer = 0
                    let at = self.dicrDta.object(forKey: "at") as? String
                    let cpV = Int((at?.toDouble())!)
                    if cpV < 0
                    {
                        self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
                    }
                }
            }
                

        }
        else
        {
           
            self.lblTitleATC.isHidden = false
            self.lblAtcVAlue.text = String(atcValue!) + "℃"
        }
        
        
        var inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
        
        
        if Int((inputfre?.floatValue.rounded())!) <= 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) == 50
        {
            self.lblFrequency.text = "50.00 Hz"
            freVoltage = 37.0
            inputfre = String(50.0)
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblFrequency.text = "60.00 Hz"
            freVoltage = 57.0
            inputfre = String(60.0)
        }
        else
        {
            freVoltage = 44.0
            self.lblFrequency.text = (inputfre!) + " Hz"
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 1) {
                       // self.firstView.value = Int(freVoltage)
                        self.gaugeView.updateValueTo(CGFloat((freVoltage ?? 0.0)))
                    }
                }
        
        
    }
    
    
    func gettingErrorCode()
    {
        
       
        
        let error = self.dicrDta.object(forKey: "status_error") as? String
        if error == nil || error == "" || error == " " || ((error?.isEmpty) == nil)
        {
            return
        }
        let ernp = error?.contains(",")
        if ernp == false
        {
            if error == "0"
            {
                return
            }
            print("single")
            self.priousError = error!
            var completeError = String()
            if self.atcTimer > 15
            {
                
                self.atcTimer = 0
                let at = self.dicrDta.object(forKey: "at") as? String
               let cpV = Int((at?.toDouble())!)
               if cpV < 0
               {
                   self.view.makeToast("The temperature sensor is not installed; please check and install it properly to get the values")
               }
                else
                {
                    let statusFrontOff = self.dicrDta.object(forKey: "status_front_switch") as? String
                    if statusFrontOff == "0"
                    {
                        if self.appDelegate.tappedToggelSwitch == true
                        {
                            completeError = completeError + "The UPS front switch is off. Please turn on the front switch via application."
                            self.view.makeToast(completeError)
                        }
                        else
                        {
                            completeError = completeError + "The UPS front switch is off. Please turn on the front switch manually."
                            self.view.makeToast(completeError)
                        }
                        
                        
                    }
                    else
                    {
                        self.view.makeToast(self.createErrorString(error: error!))
                        if self.appDelegate.audioActive == 1
                        {
                            if self.highAlert == true
                            {
                                self.playSound("highAlt")
                            }
                            else
                            {
                                let systemSoundID: SystemSoundID = 1315
                                AudioServicesPlaySystemSound (systemSoundID)
                            }
                        }
                    }
                }
            }
            else
            {
                let statusFrontOff = self.dicrDta.object(forKey: "status_front_switch") as? String
                if statusFrontOff == "0"
                {
                    if self.appDelegate.tappedToggelSwitch == true
                    {
                        completeError = completeError + "The UPS front switch is off. Please turn on the front switch via application."
                        self.view.makeToast(completeError)
                    }
                    else
                    {
                        completeError = completeError + "The UPS front switch is off. Please turn on the front switch manually."
                        self.view.makeToast(completeError)
                    }
                    
                    
                }
                else
                {
                    self.view.makeToast(self.createErrorString(error: error!))
                    if self.appDelegate.audioActive == 1
                    {
                        if self.highAlert == true
                        {
                            self.playSound("highAlt")
                        }
                        else
                        {
                            let systemSoundID: SystemSoundID = 1315
                            AudioServicesPlaySystemSound (systemSoundID)
                        }
                    }
                }
            }

        }
        else
        {
            print("multipal")
            let newCollectError = error?.split(separator: ",")
            var newCodeError = NSMutableString()
            let newCodeErrorString = NSMutableString()

            for erorN in newCollectError!
            {
                newCodeErrorString.append(self.createErrorString(error: String(erorN)))
                newCodeErrorString.append("\n")
                newCodeError.append(String(erorN))
                newCodeError.append(",")
               // self.errorArray.add(error! as String)
            }
            var newrrorCode = String(newCodeError as String)
            let erCode = newrrorCode.dropLast()
            newCodeError = NSMutableString(string: erCode.description)
            print(newCodeError)
            print(newCodeErrorString)
   
            if self.priousError != (newCodeError as String)
            {
                self.countError = 0
                self.errorArray.removeAllObjects()
                self.priousError = newCodeError as String
                let newOneCollectError = (newCodeError as String).split(separator: ",")
                for erorN in newOneCollectError
                {
                    
                    self.errorArray.add(String(erorN))
                }
            }
            
            var completeError = String()
            let statusFrontOff = self.dicrDta.object(forKey: "status_front_switch") as? String
            if statusFrontOff == "0"
            {
                completeError = completeError + "Front switch is off so please turn ON switch to get the power."
                self.view.makeToast(completeError)
            }
            else
            {
                if self.countError == (self.errorArray.count)
                {
                    self.countError = 0
                }
               
                self.view.makeToast(self.createErrorString(error: (self.errorArray[self.countError] as? String)!))
                self.countError = self.countError + 1
            }
            
            
            
            if self.appDelegate.audioActive == 1
            {
                if self.highAlert == true
                {
                    self.playSound("highAlt")
                }
                else
                {
                    let systemSoundID: SystemSoundID = 1315
                    AudioServicesPlaySystemSound (systemSoundID)
                }
                
               
            }
            
        }
    }
       
       func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
           DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
               completion()
           }
       }
       
       func playSound(_ soundName: String) {
           guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
               print("URL is wrong")
               return
           }
           do {
               player = try AVAudioPlayer(contentsOf: url)
               guard let player = player else { return }

               player.prepareToPlay()
               
               player.play()

           } catch {
              print(error)
           }
       }
    
    func createErrorString(error : String) -> String
       {
           let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
           let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
           
               if (error == "0"){
                   self.getErrorString = ""
                   }else if (error == "1"){
                       self.getErrorString = "UPS Short-cicuit happened; please check the wiring"
                       // coming
                       self.highAlert = true
                   }else if (error == "2"){
                       self.getErrorString = "Short-circuit shutdown; please reset the reset switch"
                       //coming
                       self.highAlert = true
                   }else if (error == "3"){
                       self.getErrorString = "Please reduce the Load as the battery is very low"
                       //coming
                       self.highAlert = true
                   }else if (error == "4"){
                       self.getErrorString = "Battery low shutdown. Please wait for the Mains Grid to come back"
                       
                   }else if (error == "5"){
                       self.getErrorString = "Battery High Warning, the UPS will switch off automatically"
                       //coming
                       self.highAlert = true
                   }else if (error == "6"){
                       self.getErrorString = "Battery high shutdown please turn on UPS after 2 minutes."
                   }else if (error == "7"){
                       self.getErrorString = "Overload status, please reduce the load"
                       //coming
                       self.highAlert = true
                   }else if (error == "8"){
                       self.getErrorString = "Overload shutdown status, please reset the reset switch"
                       //coming
                       self.highAlert = true
                   }else if (error == "9"){
                       self.getErrorString = "Mains MCB trip, please reduce the load & lift the MCB from the back panel."
                       //coming
                       self.highAlert = true
                   }else if statusMains == "1" && error == "10" && statusUPS == "1"
                   {
                       self.getErrorString = "The mains Voltage is very low and shifted to UPS Mode; please check the Mains power"
                       self.highAlert = false
                   }
                   else if statusMains == "0" && error == "10" && statusUPS == "1"
                   {
                       self.getErrorString = "Mains Fail"
                       self.highAlert = false
                   }
                   else if statusMains == "0" && error == "10" && statusUPS == "0"
                   {
                       self.getErrorString = "Mains Fail"
                       self.highAlert = false
                   }
                   else if statusMains == "1" && error == "10" && statusUPS == "0"
                   {
                       self.getErrorString = "The mains Voltage is very low and shifted to UPS Mode; please check the Mains power"
                       self.highAlert = false
                   }
                   else if (error == "11"){
                       self.getErrorString = "The mains voltage is very high and shifted to UPS Mode; please check the Mains power"
                       self.highAlert = false
                   }else if (error == "12"){
                       self.getErrorString = "Solar High Voltage"
                       self.highAlert = false
                   }else if (error == "13"){
                       self.getErrorString = "Solar High Current"
                       self.highAlert = false
                   }
                   else if (error == "14"){
                       self.getErrorString = "The Input and Output wiring connections are reversed; please correct the wiring"
                       //coming
                       self.highAlert = true
                   }
           return self.getErrorString
          
       }
    
    
    @IBAction func tapSetting(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC{
            vcToPresent.dicrDetails = self.dicrDta
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapDiagnose(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceDiagonsisVC") as? DeviceDiagonsisVC{
            vcToPresent.isFrom = "BLE"
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapSwitch(_ sender: Any) {
        
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "1"
        {
            self.appDelegate.tappedToggelSwitch = true
            self.tabbedSwitch = true
            //off
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                
                let dict = ["status_front_switch_remote":"2"]
                if let theJSONData = try?  JSONSerialization.data(
                    withJSONObject: dict,
                    options: .prettyPrinted
                ),
                   let theJSONText = String(data: theJSONData,
                                            encoding: String.Encoding.ascii) {
                    print("JSON string = \n\(theJSONText)")
                    var newSTr = theJSONText.replacingOccurrences(of: " ", with: "")
                    newSTr = newSTr.replacingOccurrences(of: "\n", with: "")
                    
                    let data = Data(newSTr.utf8)
                    self.appDelegate.bluetoothManager.writeValue(data: data, forCharacteristic: self.appDelegate.writableCharacteristic!, type: .withResponse)
                }
            }
        }
        else
        {
            self.tabbedSwitch = false
            self.appDelegate.tappedToggelSwitch = false
            // on
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
                let dict = ["status_front_switch_remote":"1"]
                if let theJSONData = try?  JSONSerialization.data(
                    withJSONObject: dict,
                    options: .prettyPrinted
                ),
                   let theJSONText = String(data: theJSONData,
                                            encoding: String.Encoding.ascii) {
                    print("JSON string = \n\(theJSONText)")
                    var newSTr = theJSONText.replacingOccurrences(of: " ", with: "")
                    newSTr = newSTr.replacingOccurrences(of: "\n", with: "")
                    
                    let data = Data(newSTr.utf8)
                    self.appDelegate.bluetoothManager.writeValue(data: data, forCharacteristic: self.appDelegate.writableCharacteristic!, type: .withResponse)
                }
            }
           
        }
    }
    
    
    func makeVerticalAnimatedLine(line : UIView,postion : String, color : UIColor)
    {
        let layer = CAShapeLayer()
        let bound = CGRect(x: line.frame.origin.x, y: line.frame.origin.y, width: line.frame.size.width, height: line.frame.size.height)
        layer.path = UIBezierPath(roundedRect: bound, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [6, 4]
        
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = [6, 4]
        
        path.addLines(between: [CGPoint(x: line.bounds.midX, y: line.bounds.minY),
                                CGPoint(x: line.bounds.midX, y: line.bounds.maxY)])
 
        shapeLayer.path = path
        
        
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        
        if postion == "T"
        {
            animation.toValue = layer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        }
        else
        {
            animation.toValue = layer.lineDashPattern?.reduce(layer.lineDashPattern?.count) { $0! + $1.intValue } ?? 0
        }

        animation.duration = 0.3
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: "line")
        
        
        line.layer.addSublayer(shapeLayer)
    }
    
    func makeHorizotalAnimatedLine(line : UIView,postion : String, color : UIColor)
    {
        let layer = CAShapeLayer()
        let bound = CGRect(x: line.frame.origin.x, y: line.frame.origin.y, width: line.frame.size.width, height: line.frame.size.height)
        layer.path = UIBezierPath(roundedRect: bound, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 20, height: 20)).cgPath
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [6, 4]
        
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = [6, 4]
        
        path.addLines(between: [CGPoint(x: line.bounds.minX, y: line.bounds.midY),
                                CGPoint(x: line.bounds.maxX, y: line.bounds.midY)])
 
        shapeLayer.path = path
        
        
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        
        if postion == "L"
        {
            animation.toValue = layer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        }
        else
        {
            animation.toValue = layer.lineDashPattern?.reduce(layer.lineDashPattern?.count) { $0! + $1.intValue } ?? 0
        }

        animation.duration = 0.3
        animation.repeatCount = .infinity
        shapeLayer.add(animation, forKey: "line")
        
        
        line.layer.addSublayer(shapeLayer)
    }
    
 
    
}

extension UIView {
    enum dashedOrientation {
        case horizontal
        case vertical
    }
    
    func makeDashedBorderLine(color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat, orientation: dashedOrientation) {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = [8, 6]
        if orientation == .vertical {
            path.addLines(between: [CGPoint(x: bounds.midX, y: bounds.minY),
                                    CGPoint(x: bounds.midX, y: bounds.maxY)])
        } else if orientation == .horizontal {
            path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.midY),
                                    CGPoint(x: bounds.maxX, y: bounds.midY)])
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = shapeLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.duration = 1
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "line")
    }
    
    
}
