//
//  RegisterViewController.swift
//  Swift_07
//
//  Created by 陈孟迪 on 2017/11/28.
//  Copyright © 2017年 陈孟迪. All rights reserved.
//
//BmobSDK (2.2.3)
import UIKit
import MessageUI

protocol RegisterDelegate:NSObjectProtocol {
    func getText(controller:RegisterViewController,userName:NSString,passWord:NSString)
}

class RegisterViewController: UIViewController,UITextFieldDelegate,CAAnimationDelegate {

    var phoneTextField :UITextField?
    
    var codeButton : UIButton?
    
    var codeTextField : UITextField?
    
    var passWordTextField : UITextField?
    
    var okButton :UIButton?
    
    var number:Int = 60
    
    var timer : Timer?
    
    var isSuccess:Bool = false
    
    let toolClass:ToolClass = ToolClass()
    
    var delegate: RegisterDelegate?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        //给账号密码输入框添加动画
        let flyAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "position.x")
        flyAnimation.delegate = self
        flyAnimation.setValue("form", forKey: "name")
        flyAnimation.toValue = NSValue.init(cgPoint: CGPoint.init(x: w*0.5, y: 0))
        flyAnimation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: -w*0.5, y: 0))
        flyAnimation.duration = 1
        flyAnimation.fillMode = kCAFillModeBoth
        flyAnimation.beginTime = CACurrentMediaTime() + 0.3
        flyAnimation.setValue(self.phoneTextField?.layer, forKey: "layer")
        self.phoneTextField?.layer.add(flyAnimation, forKey: nil)
        
        flyAnimation.beginTime = CACurrentMediaTime() + 0.4
        flyAnimation.setValue(self.codeTextField?.layer, forKey: "layer")
        self.codeTextField?.layer.add(flyAnimation, forKey: nil)
        
        flyAnimation.beginTime = CACurrentMediaTime() + 0.4
        flyAnimation.setValue(self.codeButton?.layer, forKey: "layer")
        self.codeButton?.layer.add(flyAnimation, forKey: nil)

        flyAnimation.beginTime = CACurrentMediaTime() + 0.5
        flyAnimation.setValue(self.passWordTextField?.layer, forKey: "layer")
        self.passWordTextField?.layer.add(flyAnimation, forKey: nil)
        
        //给按钮添加动画
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
        self.okButton?.layer.add(groupAnimation, forKey: nil)
        self.okButton?.alpha = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.view.backgroundColor = UIColor.gray
        createUI()
        
    }

    func createUI() {
        
        let array:NSArray = ["请输入手机号","请输入验证码","请输入密码"]
        for i in 0..<array.count {
            let textField:UITextField = UITextField.init(frame: CGRect.init(x: 40, y: h/4+(40+20)*CGFloat(i), width: w-80, height: 40))
            if i == 1{
                textField.frame = CGRect.init(x: 40, y: h/4+(40+20)*CGFloat(i), width: (w-80)/2, height: 40)
            }
            textField.backgroundColor = UIColor.white
            textField.placeholder = array[i] as? String
            textField.layer.cornerRadius = 5
            textField.layer.masksToBounds = true
            textField.tag = 20+i
            textField.delegate = self
            self.view.addSubview(textField)
        }
        self.phoneTextField = self.view.viewWithTag(20) as? UITextField
        self.codeTextField = self.view.viewWithTag(21) as? UITextField
        self.codeTextField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.passWordTextField = self.view.viewWithTag(22) as? UITextField
        
        self.codeButton = UIButton.init(type: .custom)
        self.codeButton?.frame = CGRect.init(x: (self.codeTextField?.frame.origin.x)!+(self.codeTextField?.frame.size.width)!+10, y: (self.codeTextField?.frame.origin.y)!, width: (w-80)/2-10, height: 40)
        self.codeButton?.setTitle("点击获取验证码", for: .normal)
        self.codeButton?.setTitleColor(UIColor.blue, for: .normal)
        self.codeButton?.addTarget(self, action: #selector(codeAction(sender:)), for: .touchUpInside)
        self.view.addSubview(self.codeButton!)
        
        self.okButton = UIButton.init(type: .custom)
        self.okButton?.backgroundColor = UIColor.orange
        self.okButton?.frame = CGRect.init(x: w/3, y: (self.passWordTextField?.frame.origin.y)!+40+30, width: w/3, height: 45)
        self.okButton?.layer.cornerRadius = 5
        self.okButton?.layer.masksToBounds = true
        self.okButton?.setTitle("确定", for: .normal)
        self.okButton?.setTitleColor(UIColor.white, for: .normal)
        self.okButton?.addTarget(self, action: #selector(okAction(sender:)), for: .touchUpInside)
        self.view.addSubview(self.okButton!)
    }
    
    //发送验证码
    @objc func codeAction(sender:UIButton)  {
      
        print("是否是手机号\(toolClass .isPhoneNumber(num: (self.phoneTextField?.text as NSString?)!))")
        if  toolClass .isPhoneNumber(num: (self.phoneTextField?.text as NSString?)!){
            //发送验证码
            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: (self.phoneTextField?.text as NSString?)! as String!, zone: "86", result: { (error) in
                if !(error != nil){
                print("请求成功")
                    sender.setTitle(String.init(format: "%ds", self.number), for: .normal)
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.add), userInfo: nil, repeats: true)
                }else{
                    print("请求失败\(String(describing: error))")
                }
            })
        }
    }
    
    //时间自减
    @objc func add() {
        
        if number == 1 {
            timer?.invalidate()
            number = 60
        self.codeButton?.setTitle("请重新获取", for: .normal)
        }else{
        number -= 1
        self.codeButton?.setTitle(String.init(format: "%ds", number), for: .normal)
        }
    }

    @objc func textFieldDidChange(textField:UITextField) {
        
        if textField.tag == 21 {
            print("\((self.phoneTextField?.text as NSString?)! as String!)")
            let string:NSString = (textField.text as NSString?)!
            if string.length == 4{
                //发送验证码
                SMSSDK.commitVerificationCode(string as String!, phoneNumber: (self.phoneTextField?.text as NSString?)! as String!, zone: "86", result: { (error) in
                    if !(error != nil){
                        print("验证成功")
                        self.isSuccess = true
                        self.timer?.invalidate()
                        self.number = 60
                        self.codeButton?.setTitle("验证成功", for: .normal)
                        self.phoneTextField?.isEnabled = true
                        self.codeTextField?.isEnabled = true
                    }else{
                        print("验证失败\(String(describing: error))")
                    self.codeButton?.setTitle("验证失败", for: .normal)
                    }
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 22 {
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            if proposeLength > 6 {
                return false
            }
        }
        return true
    }
    
    @objc func okAction(sender:UIButton)  {
        
        self.phoneTextField?.resignFirstResponder()
        self.codeTextField?.resignFirstResponder()
        self.passWordTextField?.resignFirstResponder()
        let userName:NSString = (self.phoneTextField?.text as NSString?)!
        let passWord:NSString = (self.passWordTextField?.text as NSString?)!
        print("账号：\(userName)，密码：\(passWord)")
        
        if isSuccess == false {
            print("验证码获取失败！")
        }else{
            if passWord.isEqual(to: ""){
            print("密码不能为空！")
            }else{
                if passWord.length<6{
                    print("密码需大于6个字符串")
                }else{
                    
                    let query:BmobQuery = BmobQuery.init(className: "RegisterTable")
                    query.findObjectsInBackground({ (array, error) in
                        let arr:NSArray = array! as NSArray
                        for i in 0..<arr.count{
                            let obj = arr[i] as! BmobObject
                            let name = obj.object(forKey: "UserName") as? String
                            if (name?.isEqual(userName as String))!{
                                print("此账号已经被注册过")
                                return
                            }else if i == (arr.count-1){
                                
                                print("输入的账号不对")
                                print("设置成功")
                                let registerTable:BmobObject = BmobObject.init(className: "RegisterTable")
                                registerTable.setObject(userName, forKey: "UserName")
                                registerTable.setObject(passWord, forKey: "PassWord")
                                registerTable.saveInBackground(resultBlock: { (isSuccess, error) in
                                    if error != nil {
                                        
                                        print("error is\(String(describing: error?.localizedDescription))")
                                    }else {
                                        print("成功")
                                        self.delegate?.getText(controller: self, userName: userName, passWord: passWord)
                                        self.navigationController?.pushViewController(LoginViewController(), animated: true)
                                    }
                                })
                            }
                        }
                    })
                    
                }
            }
        }
    }
    
    //点击屏幕移除键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.phoneTextField?.resignFirstResponder()
        self.codeTextField?.resignFirstResponder()
        self.passWordTextField?.resignFirstResponder()
    }
    
    
    
}
