//
//  LoginViewController.swift
//  ConceptubeTest
//
//  Created by blue on 15/12/2021.
//

import UIKit
import Network

class LoginViewController: UIViewController {
    
    @IBOutlet var idTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func didTapLogin() {
        guard let id = idTxtField.text, !id.isEmpty, let password = passwordTxtField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Please fill in all fields!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

            return
        }
        
        if !Reachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Alert", message: "No Internet Connections!\nPlease connect to internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        Constants.refs.databaseAuth.getData(completion: { [weak self] error, snapshot in
            guard error == nil else {
              print(error!.localizedDescription)
              return;
            }
            print("GET DATA")
            if let data = snapshot.value as? NSDictionary //[String: String]
            {
                var canLogin = false
                data.allValues.forEach({ value in
                    if let value = value as? NSDictionary {
                        let fID = value["ID"] as? String ?? ""
                        let fPass = value["password"] as? String ?? ""
                        if id == fID, password == fPass {
                            canLogin = true
                        }
                    }
                })
                if !canLogin {
                    let alert = UIAlertController(title: "Alert", message: "Your ID or password is incorrect!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                else {
                  self?.performSegue(withIdentifier: "showMainPage", sender: self)
                }
            }
          });
    }
    
    @IBAction func didTapSignup() {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JoinViewController") as! JoinViewController
//        navigationController?.pushViewController(vc, animated: true)
        self.performSegue(withIdentifier: "showJoinPage", sender: self)
    }
    
    func showSignUpSuccessful() {
        let alert = UIAlertController(title: "Success", message: "You have signed up your information successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
