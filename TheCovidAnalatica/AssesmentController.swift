//
//  AssesmentController.swift
//  TheCovidAnalatica
//
//  Created by user186957 on 4/27/21.
//

import UIKit

class AssesmentController: UIViewController {
    
    var count = 0
    
    @IBOutlet weak var queryLabel: UITextView!
    @IBOutlet weak var toggleButton: UISwitch!
    @IBOutlet weak var buttonLabel: UIButton!
    
    let questions: [String] = ["Do you have problem breathing?", "Do you have a headache or nausea?", "Were you a close contact of a covid19 positive person in past 7 days?", "Do you have dry cough?", "Do you have a loss of smell or test in last 7 days?", "Do you have a fever in last 7 days?"]
    
    var risk = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryLabel.text = questions[count]
        count = count + 1
    }

    
    @IBAction func startTest(_ sender: Any) {
        
        //after answering all questions
        if count == questions.count {
            
            buttonLabel.isHidden = true
            toggleButton.isHidden = true
            
            var result :String = risk == 0 ? "You are at low risk. Please follow covid19 protocol and use this test if you see any symptoms" : "You are at high risk, please follow social distancing and take a test asap. We are all in this together!"
            
            displayResult(result);
            
        } else {
                        
            if toggleButton.isOn {
                risk = risk + 1
            }
            queryLabel.text = questions[count]
            count = count + 1
            toggleButton.isOn = false
            
        }
    }
    
    func displayResult(_ message : String)
    {

        // Create UI Alert Controller
        let alertController = UIAlertController(title: "Your Result", message: message, preferredStyle: .alert)

        // Add Cancel Button to Alert Controller
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alertController, animated: true)

    }


}
