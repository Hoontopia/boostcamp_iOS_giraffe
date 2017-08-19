//
//  LoginManager.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import Foundation

enum LoginResult {
    case success(Data)
    case failure(Error)
}

enum EncodeDataResult {
    case success(Data)
    case failure(Error)
}

enum DecodeDataReuslt {
    case success(UserInfo)
    case failure(Error)
}

struct UserInfo {
    static var userInfo: UserInfo?
    
    fileprivate let _identifier: String
    fileprivate let _nickName: String
    fileprivate let _email: String
    
    var identifier: String {
        return _identifier
    }
    
    var nickName: String {
        return _nickName
    }
    
    var email: String {
        return _email
    }
}

struct LoginManager {
    private func encodeUserData(with email: String, password: String, nickName: String? = nil) -> EncodeDataResult {
        var userInfo: [String: Any]
        
        if let nickName = nickName {
            userInfo = [RequestParam.email: email, RequestParam.password: password, RequestParam.nickname: nickName]
        } else {
            userInfo = [RequestParam.email: email, RequestParam.password: password]
        }

        do {
            let encodeUserInfo = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)

            return .success(encodeUserInfo)
        } catch {
            return .failure(error)
        }
    }
    
    func signIn(with email: String, password: String, completion: @escaping (LoginResult) -> Void) {
        guard case let .success(userData) = encodeUserData(with: email, password: password) else { return }
        guard let request = ImageBoardAPI.makeSignInURLRequest(withUserData: userData) else { return }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.signInResult(data: data, response: response, error: error)
            
            if case let .success(jsonData) = result,
            case let .success(userInfo) = self.userInfo(fromJSONData: jsonData) {
                    UserInfo.userInfo = userInfo
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func signUp(with email: String, password: String, nickName: String,
                completion: @escaping (LoginResult) -> Void) {
        guard case let .success(userData) = encodeUserData(with: email,
                    password: password, nickName: nickName) else { return }
        guard let request = ImageBoardAPI.makeSignUpURLRequest(
            withUserData: userData) else { return }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.signUpResult(data: data, response: response, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
}

// MARK: result
extension LoginManager {
    fileprivate func signInResult(data: Data?, response: URLResponse?,
                                  error: Error?) -> LoginResult {
        guard let jsonData = data else {
            guard let error = error else {
                return .failure(ImageBoardAPIError.invalidJSONData)
            }
            return .failure(error)
        }
        
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return .failure(ImageBoardAPIError.invalidResponse)
        }
        
        guard httpURLResponse.statusCode == 200 else {
            let denyAttempt = ImageBoardAPIError.denyAttempt(httpURLResponse.statusCode)
            return .failure(denyAttempt)
        }
        
        return .success(jsonData)
    }
    
    fileprivate func signUpResult(data: Data?, response: URLResponse?,
                                  error: Error?) -> LoginResult {
        guard let jsonData = data else {
            guard let error = error else {
                return .failure(ImageBoardAPIError.invalidJSONData)
            }
            return .failure(error)
        }
        
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return .failure(ImageBoardAPIError.invalidResponse)
        }
        
        guard httpURLResponse.statusCode == 201 else {
            let denyAttempt = ImageBoardAPIError.denyAttempt(httpURLResponse.statusCode)
            return .failure(denyAttempt)
        }
        
        return .success(jsonData)
    }
}

// MARK: extract
extension LoginManager {
    fileprivate func userInfo(fromJSONData data: Data) -> DecodeDataReuslt {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data,
                                                                   options: [])
            
            guard let fetchedUserInfo = jsonObject as? [String: Any] else {
                return .failure(ImageBoardAPIError.invalidJSONData)
            }
            print(jsonObject)
            guard let identifier = fetchedUserInfo[JSONElement.userID] as? String,
                let nickName = fetchedUserInfo[JSONElement.userNickName] as? String,
                let email = fetchedUserInfo[JSONElement.userEmail] as? String else {
                    return .failure(ImageBoardAPIError.invalidJSONData)
            }
            
            let userInfo = UserInfo(_identifier: identifier, _nickName: nickName, _email: email)
            
            return .success(userInfo)
        } catch {
            return .failure(error)
        }
    }
}
