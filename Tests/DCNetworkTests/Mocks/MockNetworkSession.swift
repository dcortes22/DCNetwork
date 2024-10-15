//
//  MockNetworkSession.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation
@testable import DCNetwork

class MockNetworkSession: NetworkSession {
    var lastURLRequest: URLRequest?
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.lastURLRequest = request
        if let error = error {
            throw error
        }
        return (data ?? Data(), urlResponse ?? URLResponse())
    }
}
