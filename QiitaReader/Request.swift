//
//  Request.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/05/07.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import APIKit
import Himotoki

protocol GitHubRequest: Request {}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://qiita.com/api/v2/items")!
    }
}


struct FetchRepositoryRequest: GitHubRequest {
    var path: String
    typealias Response = [Repository]
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> FetchRepositoryRequest.Response {
        return try decodeArray(object)
    }
}




struct Repository: Himotoki.Decodable {
    let title: String
    
    static func decode(_ e: Extractor) throws -> Repository {
        return try Repository(
            title: e <| "title"
        )
    }
}



