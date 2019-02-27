import UIKit
import AVFoundation
import Speech
import SwiftyWave



class TalkViewController: UIViewController{
    
    @IBOutlet weak var detectedTextLabel: UILabel!
    
 
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    let instructionBank = InstructionBank()
    
    let waveView = SwiftyWaveView(frame: CGRect(x: 5, y: 650, width: 375, height: 100))
    
    
//      let voice = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      voice.delegate = self
        
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
        assistantSpeak(number: 0)
        detectedTextLabel.text = instructionBank.list[0].sentence
        recordAndRecognizeSpeech()
        
        
        isRecording = true
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
        case "okay", "Okay":
            print("OK")
        case "next", "Next":
            print("NEXT")
            assistantSpeak(number: 1)
            detectedTextLabel.text = instructionBank.list[1].sentence
            waveView.start()
        case "no", "No":
            print("NO")
        case "yes", "Yes":
            print("YES")
            assistantSpeak(number: 3)
            detectedTextLabel.text = instructionBank.list[3].sentence
            waveView.start()
        case "Scania":
            assistantSpeak(number: 0)
            print("SCANIA")
        case "help", "Help":
            print("HELP")
            assistantSpeak(number: 2)
            detectedTextLabel.text = instructionBank.list[2].sentence
            waveView.start()
            
        default: break
        }
    }
    
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        print("Speech finished")
//
////        voice.stopSpeaking(at: .immediate)
//        voice.pauseSpeaking(at: .immediate)
//            waveView.stop()
//
//
//    }
    
}
