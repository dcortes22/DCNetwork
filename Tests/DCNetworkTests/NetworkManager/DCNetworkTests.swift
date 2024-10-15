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
}
