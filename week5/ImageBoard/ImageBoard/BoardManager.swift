//
//  BoardManager.swift
//  ImageBoard
//
//  Created by 임성훈 on 2017. 7. 31..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

enum BoardResult {
    case success([Board])
    case failure(Error)
}

enum ImageFetchResult {
    case success(UIImage)
    case failure(Error)
}

enum BoardEditResult {
    case success(Data)
    case failure(Error)
}

fileprivate enum ImageError: Error {
    case imageCreationError
    case invalidData
}

// MARK: fetch
struct BoardManager {
    func fetchAllBoard(completion: @escaping (BoardResult) -> Void) {
        guard let request = ImageBoardAPI.makeDefaultURLRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            let result = self.fetchAllBoardResult(data: data, response: response,
                                                  error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func fetchImage(fromURLString imageURLString: String, for board: Board,
                         completion: @escaping (ImageFetchResult) -> Void) {
        let defaultURL = ImageBoardAPI.makeAPIURL()
        
        guard let imageURL = defaultURL?.appendingPathComponent(imageURLString) else {
            return
        }
        
        let request = URLRequest(url: imageURL)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.fetchImageResult(data: data, response: response,
                                                    error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
}

// MARK: interact
extension BoardManager {
    fileprivate func encodeBoardData(withTitle title: String, description: String,
                                     image: UIImage, boundary: String) -> EncodeDataResult {
    
        let lineBreak = "\r\n"
        let contentDisposition = "Content-Disposition: form-data; "
        let fileName = title+".jpg"
        let mimeType = "image/jpg"
        
        guard let encodedImage = UIImageJPEGRepresentation(image, 0.7) else {
            return .failure(ImageError.invalidData)
        }
        
        var encodedBoard = Data()
        
        encodedBoard.append("--\(boundary + lineBreak)")
        encodedBoard.append(contentDisposition)
        encodedBoard.append("name=\"\(RequestParam.imageTitle)\"\(lineBreak + lineBreak)")
        encodedBoard.append("\(title + lineBreak)")
        
        encodedBoard.append("--\(boundary + lineBreak)")
        encodedBoard.append(contentDisposition)
        encodedBoard.append("name=\"\(RequestParam.imageDesc)\"\(lineBreak + lineBreak)")
        encodedBoard.append("\(description + lineBreak)")
        
        encodedBoard.append("--\(boundary + lineBreak)")
        encodedBoard.append(contentDisposition)
        encodedBoard.append("name=\"\(RequestParam.imageData)\"; filename=\"\(fileName)\"\(lineBreak)")
        encodedBoard.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
        encodedBoard.append(encodedImage)
        encodedBoard.append(lineBreak)
        encodedBoard.append("--\(boundary)--\(lineBreak)")
        
        return .success(encodedBoard)
    }
    
    func createBoard(withTitle title: String, description: String, image: UIImage,
                     completion: @escaping (BoardEditResult) -> Void) {
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        guard case let .success(encodedBoardData) = encodeBoardData(
            withTitle: title, description: description, image: image,
            boundary: boundary) else { return }
        
        guard let request = ImageBoardAPI.makeCreationBoardURLRequest(
            withBoardData: encodedBoardData, boundary: boundary) else { return }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.createBoardResult(data: data, response: response,
                                                error: error)
    
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func deleteBoard(withBoardID boardID: String,
                     completion: @escaping (BoardEditResult) -> Void) {
        guard let request = ImageBoardAPI.makeDeleteBoardURLRequest(
            withBoardID: boardID) else { return }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.deleteBoardResult(data: data, response: response,
                                                error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
}

// MARK: result
extension BoardManager {
    fileprivate func fetchAllBoardResult(data: Data?, response: URLResponse?,
                                         error: Error?) -> BoardResult {
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
        
        return boards(fromJSONData: jsonData)
    }
    
    fileprivate func fetchImageResult(data: Data?, response: URLResponse?,
                                           error: Error?) -> ImageFetchResult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(ImageError.invalidData)
            } else {
                return .failure(ImageError.imageCreationError)
            }
        }
        
        guard let httpURLResponse = response as? HTTPURLResponse else {
            guard let error = error else {
                return .failure(ImageBoardAPIError.invalidResponse)
            }
            return .failure(error)
        }
        
        guard httpURLResponse.statusCode == 200 else {
            let denyAttempt = ImageBoardAPIError.denyAttempt(httpURLResponse.statusCode)
            return .failure(denyAttempt)
        }
        
        return .success(image)
    }
    
    fileprivate func createBoardResult(data: Data?, response: URLResponse?,
                                  error: Error?) -> BoardEditResult {
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
            print(httpURLResponse)
            return .failure(denyAttempt)
        }
        
        return .success(jsonData)
    }
    
    fileprivate func deleteBoardResult(data: Data?, response: URLResponse?,
                                       error: Error?) -> BoardEditResult {
        guard let jsonData = data else {
            guard let error = error else {
                return .failure(ImageBoardAPIError.invalidJSONData)
            }
            return .failure(error)
        }
        
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return .failure(ImageBoardAPIError.invalidResponse)
        }
        
        do {
            print(try JSONSerialization.jsonObject(with: data!, options: []))
        } catch  {
            
        }
        
        guard httpURLResponse.statusCode == 200 else {
            let denyAttempt = ImageBoardAPIError.denyAttempt(httpURLResponse.statusCode)
            print(httpURLResponse)
            return .failure(denyAttempt)
        }
        
        return .success(jsonData)
    }
}

// MARK: extract
extension BoardManager {
    fileprivate func boards(fromJSONData data: Data) -> BoardResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data,
                                                                   options: [])
            
            guard let boardsArray = jsonObject as? [[String: Any]] else {
                return .failure(ImageBoardAPIError.invalidJSONData)
            }
            
            var fetchedBoard = [Board]()
            
            for boardJSON in boardsArray.reversed() {
                if let board = board(fromJSONObject: boardJSON) {
                    fetchedBoard.append(board)
                }
            }
            
            guard fetchedBoard.count != 0 || boardsArray.count <= 0 else {
                return .failure(ImageBoardAPIError.invalidJSONData)
            }
            
            return .success(fetchedBoard)
        } catch {
            return .failure(error)
        }
    }
    
    fileprivate func board(fromJSONObject json: [String: Any]) -> Board? {
        guard let boardID = json[JSONElement.boardID] as? String,
            let imageTitle = json[JSONElement.imageTitle] as? String,
            let imageURL = json[JSONElement.imageURL] as? String,
            let thumbImageURL = json[JSONElement.thumbImageURL] as? String,
            let writerID = json[JSONElement.writerID] as? String,
            let writerNickName = json[JSONElement.writerNickName] as? String,
            let imageDescription = json[JSONElement.imageDescription] as? String,
            let dateCreated = json[JSONElement.dateCreated] as? Int else {
                return nil
        }
        
        return Board(boardID: boardID, imageTitle: imageTitle, imageURL: imageURL,
                     thumbImageURL: thumbImageURL, writerID: writerID,
                     writerNickName: writerNickName, imageDescription: imageDescription,
                     dateCreated: dateCreated)
    }
}
