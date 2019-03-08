import UIKit
import AVFoundation
import AudioToolbox

class SettingsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var femaleOnOutlet: UISwitch!
    @IBOutlet weak var maleOnOutlet: UISwitch!
    
    var assistantSpeak = AssistantSpeak()
    
    override func viewDidLoad() {
        
        if UserDefaults.standard.string(forKey: "identifier") == "com.apple.ttsbundle.siri_female_en-US_compact" {
            femaleOnOutlet.isOn = true
            maleOnOutlet.isOn = false
        }
        else if UserDefaults.standard.string(forKey: "identifier") == "com.apple.ttsbundle.siri_male_en-US_compact"  {
            femaleOnOutlet.isOn = false
            maleOnOutlet.isOn = true
        }
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        
        slider.value = UserDefaults.standard.float(forKey: "rate")
        
    }
    @objc func backButtonPressed() {
        
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func femaleOn(_ sender: UISwitch) {
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        assistantSpeak.identifier = "com.apple.ttsbundle.siri_female_en-US_compact"
        femaleOnOutlet.isOn = true
        maleOnOutlet.isOn = false
        assistantSpeak.rate = slider.value
        assistantSpeak.assistantSpeak(number: 0)
        UserDefaults.standard.set("com.apple.ttsbundle.siri_female_en-US_compact", forKey: "identifier")
    }
    
    @IBAction func maleOn(_ sender: UISwitch) {
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        assistantSpeak.identifier = "com.apple.ttsbundle.siri_male_en-US_compact"
        femaleOnOutlet.isOn = false
        maleOnOutlet.isOn = true
        assistantSpeak.rate = slider.value
        assistantSpeak.assistantSpeak(number: 0)
        UserDefaults.standard.set("com.apple.ttsbundle.siri_male_en-US_compact", forKey: "identifier")
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                assistantSpeak.voice.stopSpeaking(at: .immediate)
            case .ended:
                assistantSpeak.rate = slider.value
                assistantSpeak.assistantSpeak(number: 0)
                UserDefaults.standard.set(slider.value, forKey: "rate")
            default:
                break
            }
        }
    }
    
 
}
