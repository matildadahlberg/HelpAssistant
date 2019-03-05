import UIKit
import AVFoundation
import Speech
import SwiftyWave

class StartViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet var allTheButtons: [UIButton]! // this is an Outlet Collection, made from the storyboard
    @IBOutlet weak var waveAnimation: SwiftyWaveView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var seconds = 0
    var timer = Timer()
    var speechTime = Timer()
    var speechSec = 0
    
    var assistantSpeak = AssistantSpeak()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assistantSpeak.voice.delegate = self
 
        allTheButtons.forEach { (button) in
            button.layer.cornerRadius = 15
            button.layer.borderColor = UIColor.red.cgColor
            button.layer.borderWidth = 1
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error")
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.flag), userInfo: nil, repeats: true)
        speechTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        waveAnimation.start()
        assistantSpeak.assistantSpeak(number: 0)
    }
    
    @objc func flag(){
        seconds += 1
        
        if seconds == 25{
            assistantSpeak.assistantSpeak(number: 5)
            waveAnimation.start()
            seconds = 0
        }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allTheButtons.forEach { (button) in
            button.isUserInteractionEnabled = true
        }
         navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
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
        case "oil":
            performSegue(withIdentifier: "segueID", sender: 1)
        case "fuel":
            performSegue(withIdentifier: "segueID", sender: 2)
        case "tire":
            performSegue(withIdentifier: "segueID", sender: 3)
            print("TIRE SEGUE")
        case "engine":
            performSegue(withIdentifier: "segueID", sender: 4)
        default: break
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let button = sender as? UIButton
        button?.isUserInteractionEnabled = false
        cancelActivities()
        self.performSegue(withIdentifier: "segueID", sender: button?.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TalkViewController, let number = sender as? Int {
            vc.number = number
            cancelActivities()
        }
        cancelActivities()

    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        waveAnimation.stop()
    }
    
    @IBAction func settingPressed(_ sender: Any) {
        cancelActivities()
    }
    
    func cancelActivities() {
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        recognitionTask?.cancel()
        waveAnimation.stop()
        timer.invalidate()
        speechTime.invalidate()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
