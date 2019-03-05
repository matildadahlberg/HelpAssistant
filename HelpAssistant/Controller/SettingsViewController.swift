import UIKit
import AVFoundation

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
    
    var list = ["Female", "Male"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: UISlider!
    
    var assistantSpeak = AssistantSpeak()
    
    override func viewDidLoad() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let switchView = UISwitch(frame: .zero)
        switchView.tag = indexPath.row
        
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        
        return cell
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
}
