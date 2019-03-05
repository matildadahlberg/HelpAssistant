import UIKit
import AVFoundation

class SettingsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
   
    @IBOutlet weak var slider: UISlider!
    
    var assistantSpeak = AssistantSpeak()
    
    override func viewDidLoad() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true

    }
    
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        
        if sender.tag == 0{
            assistantSpeak.identifier = "com.apple.ttsbundle.siri_female_en-US_compact"
            assistantSpeak.assistantSpeak(number: 0)
        }
   
        
        if sender.tag == 1{
            assistantSpeak.identifier = "com.apple.ttsbundle.siri_male_en-US_compact"
            assistantSpeak.assistantSpeak(number: 0)
        }
        
        if !sender.isOn {
            assistantSpeak.voice.stopSpeaking(at: .immediate)
        }
        
    }
    
    
    @IBAction func sliderValue(_ sender: UISlider) {
        
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("touch began")
            // handle drag began
            case .moved:
               
                print("touch move")
            // handle drag moved
            case .ended:
                print("touch ended")
            // handle drag ended
            default:
                break
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "backSeg", sender: self)
    }
    
    
}
