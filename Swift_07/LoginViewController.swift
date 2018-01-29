//
//  LoginViewController.swift
//  Swift_07
//
//  Created by 陈孟迪 on 2017/11/28.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,CAAnimationDelegate,UITextFieldDelegate,RegisterDelegate {
    
    
    func getText(controller: RegisterViewController, userName: NSString, passWord: NSString) {
        
        self.userNameTextField?.text = userName as String
        self.passWordTextField?.text = passWord as String
        
    }
    
    var userNameTextField : UITextField?
    
    var passWordTextField : UITextField?
    
    var loginButton : UIButton?
    
    var registerButton : UIButton?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     self.view.backgroundColor = UIColor.gray
        createUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //给账号密码输入框添加动画
        let flyAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "position.x")
        flyAnimation.delegate = self
        flyAnimation.setValue("form", forKey: "name")
        flyAnimation.toValue = NSValue.init(cgPoint: CGPoint.init(x: w*0.5, y: 0))
        flyAnimation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: -w*0.5, y: 0))
        flyAnimation.duration = 1
        flyAnimation.fillMode = kCAFillModeBoth
        flyAnimation.beginTime = CACurrentMediaTime() + 0.3
        flyAnimation.setValue(self.userNameTextField?.layer, forKey: "layer")
        self.userNameTextField?.layer.add(flyAnimation, forKey: nil)
        flyAnimation.beginTime = CACurrentMediaTime() + 0.4
        flyAnimation.setValue(self.passWordTextField?.layer, forKey: "layer")
        self.passWordTextField?.layer.add(flyAnimation, forKey: nil)
        
        //给login按钮添加动画
        let groupAnimation:CAAnimationGroup = CAAnimationGroup()
        groupAnimation.beginTime = CACurrentMediaTime() + 0.5
        groupAnimation.duration = 0.5
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        
        let scaleDownAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleDownAnimation.fromValue = 3.5
        scaleDownAnimation.toValue = 1
        
        let rotateAnimation = CABasicAnimation.init(keyPath: "transform.rotation")
        rotateAnimation.fromValue = Double.pi / 4
        rotateAnimation.toValue = 0
        
        let fadeAnimation = CABasicAnimation.init(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        
        groupAnimation.animations = [fadeAnimation,scaleDownAnimation,rotateAnimation]
        self.loginButton?.layer.add(groupAnimation, forKey: nil)
        self.loginButton?.alpha = 1
        
        groupAnimation.beginTime = CACurrentMediaTime() + 0.6
        self.registerButton?.layer.add(groupAnimation, forKey: nil)
        self.registerButton?.alpha = 1
        
    }
    
    func createUI() {
        
        let array:NSArray = ["Username","passWord"]
        
        for i in 0..<array.count {
            
            let textField:UITextField = UITextField.init(frame: CGRect.init(x: 40, y: h/4+(40+10)*CGFloat(i), width: w-80, height: 40))
            textField.backgroundColor = UIColor.white
            textField.placeholder = array[i] as? String
            textField.layer.cornerRadius = 5
            textField.layer.masksToBounds = true
            textField.tag = 10+i
            textField.delegate = self
            self.view.addSubview(textField)
        }
        let left = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 40))
        self.userNameTextField = self.view.viewWithTag(10) as? UITextField
        self.userNameTextField?.leftView = left
        self.passWordTextField = self.view.viewWithTag(11) as? UITextField
        self.passWordTextField?.leftView = left
        
        self.loginButton = UIButton.init(type: .custom)
        self.loginButton?.backgroundColor = UIColor.orange
        self.loginButton?.frame = CGRect.init(x: w/3, y: (self.passWordTextField?.frame.origin.y)!+40+30, width: w/3, height: 45)
        self.loginButton?.layer.cornerRadius = 5
        self.loginButton?.layer.masksToBounds = true
        self.loginButton?.setTitle("Login", for: .normal)
        self.loginButton?.setTitleColor(UIColor.white, for: .normal)
        self.loginButton?.addTarget(self, action: #selector(loginAction(sender:)), for: .touchUpInside)
        self.view.addSubview(self.loginButton!)
        
        self.registerButton = UIButton.init(type:.custom)
        self.registerButton?.frame = CGRect.init(x: w*2/3, y: (self.loginButton?.frame.origin.y)!+45+10, width: w/3, height: 45)
        self.registerButton?.setTitle("register?", for: .normal)
        self.registerButton?.setTitleColor(UIColor.blue, for: .normal)
        self.registerButton?.addTarget(self, action: #selector(registerAction(sender:)), for:.touchUpInside)
        self.view.addSubview(self.registerButton!)
    }

    @objc func registerAction(sender:UIButton) {
        let register = RegisterViewController()
        register.delegate = self
        self.navigationController?.pushViewController(register, animated: false)
    }
    
    @objc func loginAction(sender:UIButton)  {
        
        let userName:NSString = (userNameTextField?.text as NSString?)!
        let passWord:NSString = (passWordTextField?.text as NSString?)!
        
        if userName.isEqual(to: "") {
            print("请输入账号")
        }else {
            if passWord.isEqual(to: ""){
                print("请输入密码")
            }else{
                let query:BmobQuery = BmobQuery.init(className: "RegisterTable")
                query.findObjectsInBackground { (array, error) in
                    let arr:NSArray = array! as NSArray
                    print("返回的数据:\(arr)")
                    for i in 0..<arr.count{
                        
                        let obj = arr[i] as! BmobObject
                        let name = obj.object(forKey: "UserName") as? String
                        if (name?.isEqual(userName as String))!{
                           
                            let pass:NSString = obj.object(forKey: "PassWord") as! String as NSString
                            if pass .isEqual(to: passWord as String){
                               self.navigationController?.pushViewController(HomeViewController(), animated: false)
                            }else{
                                print("输入的密码不对")
                            }
                            
                        }else if i == (arr.count-1){
                            
                            print("输入的账号不对")
                        }
                        
                    }
                    
                }
 
            }
        }
    }
    
    func isResult() {
        
        
    }
    
    //    UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }

//    CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let name:NSString = anim.value(forKey: "name") as! NSString
        if name.isEqual(to: "form") {
            let layer:CALayer = anim.value(forKey: "layer") as! CALayer
            anim.setValue(nil, forKey: "layer")
            
            //为账号密码控件添加脉冲动画
            if #available(iOS 9.0, *) {
                let pulseAnimation = CASpringAnimation.init(keyPath: "transform.scale")
                pulseAnimation.damping = 7.5
                pulseAnimation.fromValue = 1.25
                pulseAnimation.toValue = 1
                pulseAnimation.duration = pulseAnimation.settlingDuration
                layer.add(pulseAnimation, forKey: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
}
