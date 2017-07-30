//
//  FlickrAPI.swift
//  Photorama
//
//  Created by 임성훈 on 2017. 7. 29..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import Foundation

private struct URLElement {
    enum Method: String {
        case recentPhotos = "flickr.photos.getRecent"
    }
    
    static let baseURLString: String = "https://api.flickr.com/services/rest"
    static let APIKey: String = "a6d819499131071f158fd740860a5a88"
    static let format: String = "json"
    static let noJsonCallBack: String = "1"
}

private struct JSONElement {
    static let id: String = "id"
    static let title: String = "title"
    static let datetaken: String = "datetaken"
    static let url_h: String = "url_h"
    static let photos: String = "photos"
    static let photo: String = "photo"
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum FlickrError: Error {
    case invalidJSONData
    case unexpectedError
}

struct FlickrAPI {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: URLElement.Method, parameters: [String: String]?) -> URL? {
        guard var components = URLComponents(string: URLElement.baseURLString) else { return nil }
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": URLElement.format,
            "nojsoncallback": URLElement.noJsonCallBack,
            "api_key": URLElement.APIKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url
    }
    
    static func recentPhotosURL() -> URL? {
        return flickrURL(method: .recentPhotos, parameters: ["extras": "url_h, date_taken"])
    }
    
    static func photosFromJSONData(_ data: Data) -> PhotosResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDictionary = jsonObject as? [String: Any],
                let photos = jsonDictionary[JSONElement.photos] as? [String: Any],
                let photosArray = photos[JSONElement.photo] as? [[String: Any]] else {
                return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            
            for photoJSON in photosArray {
                if let photo = photosFromJSONObject(photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            guard finalPhotos.count != 0 || photosArray.count <= 0 else {
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(finalPhotos)
        } catch {
            return .failure(error)
        }
    }
    
    static func photosFromJSONObject(_ json: [String: Any]) -> Photo? {
        guard let photoID = json[JSONElement.id] as? String,
            let title = json[JSONElement.title] as? String,
            let dateString = json[JSONElement.datetaken] as? String,
            let photoURLString = json[JSONElement.url_h] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
}






