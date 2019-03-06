import Foundation
import AVFoundation

class AssistantSpeak {
    
    let instructionBank = InstructionBank()
    let voice = AVSpeechSynthesizer()
    var textLine = AVSpeechUtterance()
    var identifier: String = UserDefaults.standard.string(forKey: "identifier") ?? "com.apple.ttsbundle.siri_female_en-US_compact"
    var rate : Float = UserDefaults.standard.float(forKey: "rate")

    
    // MARK: FUNCTION IS SAYING THE SENTENSE
    func assistantSpeak(number: Int) {
        let instruction = instructionBank.list[number].sentence
        textLine = AVSpeechUtterance(string: instruction)
        textLine.voice = AVSpeechSynthesisVoice(identifier: identifier)
        textLine.rate = rate
        voice.speak(textLine)
    }
    
      // MARK: FUNCTION IS SAYING THE EXPLENATION
    func assistantSpeakExplenation(number: Int) {
        let instruction = instructionBank.list[number].explenation
        textLine = AVSpeechUtterance(string: instruction)
        textLine.voice = AVSpeechSynthesisVoice(identifier: identifier)
        textLine.rate = rate
        voice.speak(textLine)
    }
}
