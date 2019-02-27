//
//  StartViewController.swift
//  HelpAssistant
//
//  Created by Matilda Dahlberg on 2019-02-27.
//  Copyright © 2019 Matilda Dahlberg. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SwiftyWave

class StartViewController: UIViewController {
    @IBOutlet weak var oilOutlet: UIButton!
    
    @IBOutlet weak var fuelOutlet: UIButton!
    @IBOutlet weak var tireOutlet: UIButton!
    @IBOutlet weak var engineOutlet: UIButton!
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let instructionBank = InstructionBank()

    
    let waveView = SwiftyWaveView(frame: CGRect(x: 5, y: 650, width: 375, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(waveView)
        waveView.color = UIColor.black
        waveView.start()
        
        oilOutlet.layer.cornerRadius = 15
        fuelOutlet.layer.cornerRadius = 15
        tireOutlet.layer.cornerRadius = 15
        engineOutlet.layer.cornerRadius = 15
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error")
        }
        assistantSpeak(number: 0)
        recordAndRecognizeSpeech()
        
    }
    
    func assistantSpeak(number : Int) {
        let voice = AVSpeechSynthesizer()
        var textLine = AVSpeechUtterance()
        let instruction = instructionBank.list[number].sentence
        textLine = AVSpeechUtterance(string: instruction)
        textLine.rate = 0.5
        textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
        
        voice.speak(textLine)
        
        
        
        
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            self.waveView.stop()
            
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                self.checkForWordsSaid(resultString: lastString)
            } else if let error = error {
                print(error)
            }
        })
    }
    
    
    
    func checkForWordsSaid(resultString: String) {
        switch resultString {
        case "oil", "Oil":
            print("OK")
            performSegue(withIdentifier: "segueID", sender: self)
        case "fuel", "Fuel":
            print("OK")
            performSegue(withIdentifier: "segueID", sender: self)
            
        case "tire", "Tire":
            print("OK")
            performSegue(withIdentifier: "segueID", sender: self)
            
        case "engine", "Engine":
            print("OK")
            performSegue(withIdentifier: "segueID", sender: self)
            
            
        default: break
        }
    }
  
    
}
