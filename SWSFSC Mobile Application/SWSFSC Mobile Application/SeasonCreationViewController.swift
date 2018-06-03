//
//  SeasonCreationViewController.swift
//  SWSFSC Mobile Application
//
//  Created by Flemming Eriksen on 03/06/2018.
//  Copyright © 2018 Flemming Eriksen. All rights reserved.
//

import UIKit

class SeasonCreationViewController: UIViewController
{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptPressed(_ sender: Any)
    {
        if let name = nameField.text
        {
            let season = Season(name: name, start_date: startDatePicker.date, end_date: endDatePicker.date)
            API.Seasons.create(season: season, completion:
            { (success) in
                if success
                {
                    self.performSegue(withIdentifier: "unwindToSeasons", sender: nil)
                }
                else
                {
                    self.presentErrorAlert(errorText: "An error ocurred")
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
