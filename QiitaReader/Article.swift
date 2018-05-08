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



//新着/////////////////////////////////////
struct GetArticleRequest: QiitaRequest {
    var path = "/api/v2/items"
    typealias Response = [NewArticleResponse]
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetArticleRequest.Response {
        return try decodeArray(object)
    }
}


struct NewArticleResponse: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] // 変数の型をPersonの配列にする
    let url: String
    let id: String
    
    static func decode(_ e: Extractor) throws -> NewArticleResponse {
        return try NewArticleResponse(
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

struct Tag: Himotoki.Decodable {
    let name: String
    
    static func decode(_ e: Extractor) throws -> Tag {
        return try Tag(
            name:   e <| "name"
        )
    }
}




//トレンド/////////////////////////////////////////
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

struct TrendItems: Himotoki.Decodable {
    let trendItems: [TrendArticle]
    
    static func decode(_ e: Extractor) throws -> TrendItems {
        return try TrendItems(
            trendItems: e <|| "trendItems"
        )
    }
}

struct TrendArticle: Himotoki.Decodable {
    let title: String
    let authorName: String
    let authorImageUrl: String
    let goodCnt: Int
    let tags: [Tag] // 変数の型をPersonの配列にする
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


