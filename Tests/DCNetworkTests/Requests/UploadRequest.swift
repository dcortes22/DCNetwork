//
//  File.swift
//  DCNetwork
//
//  Created by David Cortes on 15/10/24.
//

import Foundation
import DCNetwork

struct UploadRequest: DataRequest {
    typealias Response = MockResponse
    
    var scheme: String = "https"
    var baseUrl: String = "api.example.com"
    var path: String = "/upload"
    var method: HttpMethod = .post
    var headers: [String: String] = ["Authorization": "Bearer token"]
    var parameters: [String: Any] = ["description": "File upload"]
    var contentType: ContentType = .formData(boundary: "boundary123")
    var files: [FileData] = []
    
    init(files: [FileData]) {
        self.files = files
    }
}
