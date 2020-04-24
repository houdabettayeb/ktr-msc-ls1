//
//  LoginViewController.swift
//  MyLibrary
//
//  Created on 23/04/2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var bar: UINavigationItem!
    @IBAction func loginButton(_ sender: Any) {
        logIn(email: (mailTextField?.text!)!, password: (passTextField?.text!)!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "login_data")
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationViewWillDisappear(animated: true);
        dismissKeyboard();
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationViewWillAppear(animated: true);
        unRegisterForKeyboardNotifications()
    }
    
    func navigationViewWillAppear(animated: Bool){
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func navigationViewWillDisappear(animated: Bool){
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.mailTextField) {
            if (!isValidEmail(email: mailTextField.text ?? "")) {
                NSLog("inValid mail");
            } else {
                NSLog("Valid mail");
            }
        }
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if (textField == self.mailTextField) {
            textField.resignFirstResponder();
            self.passTextField.becomeFirstResponder();
        } else {
            textField.resignFirstResponder();
            //self.performSegue(withIdentifier: "goToHome", sender: self);
        
            logIn(email: (mailTextField?.text!)!, password: (passTextField?.text!)!)
        }
        return true;
    }
    
    func logIn(email : String, password : String) {
        
        if (isValidEmail(email: email)) {
            goToHomePage()
        } else {
            showAlert(title: "Invalid email address", message: "Please check your email address", actionTitle: "Ok")
        }
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func unRegisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func goToHomePage () {
        //let sec: HomeViewController = HomeViewController(nibName: nil, bundle: nil)
        //self.present(sec, animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeView = storyBoard.instantiateViewController(withIdentifier: "home") as! UINavigationController
        self.present(homeView, animated: true, completion: nil)
    }
    
    func showAlert(title : String, message : String, actionTitle: String ) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
