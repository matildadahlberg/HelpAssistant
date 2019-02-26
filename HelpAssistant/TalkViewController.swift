import UIKit
import AVFoundation
import Speech

class TalkViewController: UIViewController {
    
    @IBOutlet weak var detectedTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var animationView: UIView!
    
    
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    let instructionBank = InstructionBank()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        case "no", "No":
            print("NO")
        case "yes", "Yes":
            print("YES")
            assistantSpeak(number: 3)
            detectedTextLabel.text = instructionBank.list[3].sentence
        case "Scania":
            assistantSpeak(number: 1)
            print("SCANIA")
        case "help", "Help":
            print("HELP")
            assistantSpeak(number: 2)
            detectedTextLabel.text = instructionBank.list[2].sentence
      
        default: break
        }
    }
    
}
