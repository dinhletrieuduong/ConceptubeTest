//
//  JoinViewController.swift
//  ConceptubeTest
//
//  Created by blue on 15/12/2021.
//

import UIKit

class JoinViewController: UIViewController {
    
    @IBOutlet var idTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    @IBOutlet var rePasswordTxtFeild: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var birthDayTxtField: UIDatePicker!
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var btnSignUp: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    private var STRONG_PASSWORD: Int = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let totalHeight = stackView.frame.size.height + btnSignUp.frame.size.height
        scrollView.contentSize.height = totalHeight + (totalHeight > view.bounds.size.height ? 50 : 0)
        
    }
    
    @IBAction func didTapCheckID() {
        guard let id = idTxtField.text, !id.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Please fill in your ID!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        //        let defaults = UserDefaults.standard
        
        //        let query = Constants.refs.databaseAuth.queryEqual(toValue: id, childKey: "ID")
        //        _ = query.observe(.value, with: { [weak self] snapshot in
        //            if  let data = snapshot.value as? [String: Any]
        //            {
        //                print(data)
        //                let fID          = data["ID"]
        //                if id == fID {
        //                    let alert = UIAlertController(title: "Alert", message: "Please fill other ID!", preferredStyle: .alert)
        //                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //                    self?.present(alert, animated: true, completion: nil)
        //                }
        //            }
        //        })
        
        Constants.refs.databaseAuth.getData(completion: { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            print("GET DATA")
            if let data = snapshot.value as? NSDictionary //[String: String]
            {
                var canUse = true
                data.allValues.forEach({ value in
                    if let value = value as? NSDictionary {
                        let fID = value["ID"] as? String ?? ""
                        if id == fID {
                            canUse = false
                        }
                    }
                })
                let alert = UIAlertController(title: "Alert", message: !canUse ? "Please fill other ID!": "You can use this ID!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        });
        
    }
    
    @IBAction func didTapSignUp() {
        guard let id = idTxtField.text, !id.isEmpty,
              let password = passwordTxtField.text, !password.isEmpty,
              let rePassword = rePasswordTxtFeild.text, !rePassword.isEmpty,
              let email = emailTxtField.text, !email.isEmpty
        else {
            let alert = UIAlertController(title: "Alert", message: "Please fill in all fields!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        if password.count < STRONG_PASSWORD {
            let alert = UIAlertController(title: "Alert", message: "Your password must be your at least \(STRONG_PASSWORD) characters!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if password != rePassword {
            let alert = UIAlertController(title: "Alert", message: "Your confirm password is not matched!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidEmail(email) {
            let alert = UIAlertController(title: "Alert", message: "Your email is not valid!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if !Reachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Alert", message: "No Internet Connections!\nPlease connect to internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.long
        let birthday = timeFormatter.string(from: birthDayTxtField.date)
        
        let ref = Constants.refs.databaseAuth.childByAutoId()
        
        let data = ["ID": id, "password": password, "email": email, "birthday": birthday]
        
        ref.setValue(data)
        
        // show success dialog
        let alert = UIAlertController(title: "Success", message: "Your registration is successful! Login now!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Login", style: .default, handler: ({ [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        })))
        present(alert, animated: true, completion: nil)
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
}
