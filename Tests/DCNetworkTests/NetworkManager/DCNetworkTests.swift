import XCTest
@testable import DCNetwork

final class DCNetworkTests: XCTestCase {
    func testPerformRequest_Success() async throws {
        // Setup mock session
        let mockSession = MockNetworkSession()
        mockSession.data = "{ \"key\": \"value\" }".data(using: .utf8)
        mockSession.urlResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Setup request
        let request = MockDataRequest()
        
        // Execute perform
        let result = try await DCNetworkManager.perform(request: request, session: mockSession)
        
        // Assert the result
        XCTAssertEqual(result.key, "value")
    }
    
    func testPerformRequest_Failure() async {
        // Setup mock session with error
        let mockSession = MockNetworkSession()
        mockSession.error = URLError(.badServerResponse)
        
        // Setup request
        let request = MockDataRequest()
        
        // Execute perform and expect failure
        do {
            _ = try await DCNetworkManager.perform(request: request, session: mockSession)
            XCTFail("Expected failure, but request succeeded")
        } catch {
            // Assert error is of expected type
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }
    
    func testPerformRequest_InvalidResponse() async {
        // Setup mock session
        let mockSession = MockNetworkSession()
        mockSession.data = Data()
        mockSession.urlResponse = URLResponse()
        
        // Setup request
        let request = MockDataRequest()
        
        // Execute perform and expect failure
        do {
            _ = try await DCNetworkManager.perform(request: request, session: mockSession)
            XCTFail("Expected failure, but request succeeded")
        } catch {
            // Assert error is of expected type
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
    
    func testPerformRequest_StatusCodeError() async {
        // Setup mock session
        let mockSession = MockNetworkSession()
        mockSession.data = Data()
        mockSession.urlResponse = HTTPURLResponse(
            url: URL(string: "https://api.mock.com/mockendpoint")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Setup request
        let request = MockDataRequest()
        
        // Execute perform and expect failure
        do {
            _ = try await DCNetworkManager.perform(request: request, session: mockSession)
            XCTFail("Expected failure, but request succeeded")
        } catch {
            // Assert that the error is of the correct type and contains the correct status code
            if case let NetworkError.statusCodeError(statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected NetworkError.statusCodeError, but got \(error)")
            }
        }
    }
    
    func testPerformWithFormData() async throws {
        let mockSession = MockNetworkSession()
        mockSession.data = "{ \"key\": \"value\" }".data(using: .utf8)
        mockSession.urlResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com/upload")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let fileData = FileData(
            name: "file",
            fileName: "image.jpg",
            mimeType: .jpeg,
            data: "image_data".data(using: .utf8)!
        )

        let request = UploadRequest(files: [fileData])

        let response = try await DCNetworkManager.perform(request: request, session: mockSession)

        XCTAssertNotNil(mockSession.lastURLRequest)
        XCTAssertEqual(mockSession.lastURLRequest?.httpMethod, "POST")
        XCTAssertEqual(mockSession.lastURLRequest?.value(forHTTPHeaderField: "Content-Type"), "multipart/form-data; boundary=boundary123")

        let bodyString = String(data: mockSession.lastURLRequest!.httpBody!, encoding: .utf8)
        XCTAssertTrue(bodyString!.contains("Content-Disposition: form-data; name=\"description\""))
        XCTAssertTrue(bodyString!.contains("File upload"))
        XCTAssertTrue(bodyString!.contains("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\""))
        XCTAssertTrue(bodyString!.contains("Content-Type: image/jpeg"))
        XCTAssertTrue(bodyString!.contains("image_data"))
        
        XCTAssertEqual(response.key, "value")
    }
    
    func testPerformWithFormURLEncoded() async throws {
        
        let mockSession = MockNetworkSession()
        mockSession.data = "{ \"key\": \"value\" }".data(using: .utf8)
        mockSession.urlResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com/submit")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let request = FormRequest()

        let response = try await DCNetworkManager.perform(request: request, session: mockSession)

        XCTAssertNotNil(mockSession.lastURLRequest)
        XCTAssertEqual(mockSession.lastURLRequest?.httpMethod, "POST")
        XCTAssertEqual(mockSession.lastURLRequest?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")

        let bodyString = String(data: mockSession.lastURLRequest!.httpBody!, encoding: .utf8)
        XCTAssertTrue(bodyString!.contains("name=John"))
        XCTAssertTrue(bodyString!.contains("age=30"))
        
        XCTAssertEqual(response.key, "value")
    }
    
    func testPerformWithEmptyResponse() async throws {
        
        let mockSession = MockNetworkSession()
        mockSession.data = Data()
        mockSession.urlResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com/submit")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let request = EmptyDataRequest()
        
        let response = try await DCNetworkManager.perform(request: request, session: mockSession)
        
        XCTAssertNotNil(mockSession.lastURLRequest)
        XCTAssertEqual(mockSession.lastURLRequest?.httpMethod, "POST")
        XCTAssertNil(response)
    }
}
