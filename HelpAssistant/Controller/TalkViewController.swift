import UIKit
import AVFoundation
import Speech
import SwiftyWave

class TalkViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var detectedTextLabel: UILabel!
    @IBOutlet weak var waveAnimation: SwiftyWaveView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var number = 0
    let instructionBank = InstructionBank()
    var isListening: Bool = false
    let voice = AVSpeechSynthesizer()
    var textLine = AVSpeechUtterance()
    var isFinal = false
    var speechTime = Timer()
    var speechSec = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        isFinal = true
        voice.delegate = self
        waveAnimation.start()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error")
        }
        assistantSpeak(number: number)
        detectedTextLabel.text = instructionBank.list[number].sentence
        
        speechTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        speechSec += 1
        if speechSec == 1{
            recordAndRecognizeSpeech()
        }
        if speechSec == 55{
            recognitionTask?.cancel()
            audioEngine.inputNode.removeTap(onBus: 0)
            speechSec = 0
        }
    }
    
    func assistantSpeak(number: Int) {
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
                    lastString = bestString.substring(from: indexTo).lowercased()
                }
                self.checkForWordsSaid(resultString: lastString)
            } else if let error = error {
                print(error)
            }
        })
    }
    
    func checkForWordsSaid(resultString: String) {
        switch resultString {
        case "repeat":
            let instruction = instructionBank.list[number].sentence
            textLine = AVSpeechUtterance(string: instruction)
            textLine.rate = 0.4
            textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
            detectedTextLabel.text = instructionBank.list[number].sentence
            if self.isFinal {
                voice.speak(textLine)
                isFinal = false
            }
            waveAnimation.start()
            
        case "help":
            let instruction = instructionBank.list[number].explenation
            textLine = AVSpeechUtterance(string: instruction)
            textLine.rate = 0.4
            textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
            detectedTextLabel.text = instructionBank.list[number].explenation
            if self.isFinal {
                voice.speak(textLine)
                isFinal = false
            }
            waveAnimation.start()
        case "back":
            performSegue(withIdentifier: "backID", sender: self)
        default: break
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        waveAnimation.stop()
        if isFinal == false{
            self.voice.stopSpeaking(at: .word)
            isFinal = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        voice.stopSpeaking(at: .immediate)
        waveAnimation.stop()
        speechTime.invalidate()
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
