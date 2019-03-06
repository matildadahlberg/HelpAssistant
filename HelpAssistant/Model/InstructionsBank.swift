import Foundation

class InstructionBank {
    // consider moving all these to an Extension on Instruction Model
    // then you get named things, rather than relying on indexes in a list
    var list = [InstructionModel]()
    
    init() {
        
        list.append(InstructionModel(sentence: "Hello, I am your assistant.", explenation: ""))
        
        list.append(InstructionModel(sentence: "You need to refill the oil", explenation: "Fill up the oil 10 centimeters"))
        
        list.append(InstructionModel(sentence: "Fuel is diesel", explenation: "Fill the tank with 1 liter"))
        
        list.append(InstructionModel(sentence: "Fullfill the air pressure in the left front tire", explenation: "The amount of air is declared at the inside of fuel cap"))
        
        list.append(InstructionModel(sentence: "Engine is all good, nothing to do", explenation: "Nothing to do, you can go back"))
        
        list.append(InstructionModel(sentence: "Sorry i couldn't here you. You can make an option by voice or by pressing any button", explenation: ""))
        
        
        
    }
    
    
    
}


