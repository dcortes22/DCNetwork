//
//  MockDataRequest.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation
@testable import DCNetwork

struct MockDataRequest: DataRequest {
    struct MockResponse: Decodable {
        let key: String
    }
    
    typealias Response = MockResponse

    // Valores de prueba para el request
    var scheme: String = "https"
    var baseUrl: String = "api.mock.com"
    var path: String = "/mockendpoint"
    var method: HttpMethod = .get
    var headers: [String: String] = ["Authorization": "Bearer mock_token"]
    var parameters: [String: Any] = ["param1": "value1"]
    var contentType: ContentType = .json
    var files: [FileData] = []
    
    func decode(_ data: Data) throws -> MockResponse {
        return try JSONDecoder().decode(MockResponse.self, from: data)
    }
}
