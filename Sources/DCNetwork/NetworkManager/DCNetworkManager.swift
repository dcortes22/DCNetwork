//
//  DCNetworkManager.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

public final class DCNetworkManager {
    
    
    /// Executes a network request asynchronously using the provided request object and returns the decoded response.
    /// This function builds a URL from the given request, adds query parameters for GET or DELETE methods, sets up headers and the body for POST or PUT requests, and performs the network call using the provided session. It decodes the response data into the expected `Response` type.
    /// - Parameters:
    ///   - request: The request object conforming to `DataRequest`, which provides the necessary details like `scheme`, `baseUrl`, `path`, `method`, `headers`, and `parameters`.
    ///   - session: The `NetworkSession` instance used to perform the network request. Defaults to `URLSession.shared`.
    /// - Throws:
    ///   - `NetworkError.invalidURL`: If the constructed URL is invalid.
    ///   - `NetworkError.invalidResponse`: If the response cannot be cast to `HTTPURLResponse`.
    ///   - `NetworkError.statusCodeError`: If the response status code is outside the 200-299 range.
    ///   - `NetworkError.decodeError`: If there is an error during decoding of the response data.
    /// - Returns: The decoded response of type `T.Response` where `T` conforms to `DataRequest`.
    public static func perform<T, R>(request: T, session: NetworkSession = URLSession.shared) async throws -> R where T: DataRequest, R: Codable {
        guard var urlComponent = URLComponents(string: "\(request.scheme)://\(request.baseUrl)/\(request.path)") else {
            throw NetworkError.invalidURL
        }
        
        if request.method == .get || request.method == .delete {
            urlComponent.queryItems = request.parameters.compactMap { key, value in
                URLQueryItem(name: key, value: Utils.convertToString(value))
            }
        }
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        if (request.method == .post || request.method == .put) && !request.parameters.isEmpty {
            urlRequest.setValue(request.contentType.value, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try ParameterSerializer.serializeParameters(request.parameters, contentType: request.contentType, files: request.files).serialize()
        }
        
        let (data, response) = try await session.data(for: urlRequest)
            
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCodeError(httpResponse.statusCode)
        }
        
        return try ResponseDecoder.decode(request: request, from: data)
    }
}
