//
//  EmptyDataRequest.swift
//  DCNetwork
//
//  Created by David Cortes on 16/10/24.
//

import Foundation
@testable import DCNetwork

struct EmptyDataRequest: DataRequest {
    typealias Response = MockResponse?
    
    var scheme: String = "https"
    var baseUrl: String = "api.mock.com"
    var path: String = "/mockendpoint"
    var method: HttpMethod = .post
    var headers: [String: String] = ["Authorization": "Bearer mock_token"]
    var parameters: [String: Any] = ["param1": "value1"]
    var contentType: ContentType = .json
    var files: [FileData] = []
}
