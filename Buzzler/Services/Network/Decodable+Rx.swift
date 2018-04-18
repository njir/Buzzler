//
//  Decodable.swift
//  Buzzler
//
//  Created by 진형탁 on 2018. 4. 18..
//  Copyright © 2018년 Maru. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON

extension ObservableType where E == Response {
    func checkIfAuthenticated() -> Observable<E> {
        return self.map { response in
            guard response.statusCode != 403 || response.statusCode != 404 else {
                throw BuzzlerError.notAuthenticated
            }
            return response
        }
    }
    
    func checkIfRateLimitExceeded() -> Observable<E> {
        return self.map { response -> E in
            guard let httpResponse = response.response as? HTTPURLResponse else {
                throw BuzzlerError.generic
            }
            
            guard let remainingCount = httpResponse.allHeaderFields["X-RateLimit-Remaining"] else {
                throw BuzzlerError.generic
            }
            
            guard (remainingCount as AnyObject).integerValue! != 0 else {
                throw BuzzlerError.rateLimitExceeded
            }
            return response
        }
    }
}

extension ObservableType where E == Response {
    func mapToModels<T: Decodable>(_: T.Type) -> Observable<[T]> {
        return self.mapJSON()
            .map { json -> [T] in
                guard let array = json as? [AnyObject] else {
                    throw BuzzlerError.wrongJSONParsing
                    
                }
                return T.fromJSONArray(array)
        }
    }
    
    func mapToModels<T: Decodable>(_: T.Type, arrayRootKey: String) -> Observable<[T]> {
        return self.mapJSON()
            .map { json -> [T] in
                if let dict = json as? [String : AnyObject],
                    let subJson = dict[arrayRootKey] {
                    return T.fromJSONArray(subJson as! [AnyObject])
                } else {
                    throw BuzzlerError.wrongJSONParsing
                }
        }
    }
    
    func mapToModel<T: Decodable>(_: T.Type) -> Observable<T> {
        return self.mapJSON()
            .map { json -> T in
                return T.fromJSON(json as AnyObject)
        }
    }
}

private extension ObservableType where E == Response {
    func mapSwiftyJSON() -> Observable<JSON> {
        return self.mapJSON()
            .map { json in
                return JSON(json)
        }
    }
}
