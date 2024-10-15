# DCNetwork

`DCNetwork` is a library designed to handle HTTP network requests in a clean, structured, and efficient manner. It provides a set of utilities, including the core class `DCNetworkManager`, which simplifies the process of making network requests, serializing parameters, and decoding responses.

## Installation

### Swift Package Manager

You can integrate `DCNetwork` into your project using [Swift Package Manager (SPM)](https://swift.org/package-manager/).

#### Step 1: Open Xcode

1. In Xcode, select **File > Add Packages**.
2. Enter the URL of this repository in the search bar: `https://github.com/dcortes22/DCNetwork`
3. Select the appropriate version or branch (typically `main` or a version like `1.0.0`).
4. Click **Add Package**.

#### Step 2: Add Dependency to `Package.swift`

If you are using Swift Package Manager in your own project via the `Package.swift` file, you can add `DCNetwork` as a dependency by including it in the `dependencies` section:

```swift
dependencies: [
    .package(url: "https://github.com/dcortes22/DCNetwork", from: "1.0.0")
]
```

Then, include DCNetwork as a dependency for your target:

```swift
.target(
    name: "YourTargetName",
    dependencies: [
        .product(name: "DCNetwork", package: "DCNetwork")
    ]
)
```

#### Step 3: Import DCNetwork

After the package has been added, you can import DCNetwork wherever you need it:

```swift
import DCNetwork
```

Now you’re ready to start using DCNetwork in your project!

## DCNetworkManager

`DCNetworkManager` is the main class that handles network requests within the `DCNetwork` library. It provides an asynchronous method for executing network requests, managing various HTTP methods, handling serialization, and decoding responses.

### Usage

To use the `DCNetworkManager`, you need to create a request object that conforms to DataRequest, which defines the expected response type, HTTP method, parameters, headers, and other request-related information. Then, call the `perform(request:session:)` method to execute the request asynchronously. The response will be decoded into the type defined by the `DataRequest`.

```swift
struct MyDataRequest: DataRequest {
    typealias Response = MyResponseModel
    
    var scheme: String = "https"
    var baseUrl: String = "api.example.com"
    var path: String = "/data"
    var method: HttpMethod = .get
    var headers: [String: String] = ["Authorization": "Bearer token"]
    var parameters: [String: Any] = [:]
    var contentType: ContentType = .json
    var files: [FileData] = []
}

let request = MyDataRequest()

Task {
    do {
        let response = try await DCNetworkManager.perform(request: request)
        print("Response: \(response)")
    } catch {
        print("Error: \(error)")
    }
}
```

#### Error Handling

The DCNetworkManager class throws various network-related errors using the NetworkError enum:

- NetworkError.invalidURL: Thrown when the URL is invalid or cannot be constructed.
- NetworkError.invalidResponse: Thrown when the response cannot be cast to HTTPURLResponse.
- NetworkError.statusCodeError(Int): Thrown when the HTTP status code is not within the 200-299 range.
- NetworkError.decodeError(String): Thrown when there is a decoding error while trying to decode the response data.

These errors help identify issues related to the request execution and response handling.

#### Multipart File Upload

If your request includes files, you need to provide an array of FileData and set the ContentType to formData.

```swift
let imageData = UIImage(named: "example")!.jpegData(compressionQuality: 0.8)!

struct MyFileUploadRequest: DataRequest {
    typealias Response = UploadResponseModel
    
    var scheme: String = "https"
    var baseUrl: String = "api.example.com"
    var path: String = "/upload"
    var method: HttpMethod = .post
    var headers: [String: String] = ["Authorization": "Bearer token"]
    var parameters: [String: Any] = ["description": "File upload"]
    var contentType: ContentType = .formData(boundary: "boundary123")
    var files: [FileData] = [
        FileData(name: "file", fileName: "image.jpg", mimeType: .jpeg, data: imageData)
    ]
}

let request = MyFileUploadRequest()

Task {
    do {
        let response = try await DCNetworkManager.perform(request: request)
        print("Upload successful: \(response)")
    } catch {
        print("Upload failed: \(error)")
    }
}
```

#### Handling Multipart Requests with Files

When making a multipart/form-data request that includes files, you need to:

1. Set the contentType to .formData(boundary: String) with a unique boundary.
2. Provide an array of FileData, where each file includes:
 - name: The form field name for the file.
 - fileName: The name of the file to be uploaded.
 - mimeType: The MIME type of the file (e.g., .jpeg, .png, .pdf).
 - data: The file’s data, typically in Data format.

The files will be serialized as part of the request body, and the boundary will be used to separate the form fields and files.

#### Example of FileData Structure:

``` swift
let file = FileData(
    name: "profilePicture",
    fileName: "profile.jpg",
    mimeType: .jpeg,
    data: imageData
)
```

This structure is passed to the files property of the request when making multipart/form-data requests.

#### URL-Encoded Form Data

When sending URL-encoded form data (application/x-www-form-urlencoded), you must:

1. Set the contentType to .formURLEncoded.
2. Provide the parameters as a dictionary ([String: Any]), which will be serialized as key-value pairs in the body of the request.

This is useful for many types of web forms or APIs that expect URL-encoded parameters in the body of the request.

```swift
struct MyFormURLEncodedRequest: DataRequest {
    typealias Response = MyResponseModel
    
    var scheme: String = "https"
    var baseUrl: String = "api.example.com"
    var path: String = "/submit"
    var method: HttpMethod = .post
    var headers: [String: String] = ["Authorization": "Bearer token"]
    var parameters: [String: Any] = ["name": "John", "age": 30]
    var contentType: ContentType = .formURLEncoded
    var files: [FileData] = []
}

let request = MyFormURLEncodedRequest()

Task {
    do {
        let response = try await DCNetworkManager.perform(request: request)
        print("Form submitted successfully: \(response)")
    } catch {
        print("Submission failed: \(error)")
    }
}
```

## License

This library is licensed under the MIT License - see the [License](LICENSE) file for details.