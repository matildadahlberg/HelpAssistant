import Foundation
import AVFoundation

class Audio {
    
    func audioOutput(){
        let session = AVAudioSession.sharedInstance()
        let currentRoute = session.currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones || description.portType == AVAudioSession.Port.bluetoothA2DP {
                    do {
                        try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .allowBluetoothA2DP)
                        try session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
                        try session.setActive(true)
                    } catch {
                        print("Couldn't override output audio port")
                    }
                } else {
                    do {
                        try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
                        try session.setActive(true, options: .notifyOthersOnDeactivation)
                    } catch {
                        print("Error")
                    }
                }
            }
        } else {
            print("requires connection to device")
        }
    }
}

