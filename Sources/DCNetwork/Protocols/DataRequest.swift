//
//  DataRequest.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

public protocol DataRequest {
    associatedtype Response: Decodable
    
    var scheme: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var contentType: ContentType { get }
    var files: [FileData] { get }
    
    func decode(_ data: Data) throws -> Response
}

public extension DataRequest {
    var sheme: String { "https" }
    
    var method: HttpMethod { .get }
    
    var headers: [String: String] { [:] }
    
    var parameters: [String: Any] { [:] }
    
    var contentType: ContentType { .json }
    
    var files: [FileData] { [] }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
