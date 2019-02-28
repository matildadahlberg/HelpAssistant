import UIKit
import AVFoundation
import Speech
import SwiftyWave

class StartViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet var allTheButtons: [UIButton]! // this is an Outlet Collection, made from the storyboard
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let instructionBank = InstructionBank()
    let voice = AVSpeechSynthesizer()
    let waveView = SwiftyWaveView(frame: CGRect(x: 5, y: 650, width: 375, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(waveView)
        waveView.color = UIColor.black
        waveView.start()
        
        voice.delegate = self
        
        allTheButtons.forEach { (button) in
            button.layer.cornerRadius = 15
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error")
        }
        assistantSpeak(instructionModel: .welcome)
        recordAndRecognizeSpeech()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allTheButtons.forEach { (button) in
            button.isUserInteractionEnabled = true
        }
    }
    
    func assistantSpeak(instructionModel: InstructionModel) {
        var textLine = AVSpeechUtterance()
        let instruction = instructionModel.sentence
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
        switch resultString { // if you .lowerCase the string first, then you don't need to handle all the case variations
        case "oil", "Oil":
            performSegue(withIdentifier: "segueID", sender: 1)
        case "fuel", "Fuel":
            performSegue(withIdentifier: "segueID", sender: 2)
        case "tire", "Tire":
            performSegue(withIdentifier: "segueID", sender: 3)
        case "engine", "Engine":
            performSegue(withIdentifier: "segueID", sender: 4)
        default: break
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let button = sender as? UIButton
        button?.isUserInteractionEnabled = false
        // maybe need to check if an animation is already in progress before calling performSegue.
        self.performSegue(withIdentifier: "segueID", sender: button?.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TalkViewController, let number = sender as? Int {
            vc.number = number
        }
    }
  
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finish")
        waveView.stop()
    }
    
}
