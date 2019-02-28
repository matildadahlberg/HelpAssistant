import UIKit
import AVFoundation
import Speech
import SwiftyWave



class TalkViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var detectedTextLabel: UILabel!
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    let instructionBank = InstructionBank()
    var number = 0
    
    var isListening: Bool = false
    
    let voice = AVSpeechSynthesizer()
    var textLine = AVSpeechUtterance()
    
    var isFinal = false

    
    
    let waveView = SwiftyWaveView(frame: CGRect(x: 5, y: 650, width: 375, height: 100))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(number)
        isFinal = true
        
        voice.delegate = self
        
        self.view.addSubview(waveView)
        waveView.color = UIColor.black
        waveView.start()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error")
        }
        assistantSpeak(number: number)
        detectedTextLabel.text = instructionBank.list[number].sentence
        recordAndRecognizeSpeech()
        
    }
    
    func assistantSpeak(number : Int) {
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
        case "repeat", "Repeat":
            print("NEXT")
//            assistantSpeak(number: number)
//            detectedTextLabel.text = instructionBank.list[number].sentence
            let instruction = instructionBank.list[number].sentence
            textLine = AVSpeechUtterance(string: instruction)
            textLine.rate = 0.4
            textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
            if self.isFinal {
                voice.speak(textLine)
                isFinal = false
                
            }
            waveView.start()
        
        case "help", "Help":
            print("HELP")
            let instruction = instructionBank.list[number].explenation
            textLine = AVSpeechUtterance(string: instruction)
            textLine.rate = 0.4
            textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
            
            detectedTextLabel.text = instructionBank.list[number].explenation
            if self.isFinal {
                voice.speak(textLine)
                isFinal = false
                
            }
           
            waveView.start()
        case "back", "Back":
            performSegue(withIdentifier: "backID", sender: self)
            
        default: break
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speech finished")
        waveView.stop()
        if isFinal == false{
            self.voice.stopSpeaking(at: .word)
            isFinal = true
        }
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("speech cancel")
        
    }
 
  
    
}
