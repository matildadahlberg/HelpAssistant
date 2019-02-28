import UIKit
import AVFoundation
import Speech
import SwiftyWave

class StartViewController: UIViewController, AVSpeechSynthesizerDelegate {
    @IBOutlet weak var oilOutlet: UIButton!
    @IBOutlet weak var fuelOutlet: UIButton!
    @IBOutlet weak var tireOutlet: UIButton!
    @IBOutlet weak var engineOutlet: UIButton!
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let instructionBank = InstructionBank()
    var number = 0
    let voice = AVSpeechSynthesizer()
    let waveView = SwiftyWaveView(frame: CGRect(x: 5, y: 650, width: 375, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(waveView)
        waveView.color = UIColor.black
        waveView.start()
        
        voice.delegate = self
        
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
        var textLine = AVSpeechUtterance()
        let instruction = instructionBank.list[number].sentence
        textLine = AVSpeechUtterance(string: instruction)
        textLine.rate = 0.4
        textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
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
            number = 1
            performSegue(withIdentifier: "segueID", sender: self)
        case "fuel", "Fuel":
            number = 2
            performSegue(withIdentifier: "segueID", sender: self)
        case "tire", "Tire":
            number = 3
            performSegue(withIdentifier: "segueID", sender: self)
        case "engine", "Engine":
            number = 4
            performSegue(withIdentifier: "segueID", sender: self)
        default: break
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let button = sender as! UIButton
        let number = button.tag
        self.number = number
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TalkViewController {
            vc.number = number
        }
    }
  
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finish")
        waveView.stop()
    }
    
}
