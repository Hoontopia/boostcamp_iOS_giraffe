//
//  ImageBoardAPIConstant.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import Foundation

enum ImageBoardAPIError: Error {
    case invalidResponse
    case invalidJSONData
    case denyAttempt(Int)
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct RequestParam {
    static let email: String = "email"
    static let password: String = "password"
    static let nickname: String = "nickname"
    static let imageTitle: String = "image_title"
    static let imageDesc: String = "image_desc"
    static let imageData: String = "image_data"
}

struct JSONElement {
    static let userID: String = "_id"
    static let userNickName: String = "nickname"
    static let userEmail: String = "email"
    static let boardID: String = "_id"
    static let imageTitle: String = "image_title"
    static let imageURL: String = "image_url"
    static let thumbImageURL: String = "thumb_image_url"
    static let writerID: String = "author"
    static let writerNickName: String = "author_nickname"
    static let imageDescription: String = "image_desc"
    static let dateCreated: String = "created_at"
}

struct URLElement {
    static let baseURLString: String = "https://ios-api.boostcamp.connect.or.kr/"
    
    enum SubPath: String {
        case signIn = "login"
        case signUp = "user"
        case creationBoard = "image"
        case modifyBoard, deleteBoard = "image/:article_id:"
    }
}

struct ContentType {
    static let applicationJson = "application/json"
    static let multipartFormData = "multipart/form-data"
}
