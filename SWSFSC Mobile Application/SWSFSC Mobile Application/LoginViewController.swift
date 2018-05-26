//
//  ViewController.swift
//  TicTacToe
//
//  Created by Markus Sørensen on 17/03/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController
{
    let emailKey = "lastEmail"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readEmail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInPressed(_ sender: UIButton)
    {
        login()
    }
    
    func login()
    {
        //if regionPicker.
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil
            {
                self.saveEmail()
                
                self.performSegue(withIdentifier: "showSeasons", sender: nil)
            }
            else
            {
                self.presentErrorAlert(error: error)
            }
        }
    }
    
    func saveEmail()
    {
        let defaults = UserDefaults.standard
        defaults.set(emailField.text, forKey: emailKey)
    }
    
    func readEmail()
    {
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: emailKey)
        {
            emailField.text = email
        }
    }
    
    
    //UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue)
    {
        passwordField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
    
}

