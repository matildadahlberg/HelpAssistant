import Foundation

class InstructionBank {
    
    var list = [InstructionModel]()
    
    init() {
        
        list.append(InstructionModel(sentence: "Hello my name is Scania and I will be your assistant. Make sure that the engine is turned off ", explenation: ""))
        
        list.append(InstructionModel(sentence: "The oil is oliveoil", explenation: "Fill up the oil 10 centimeters"))
        
        list.append(InstructionModel(sentence: "Fuel is deisel", explenation: "Fill the diesel with 1 liter"))
        
        list.append(InstructionModel(sentence: "Fullfill the air pressure in the left front tire", explenation: "The amount of air is declared at the inside of fuel cap"))
        
        list.append(InstructionModel(sentence: "Engine is all good, nothing to do", explenation: ""))
        
        
    }
    
    
    
}


