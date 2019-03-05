import Foundation
import Speech

enum KeyWord{
    case oil
    case fuel
    case tire
    case engine

    static func fromValue(value: String) -> KeyWord?{
        switch value {
        case "oil":
            return .oil
        case "fuel":
            return .fuel
        case "tire":
            return .tire
        case "engine":
            return .engine
        default: break
        }
        return .oil
    }
}

class VoiceRecognitionManager {

    let keyWords: [KeyWord]
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer() //TODO - byt ut mot speach recognition handler/engine/manager
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    init(keyWords: [KeyWord]) {
        self.keyWords = keyWords

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in

            if let result = result {
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo).lowercased()
                }
                self.onKeyWordSaid(keywordString: lastString)
            } else if let error = error {
                print(error)
            }
        })
    }

    private func onKeyWordSaid(keywordString: String) {
        if let keyword = KeyWord.fromValue(value: keywordString), keyWords.contains(keyword) {
            onKeyWordDetected?(keyword)
            
            switch keyword {
            case .oil:
                onKeyWordDetected!(.oil)
            case .fuel:
                onKeyWordDetected!(.fuel)
            case .tire:
                onKeyWordDetected!(.tire)
            case .engine:
                onKeyWordDetected!(.engine)
            default: break
            }
        }
    }

    var onKeyWordDetected: ((KeyWord) -> Void)?

    func start(){
        //TODO - setup listeners/start listen for speach recognition
    }

    func stop(){
        //TODO - setup listeners/start listen for speach recognition
    }
}

