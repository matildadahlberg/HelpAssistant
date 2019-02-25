import UIKit
import AVFoundation
import Speech

class TalkViewController: UIViewController {
    
    @IBOutlet weak var detectedTextLabel: UILabel!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    
//    var instruction1 = AVSpeechUtterance(string: "Go to the back of the car")
    var instruction2 = AVSpeechUtterance(string: "Jump up and down")
    
    
    let voice = AVSpeechSynthesizer()

    var textLine = AVSpeechUtterance(string: "Hello my name is Scania and I will be your assistance")

    
    var number = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        requestSpeechAuthorization()
        
        recordAndRecognizeSpeech()
        isRecording = true
        
        

    
    }
//
//    @IBAction func nextQuestion(_ sender: Any) {
//
//        if number == 0 {
//            instruction1.rate = 0.4
//            instruction1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
//            voice.speak(instruction1)
//        }
//
//        if number == 1 {
//            instruction2.rate = 0.4
//            instruction2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
//            voice.speak(instruction2)
//        }
//
//        number += 1
//
//
//    }
    
    
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
            
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            
            return
        }
        if !myRecognizer.isAvailable {
            
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
        case "okay", "Okay":
            //if person say ok
            detectedTextLabel.text = "DU SA OK"
        case "next", "Next":
            //if person say next
            detectedTextLabel.text = "DU SA NEXT"
            let instruction1 = AVSpeechUtterance(string: "Go to the back of the car")
            instruction1.rate = 0.4
            instruction1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
            voice.speak(instruction1)
            
        case "no", "No":
            //if person say no
            detectedTextLabel.text = "DU SA NO"
        case "yes", "Yes":
             //if person say yes
            detectedTextLabel.text = "DU SA YES"
        case "Scania":
             //if person say hi scania
            print("DEN hötrde")
            textLine.rate = 0.4
            textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
            voice.speak(textLine)
            textLine = AVSpeechUtterance(string: "")
        case "help", "Help":
            //if person say hi help
            detectedTextLabel.text = "HELP"
            instruction2.rate = 0.4
            instruction2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
            voice.speak(instruction2)
            instruction2 = AVSpeechUtterance(string: "")
            
           
            
        default: break
        }
    }
    
}
