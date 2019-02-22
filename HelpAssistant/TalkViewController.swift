import UIKit
import AVFoundation

class TalkViewController: UIViewController {
    
    let instruction1 = AVSpeechUtterance(string: "Go to the back of the car")
    let instruction2 = AVSpeechUtterance(string: "Jump up and down")
    
    
    let voice = AVSpeechSynthesizer()

    var textLine = AVSpeechUtterance(string: "Hello my name is Scania and I will be your assistance")

    
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLine.rate = 0.4
        textLine.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
        voice.speak(textLine)
        

    
    }
    
    @IBAction func nextQuestion(_ sender: Any) {
        
        if number == 0 {
            instruction1.rate = 0.4
            instruction1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
            voice.speak(instruction1)
        }
        
        if number == 1 {
            instruction2.rate = 0.4
            instruction2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
            voice.speak(instruction2)
        }
        
        number += 1
        
        
    }
    
}
