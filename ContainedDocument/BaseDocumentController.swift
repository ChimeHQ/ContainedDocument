//
//  BaseDocumentController.swift
//  ContainedDocument
//
//  Created by Matthew Massicotte on 2021-02-16.
//

import Cocoa

class BaseDocumentController: NSDocumentController {
    typealias OpenDocumentResult = Result<(NSDocument, Bool), Error>
    
    override func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (NSDocument?, Bool, Error?) -> Void) {
        openDocument(withContentsOf: url, display: displayDocument) { result in
            switch result {
            case .failure(let error):
                completionHandler(nil, false, error)
            case .success((let doc, let alreadyOpen)):
                completionHandler(doc, alreadyOpen, nil)
            }
        }
    }

    open func openDocument(withContentsOf url: URL, display displayDocument: Bool, completionHandler: @escaping (OpenDocumentResult) -> Void) {
        super.openDocument(withContentsOf: url,
                     display: displayDocument) { doc, alreadyOpen, error in
            let result = OpenDocumentResult(doc, alreadyOpen, error)
            
            completionHandler(result)
        }
    }
    
    override func reopenDocument(for urlOrNil: URL?, withContentsOf contentsURL: URL, display displayDocument: Bool, completionHandler: @escaping (NSDocument?, Bool, Error?) -> Void) {
        reopenDocument(for: urlOrNil, withContentsOf: contentsURL, display: displayDocument) { result in
            switch result {
            case .failure(let error):
                completionHandler(nil, false, error)
            case .success((let doc, let alreadyOpen)):
                completionHandler(doc, alreadyOpen, nil)
            }
        }
    }
    
    open func reopenDocument(for urlOrNil: URL?, withContentsOf contentsURL: URL, display displayDocument: Bool, completionHandler: @escaping (OpenDocumentResult) -> Void) {
        super.reopenDocument(for: urlOrNil,
                       withContentsOf: contentsURL,
                       display: displayDocument) { doc, alreadyOpen, error in
            let result = OpenDocumentResult(doc, alreadyOpen, error)
            
            completionHandler(result)
        }
    }
}

extension BaseDocumentController.OpenDocumentResult {
    init(_ document: NSDocument?, _ alreadyOpen: Bool, _ error: Error?) {
        switch (document, alreadyOpen, error) {
        case (let doc?, _, nil):
            self = .success((doc, alreadyOpen))
        case (nil, false, let error?):
            self = .failure(error)
        default:
            let error = NSError(domain: NSCocoaErrorDomain, code: 1)
            
            self = .failure(error)
        }
    }
}
