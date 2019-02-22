//
//  ViewController.swift
//  HelpAssistant
//
//  Created by Matilda Dahlberg on 2019-02-22.
//  Copyright © 2019 Matilda Dahlberg. All rights reserved.
//

import UIKit
import Speech

class ListenViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var detectedTextLabel: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestSpeechAuthorization()
        
        self.recordAndRecognizeSpeech()
        isRecording = true
        
    }
  
    
    //MARK: - Recognize Speech
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
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                self.checkForWordsSaid(resultString: lastString)
            } else if let error = error {
                self.sendAlert(message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.detectedTextLabel.text = "User access"
                case .denied:
                    self.detectedTextLabel.text = "User denied access to speech recognition"
                case .restricted:
                    self.detectedTextLabel.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.detectedTextLabel.text = "Speech recognition not yet authorized"
                }
            }
        }
    }
    
    //MARK: - Word recognizer.
    
    func checkForWordsSaid(resultString: String) {
        switch resultString {
        case "okay":
            detectedTextLabel.text = "DU SA OK"
            view.backgroundColor = UIColor.green
        //if person say ok
        case "next":
            detectedTextLabel.text = "DU SA NEXT"
            view.backgroundColor = UIColor.blue
        //if person say next
        case "no":
            detectedTextLabel.text = "DU SA NO"
            view.backgroundColor = UIColor.yellow
        //if person say no
        case "yes":
            detectedTextLabel.text = "DU SA YES"
            view.backgroundColor = UIColor.red
            //if person say yes
            
        default: break
        }
    }
    
    
    
}







