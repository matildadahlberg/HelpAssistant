//
//  SettingsViewController.swift
//  HelpAssistant
//
//  Created by Matilda Dahlberg on 2019-03-04.
//  Copyright © 2019 Matilda Dahlberg. All rights reserved.
//

import UIKit
import AVFoundation


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
   
    var list = ["Male", "Female"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var slider: UISlider!
    
    let instructionBank = InstructionBank()
    let voice = AVSpeechSynthesizer()
    var number = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //here is programatically switch make to the table view
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row // for detect which row switch Changed
        
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
        if sender.tag == 0{
            assistantSpeakMale(number: number)
         
        }
        if sender.tag == 1{
            assistantSpeakFemale(number: number)
        }
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        if !sender.isOn {
            voice.stopSpeaking(at: .immediate)
        }

    }
    
  
    

    
    @IBAction func sliderValue(_ sender: UISlider) {
       
//        textfield.text = String(sender.value)
    }
    
    func assistantSpeakFemale(number: Int) {
        var textLine = AVSpeechUtterance()
        let instruction = instructionBank.list[number].sentence
        textLine = AVSpeechUtterance(string: instruction)
        textLine.rate = 0.4
        textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
        voice.speak(textLine)
    }
    func assistantSpeakMale(number: Int) {
        var textLine = AVSpeechUtterance()
        let instruction = instructionBank.list[number].sentence
        textLine = AVSpeechUtterance(string: instruction)
        textLine.rate = 0.4
        textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
        voice.speak(textLine)
    }
    

}
