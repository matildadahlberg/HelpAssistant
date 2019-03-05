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
    var isFinal = false
    var speechTime = Timer()
    var speechSec = 0
    var assistantSpeak = AssistantSpeak()

    override func viewDidLoad() {
        super.viewDidLoad()
        isFinal = true
        assistantSpeak.voice.delegate = self
        waveAnimation.start()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error")
        }
        assistantSpeak.assistantSpeak(number: number)
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
            detectedTextLabel.text = instructionBank.list[number].sentence
            if self.isFinal {
                assistantSpeak.assistantSpeak(number: number)
                isFinal = false
            }
            waveAnimation.start()
            
        case "help":
            detectedTextLabel.text = instructionBank.list[number].explenation
            if self.isFinal {
                assistantSpeak.assistantSpeakExplenation(number: number)
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
            assistantSpeak.voice.stopSpeaking(at: .word)
            isFinal = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        waveAnimation.stop()
        speechTime.invalidate()
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
