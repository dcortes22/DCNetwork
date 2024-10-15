//
//  FormRequest.swift
//  DCNetwork
//
//  Created by David Cortes on 15/10/24.
//

import DCNetwork
import Foundation

struct FormRequest: DataRequest {
    typealias Response = MockResponse
                
    var scheme: String = "https"
    var baseUrl: String = "api.example.com"
    var path: String = "/submit"
    var method: HttpMethod = .post
    var headers: [String: String] = ["Authorization": "Bearer token"]
    var parameters: [String: Any] = ["name": "John", "age": 30]
    var contentType: ContentType = .formURLEncoded
    var files: [FileData] = []
}
