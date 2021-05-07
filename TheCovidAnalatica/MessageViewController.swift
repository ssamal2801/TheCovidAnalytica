//
//  MessageViewController.swift
//  TheCovidAnalatica
//
//  Created by Gokul on 27/04/21.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageLabel.text = "1.Wear a mask that covers your nose and mouth to help protect yourself and others.\n 2.Stay 6 feet apart from others who don't live with you. \n 3.Get a COVID-19 vaccine when it is available to you. \n 4.Avoid crowds and poorly ventilated indoor spaces. \n 5.Wash your hands often with soap and water. \n - Source: www.cdc.govt"
    }
    @IBOutlet weak var messageLabel: UILabel!
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
