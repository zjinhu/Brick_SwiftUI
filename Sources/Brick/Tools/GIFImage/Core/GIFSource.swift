//
//  File.swift
//  
//
//  Created by Igor Ferreira on 29/10/2020.
//

import Foundation

public enum GIFSource: Equatable {
    case remoteURL(_ url: URL)
    case remoteRequest(_ request: URLRequest)
    case local(filePath: String)
    case `static`(data: Data)
}
