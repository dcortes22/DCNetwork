//
//  MimeType.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

/// Represents common MIME types used in HTTP requests for identifying file formats.
public enum MimeType {
    case jpeg
    case png
    case gif
    case pdf
    case plainText
    case json
    case xml
    case formURLEncoded
    case html
    case css
    case javascript
    case octetStream
    case custom(String)
    
    var value: String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .png:
            return "image/png"
        case .gif:
            return "image/gif"
        case .pdf:
            return "application/pdf"
        case .plainText:
            return "text/plain"
        case .json:
            return "application/json"
        case .xml:
            return "application/xml"
        case .formURLEncoded:
            return "application/x-www-form-urlencoded"
        case .html:
            return "text/html"
        case .css:
            return "text/css"
        case .javascript:
            return "application/javascript"
        case .octetStream:
            return "application/octet-stream"
        case .custom(let mimeType):
            return mimeType
        }
    }
}
