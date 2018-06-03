//
//  CreateUserViewController.swift
//  TicTacToe
//
//  Created by Markus Sørensen on 17/03/17.
//  Copyright © 2017 Markus Sørensen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func acceptPressed(_ sender: UIButton)
    {
        
        createUser(sender: sender)
        
    }
    
    @IBAction func backPressed(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "unwindToLogin", sender: sender)
    }
    
    
    func createUser(sender: Any)
    {
        if let email = emailField.text, let password = passwordField.text, let name = nameField.text
        {
            API.Authorization.checkName(name: name, completion:
                { (available) in
                    if available == true
                    {
                        Auth.auth().createUser(withEmail: email, password: password, completion:
                            { (user, signUpError) in
                                if signUpError == nil
                                {
                                    Auth.auth().signIn(withEmail: email, password: password)
                                    { (user, signInError) in
                                        if signInError == nil
                                        {
                                            API.Authorization.register(user: User(name: name), completion:
                                                { (complete) in
                                                    if complete == true
                                                    {
                                                        self.performSegue(withIdentifier: "unwindToLogin", sender: sender)
                                                    }
                                                    else
                                                    {
                                                        self.presentErrorAlert(errorText: "API use could not be created")
                                                    }
                                            })
                                        }
                                        else
                                        {
                                            self.presentErrorAlert(error: signInError)
                                        }
                                    }
                                }
                                else
                                {
                                    self.presentErrorAlert(error: signUpError)
                                }
                        })
                    }
                    else
                    {
                        self.presentErrorAlert(errorText: "Name is not available")
                    }
            })
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVC = segue.destination as? LoginViewController
        {
            if let button = sender as? UIButton
            {
                if(button.tag == 1)
                {
                    destinationVC.emailField.text = emailField.text
                    //destinationVC.passwordField.text = passwordField.text
                }
            }
        }
        
    }
    
    
}
