import UIKit
import AVFoundation
import AudioToolbox

class SettingsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var femaleOnOutlet: UISwitch!
    @IBOutlet weak var maleOnOutlet: UISwitch!
    
    var assistantSpeak = AssistantSpeak()
    
    override func viewDidLoad() {
        if UserDefaults.standard.string(forKey: "identifire") == "com.apple.ttsbundle.siri_female_en-US_compact" {
            femaleOnOutlet.isOn = true
            maleOnOutlet.isOn = false
        } else {
            femaleOnOutlet.isOn = false
            maleOnOutlet.isOn = true
        }
        slider.value = UserDefaults.standard.float(forKey: "rate")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func femaleOn(_ sender: UISwitch) {
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        femaleOnOutlet.isOn = true
        maleOnOutlet.isOn = false
        assistantSpeak.identifier = "com.apple.ttsbundle.siri_female_en-US_compact"
        assistantSpeak.rate = slider.value
        assistantSpeak.assistantSpeak(number: 0)
        UserDefaults.standard.set("com.apple.ttsbundle.siri_female_en-US_compact", forKey: "identifire")
    }
    
    @IBAction func maleOn(_ sender: UISwitch) {
        assistantSpeak.voice.stopSpeaking(at: .immediate)
        femaleOnOutlet.isOn = false
        maleOnOutlet.isOn = true
        assistantSpeak.identifier = "com.apple.ttsbundle.siri_male_en-US_compact"
        assistantSpeak.assistantSpeak(number: 0)
        UserDefaults.standard.set("com.apple.ttsbundle.siri_male_en-US_compact", forKey: "identifire")
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
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backSeg", sender: self)
        assistantSpeak.voice.stopSpeaking(at: .immediate)
    }
}
