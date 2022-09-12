//
//  LoginController.swift
//  RxSwiftBindSubOnNext
//
//  Created by V000273 on 09/09/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import Toast_Swift

class LoginController : UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var loginBackgroundView: UIView!
    @IBOutlet weak var saveAccount: UISwitch!
    
    let disposeBagLogin = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleOption()
        saveAccount.setOn(false, animated: true)
        self.title = "Login"
        passWord.isSecureTextEntry.toggle()
        let observableCombind = Observable.combineLatest(self.userName.rx.text.orEmpty, self.passWord.rx.text.orEmpty)
        
        self.btLogin.rx.tap
            .withLatestFrom(observableCombind)
            .subscribe(onNext: {
                self.login($0, $1)
            }).disposed(by: disposeBagLogin)
        
        if UserDefaults.standard.bool(forKey: "autoLogin") == true {
            let foodMenuVC = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
            setRootViewController(foodMenuVC)
        }
        
    }
    
    @IBAction func btSaveAccount(_ sender: Any) {
        if userName.text == "admin@test.com" && passWord.text == "123456" {
            UserDefaults.standard.set(true, forKey: "autoLogin")
        }
        if userName.text == "" && passWord.text == "" {
            self.view.makeToast("Please enter all Email and Password Aganin!")
            saveAccount.setOn(false, animated: true)
        }
    }
    
    func login(_ user: String, _ pass: String) {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
        let emailValid: Bool = emailPred.evaluate(with: user)
        let passValid: Bool = (pass != "" && pass.count >= 6)
        let userInit: Bool = (user == "admin@test.com" && pass == "123456")
        
        if (emailValid && passValid && userInit){
            let foodMenuVC = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
            setRootViewController(foodMenuVC)
        } else {
            self.view.makeToast("Please enter all Email and Password Aganin!")
        }
    }
    
    func styleOption() {
        loginBackgroundView!.layer.cornerRadius = 12 //set corner radius here
        loginBackgroundView!.layer.borderWidth = 2 // set border width here
        loginBackgroundView!.layer.borderColor = UIColor.clear.cgColor
        loginBackgroundView!.layer.masksToBounds = true
        loginBackgroundView!.layer.shadowColor = UIColor.black.cgColor
        loginBackgroundView!.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        loginBackgroundView!.layer.shadowRadius = 5
        loginBackgroundView!.layer.shadowOpacity = 0.3
        loginBackgroundView!.layer.masksToBounds = false
        loginBackgroundView!.layer.shadowPath = UIBezierPath(roundedRect: loginBackgroundView!.bounds, cornerRadius: loginBackgroundView!.layer.cornerRadius).cgPath
    }
    
    func setRootViewController(_ vc: UIViewController){
        let navigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
