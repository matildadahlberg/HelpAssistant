import Foundation

class InstructionModel {
    
    var sentence : String
    var state : Int
    
    init(sentence : String, state : Int) {
        self.sentence = sentence
        self.state = state
    }
}
