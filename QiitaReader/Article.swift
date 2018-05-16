//
//  Article.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/18.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import APIKit
import Himotoki
import RealmSwift


protocol QiitaRequest: Request {}

extension QiitaRequest {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
}

struct Article {
    var title: String
    var authorName: String
    var authorImageUrl: String
    var goodCnt: Int
    var tags: [String]
    var url: String
    var id: String
}



//新着/////////////////////////////////////
//リクエスト
struct GetNewRequest: QiitaRequest {
    var path = "/api/v2/items"
    typealias Response = [NewArticle]
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetNewRequest.Response {
        return try decodeArray(object)
    }
}

//レスポンス
struct NewArticle: Himotoki.Decodable { //NewArticleOfNewItems
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] //
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> NewArticle {
        return try NewArticle(
            title: e <| "title",
            authorName: e <| ["user", "id"],
            authorImageUrl: e <| ["user", "profile_image_url"],
            goodCnt: e <| "likes_count",
            tags: e <|| "tags", //変数の型がDecodableの場合は階層的にデコードしてくれる
            url: e <| "url",
            id: e <| "id"
        )
    }
    
    func toArticle() -> Article {
        return Article(
                title: title,
                authorName: authorName,
                authorImageUrl: authorImageUrl,
                goodCnt: goodCnt,
                tags: tags.map { $0.name },
                url: url,
                id: id
            )
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




//トレンド/////////////////////////////////////////
//リクエスト
struct GetTrendRequest: QiitaRequest {
    var path = "/trend.json"
    typealias Response = TrendItems //
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetTrendRequest.Response {
        return try TrendItems.decodeValue(object) //
    }
}
//レスポンス
struct TrendItems: Himotoki.Decodable {
    let trendItems: [TrendArticle]
    
    static func decode(_ e: Extractor) throws -> TrendItems {
        return try TrendItems(
            trendItems: e <|| "trendItems"
        )
    }
    
    func toArticle() -> [Article] {
        return trendItems.map {
            Article(
                title: $0.title,
                authorName: $0.authorName,
                authorImageUrl: $0.authorImageUrl,
                goodCnt: $0.goodCnt,
                tags: $0.tags.map { $0.name },
                url: $0.url,
                id: $0.id
            )
        }
    }
}

struct TrendArticle: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag]
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> TrendArticle {
        return try TrendArticle(
            title: e <| "article" <| "title",
            authorName: e <| "article" <| ["author", "urlName"],
            authorImageUrl: e <| "article" <| ["author", "profileImageUrl"],
            goodCnt: e <| "article" <| "likesCount",
            tags: e <| "article" <|| "tags", //
            url: e <| "article" <| "showUrl",
            id: e <| "article" <| "uuid"
        )
    }
}



//検索/////////////////////////////////////
//リクエスト
struct GetSearchRequest: QiitaRequest {
    let query: String
    let path: String = "/api/v2/items"
    let page: Int
    typealias Response = [SearchArticle]
    var method: HTTPMethod {
        return .get
    }
    var parameters: Any? {
        return [
            "page": page,
            "per_page": 3,
            "query": "title:\(query)"
        ]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetSearchRequest.Response {
        return try decodeArray(object)
    }
}

//レスポンス
struct SearchArticle: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] //
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> SearchArticle {
        return try SearchArticle(
            title: e <| "title",
            authorName: e <| ["user", "id"],
            authorImageUrl: e <| ["user", "profile_image_url"],
            goodCnt: e <| "likes_count",
            tags: e <|| "tags",
            url: e <| "url",
            id: e <| "id"
        )
    }
    
    func toArticle() -> Article {
        return Article(
            title: title,
            authorName: authorName,
            authorImageUrl: authorImageUrl,
            goodCnt: goodCnt,
            tags: tags.map { $0.name },
            url: url,
            id: id
        )
    }
}





////////////////////////////////////////
class RealmArticle: Object {
    @objc dynamic var title = String()
    @objc dynamic var authorName = String()
    @objc dynamic var authorImageUrl = String()
    @objc dynamic var goodCnt = Int()
    var tagList = List<String>()
    @objc dynamic var url = String()
    @objc dynamic var id =  String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


