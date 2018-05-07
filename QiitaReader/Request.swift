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
    typealias Response = [ArticleByHimotoki]
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> FetchRepositoryRequest.Response {
        return try decodeArray(object)
    }
}



struct Tag: Himotoki.Decodable {
    let name: String
    
    static func decode(_ e: Extractor) throws -> Tag {
        return try Tag(
            name:   e <| "name"
        )
    }
}


struct ArticleByHimotoki: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] // 変数の型をPersonの配列にする
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> ArticleByHimotoki {
        return try ArticleByHimotoki(
            title: e <| "title",
            authorName: e <| ["user", "id"],
            authorImageUrl: e <| ["user", "profile_image_url"],
            goodCnt: e <| "likes_count",
            tags: e <|| "tags", //変数の型がDecodableの場合は階層的にデコードしてくれる
            url: e <| "url",
            id: e <| "id"
        )
    }
}



