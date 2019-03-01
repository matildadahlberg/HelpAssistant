import Foundation

class InstructionBank {
    // consider moving all these to an Extension on Instruction Model
    // then you get named things, rather than relying on indexes in a list
    var list = [InstructionModel]()
    
    init() {
        
        list.append(InstructionModel(sentence: "Hello my name is Scania and I will be your assistant.", explenation: ""))
        
        list.append(InstructionModel(sentence: "The oil is olive oil", explenation: "Fill up the oil 10 centimeters"))
        
        list.append(InstructionModel(sentence: "Fuel is deisel", explenation: "Fill the diesel with 1 liter"))
        
        list.append(InstructionModel(sentence: "Fullfill the air pressure in the left front tire", explenation: "The amount of air is declared at the inside of fuel cap"))
        
        list.append(InstructionModel(sentence: "Engine is all good, nothing to do", explenation: ""))
        
        
    }
    
    
    
}


