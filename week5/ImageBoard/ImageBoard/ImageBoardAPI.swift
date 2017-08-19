//
//  ImageBoardAPI.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 30..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import Foundation

struct ImageBoardAPI {
    static func makeAPIURL(included subPath: URLElement.SubPath? = nil) -> URL? {
        guard let subPath = subPath else {
            return URLComponents(string: URLElement.baseURLString)?.url
        }
        
        let methodURL: String = URLElement.baseURLString + subPath.rawValue
        
        return URLComponents(string: methodURL)?.url
    }
    
    static func makeDefaultURLRequest() -> URLRequest? {
        guard let baseURL = makeAPIURL() else { return nil }
        return URLRequest(url: baseURL)
    }
    
    static func makeSignInURLRequest(withUserData userData: Data) -> URLRequest? {
        guard let signInURL = makeAPIURL(included: .signIn) else { return nil }
        
        var request = URLRequest(url: signInURL)
        
        request.httpBody = userData
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue(ContentType.applicationJson, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func makeSignUpURLRequest(withUserData userData: Data) -> URLRequest? {
        guard let signUpURL = makeAPIURL(included: .signUp) else { return nil }
        
        var request = URLRequest(url: signUpURL)
        
        request.httpBody = userData
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue(ContentType.applicationJson, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func makeCreationBoardURLRequest(withBoardData boardData: Data, boundary: String) -> URLRequest? {
        guard let creationBoardURL = makeAPIURL(included: .creationBoard) else {
            return nil
        }
        
        var request = URLRequest(url: creationBoardURL)
   
        request.httpBody = boardData
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("\(ContentType.multipartFormData); boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func makeDeleteBoardURLRequest(withBoardID boardID: String) -> URLRequest? {
        guard let deleteURL = makeAPIURL(included: .creationBoard),
            let deleteBoardURL = URL(string: deleteURL.absoluteString + "/\(boardID)") else {
                return nil
        }

        var request = URLRequest(url: deleteBoardURL)
        
        request.httpMethod = HTTPMethod.DELETE.rawValue
      
        return request
    }
}
