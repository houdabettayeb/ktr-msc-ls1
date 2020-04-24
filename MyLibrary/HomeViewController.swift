//
//  HomeViewController.swift
//  MyLibrary
//
//  Created on 23/04/2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController : UIViewController, UITextFieldDelegate {

    let answerHeight = 25
    let answerVerticalSpacing = 8
    var cellHieght: CGFloat = 0
    var tableHieght: CGFloat = 0
    
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNum: UITextField!
    @IBOutlet weak var mValidateButton: UIButton!
    @IBAction func registerUser(_ sender: Any) {
        let firstName       = textFieldFirstName.text
        let lastName        = textFieldLastName.text
        let email           = textFieldEmail.text
        let phone           = textFieldPhoneNum.text
        
        createUser(firstName: firstName!,lastName: lastName!,email: email!, phoneNumber: phone!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        mScrollView.contentSize = CGSize(width: Int(view.frame.width), height: 1000)
        
        mValidateButton.setBackgroundColor(color: UIColor.lightGray, forState: .disabled)
        
        updateButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            if view.layer.frame.origin.y == 0 {
                self.view.layer.frame.origin.y -= keyboardSize.height / 2
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if view.layer.frame.origin.y != 0 {
            self.view.layer.frame.origin.y = 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 || scrollView.contentOffset.x<0{
            scrollView.contentOffset.x = 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let borderColor = UIColor(hexString: "#0fba2c")
        textField.layer.borderColor =  borderColor.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 5.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
        updateButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == self.textFieldFirstName) {
            textField.resignFirstResponder()
            self.textFieldLastName.becomeFirstResponder()
        } else if (textField == self.textFieldLastName){
            textField.resignFirstResponder()
            self.textFieldEmail.becomeFirstResponder()
        } else if (textField == self.textFieldEmail){
            textField.resignFirstResponder()
            self.textFieldPhoneNum.becomeFirstResponder()
        } else if (textField == self.textFieldPhoneNum){
            textField.resignFirstResponder()
            self.dismissKeyboard()
        }
        return true;
    }
    
    func updateButton() {
        var isEnabled = false
        if textFieldFirstName.text!.isEmpty || textFieldLastName.text!.isEmpty || textFieldEmail.text!.isEmpty || textFieldPhoneNum.text!.isEmpty {
            isEnabled = false
        } else {
            isEnabled = true
        }
        mValidateButton.isEnabled = isEnabled
        mValidateButton.isUserInteractionEnabled = isEnabled
    }
    
    func addToLibrary() {
        
    }
    
    @objc func showSuccessAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default){
            UIAlertAction in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createUser(firstName :String, lastName :String, email :String, phoneNumber :String) {
        
        if (!isValidEmail(email: email)) {
            showAlert(title: "Invalid email address", message: "Please check your email address", actionTitle: "Ok")
            return
        }
        
        addToLibrary()
        
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
