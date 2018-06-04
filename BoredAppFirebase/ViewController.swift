//
//  ViewController.swift
//  BoredAppFirebase
//
//  Created by BulBul on 01.06.18.
//  Copyright © 2018 BulBul. All rights reserved.
//

import UIKit
import FirebaseAuth



class ViewController: UIViewController {

    @IBOutlet weak var SegmentLoginSignin: UISegmentedControl!
    
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var UserNameField: UITextField!
    
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBAction func SegmentController(_ sender: UISegmentedControl) {
        
        if SegmentLoginSignin.selectedSegmentIndex == 0 {
         SignInButton.setTitle("Log In", for: .normal)
        }
        else{
           SignInButton.setTitle("Sign Up", for: .normal)
        }
        
        
    }
    
    @IBAction func Login(_ sender: Any) {
        
        if EmailField.text != "" && PasswordField.text != ""
        {
            if SegmentLoginSignin.selectedSegmentIndex == 0 {
                
                //login
                Auth.auth().signIn(withEmail: EmailField.text!, password: PasswordField.text!) { (user, err) in
                    
                    if user != nil {
                        
                        print("logged IN")
                        self.performSegue(withIdentifier: "Login", sender: self)
                    }
                    else
                    {
                        
                        if let err = err {
                            
                            print(err)
                        }
                        else
                        {
                            
                            print("Error")
                        }
                    }
                }
                
            }
            else{
                
               
                
                
                
                //SignUP
                Auth.auth().createUser(withEmail: EmailField.text!, password: PasswordField.text!) { (user, err) in
                    //
                    
                    if user != nil {
                        
                        print("Signed Up")
                        self.performSegue(withIdentifier: "Login", sender: self)
                    }
                    else
                    {
                        
                        if let err = err {
                            
                            print(err)
                        }
                        else
                        {
                            
                            print("Error")
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.email != nil{
            
            self.performSegue(withIdentifier: "Login", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(Auth.auth().currentUser?.email)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }




}

