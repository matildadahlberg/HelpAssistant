import Foundation

class InstructionBank {
    
    var list = [InstructionModel]()
    
    init() {
        
        list.append(InstructionModel(sentence: "Hello my name is Scania and I will be your assistant. Make sure that the engine is off ", state: 0))
        list.append(InstructionModel(sentence: "Do some thing with the tire on the left backside of the car. Do you need more explanation", state: 1))
        list.append(InstructionModel(sentence: "The tire is out of air, fullfill the tire to make sure everything is under controll. The amount of air is declared at the inside of fuel cap. Do you want to know more", state: 2))
        list.append(InstructionModel(sentence: "Blablabla", state: 3))
        
        
    }
    
    
    
}


