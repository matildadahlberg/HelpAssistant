import Foundation
import AVFoundation

class AssistantSpeak {
    
    let instructionBank = InstructionBank()
    let voice = AVSpeechSynthesizer()
    var textLine = AVSpeechUtterance()
    var identifier: String = "com.apple.ttsbundle.siri_female_en-US_compact"
    var rate : Float = 0.5
    
    
    func assistantSpeak(number: Int) {
        let instruction = instructionBank.list[number].sentence
        textLine = AVSpeechUtterance(string: instruction)
        textLine.voice = AVSpeechSynthesisVoice(identifier: identifier)
        textLine.rate = rate
        voice.speak(textLine)
    }
}
