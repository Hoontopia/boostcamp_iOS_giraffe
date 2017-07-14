//
//  ViewController.swift
//  Login
//
//  Created by 임성훈 on 2017. 6. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

// Profile Request 결과 담을 구조체
struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        let userName: String?
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            if let result = rawResponse as? [String: String] {
                self.userName = result["name"]
            } else {
                print("result is not [String: String]")
                userName = nil
            }
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

class LoginViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    /// A Text field containing id
    @IBOutlet weak var idField: UITextField!
    /// A Text field containing password
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginStackView: UIStackView!
    
    var profileRequest = MyProfileRequest()
    var userName: String?
    
    override func viewDidLoad() {
        /*
        // 인터페이스 빌더로
        idField.delegate = self
        passwordField.delegate = self
        */
        
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton) // 제약조건 주기 전에 서브 뷰로 추가 먼저 할 것 !
        
        // 제약조건 추가
        NSLayoutConstraint(item: loginButton, attribute: .top, relatedBy: .equal, toItem: loginStackView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: loginStackView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        getUserProfile()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /// Run when touching the Sign In button
    @IBAction func touchSignIn(sender: UIButton){
        print("touch up inside - sign in")
    
        // Return if none of the ID and password are entered
        // guard 구문을 다른 사람이 보기 좋도록..?

        guard let id = idField.text, let password = passwordField.text
        else { return }
        
        guard !id.isEmpty, !password.isEmpty
        else { return }
        
        // print("ID : " + id + ", " + "PW : " + password)
        // 문자열을 합치는 다른 방법?
        print("ID : \(id), PW : \(password)")
    }
    
    /// Run when touching the Sign Up button
    @IBAction func touchSignUp(sender: UIButton){
        print("touch up inside - sign up")
        performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .success(grantedPermissions: _, declinedPermissions: _, token: _):
            print("로그인 성공")
            getUserProfile()
            
        case .cancelled:
            print("로그인 취소")
        case .failed( _):
            print("로그인 실패")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("로그아웃")
        userName = nil
    }
    
    // 유저 프로파일 가져오는 메소드
    func getUserProfile() {
        // 액세스 토큰 지속적으로 변경
        profileRequest.accessToken = AccessToken.current
        
        // 지속적으로 액세스 토큰이 변경되므로 지역 저장 프로퍼티로..
        let connection = GraphRequestConnection()
        connection.add(profileRequest) { response, result in
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response.userName)")
                self.userName = response.userName
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    // Sign Up 뷰 컨트롤러 id 텍스트 뷰에 이름 넣어줌
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard userName != nil else { return }

        guard let dest = segue.destination as? SignUpViewController else { return }
        
        dest.id = userName
    }
}

