//
//  ContainedDocumentController.swift
//  Edit
//
//  Created by Matthew Massicotte on 2021-02-15.
//  Copyright © 2021 Chime Systems. All rights reserved.
//

import Cocoa

open class ContainedDocumentController<Container>: BaseDocumentController {
    private var activeContainer: Container?
    
    open override func makeDocument(withContentsOf url: URL, ofType typeName: String) throws -> NSDocument {
        let doc = try super.makeDocument(withContentsOf: url, ofType: typeName)
        
        associateActiveContainer(to: doc)
        
        return doc
    }
    
    open override func makeDocument(for urlOrNil: URL?, withContentsOf contentsURL: URL, ofType typeName: String) throws -> NSDocument {
        let doc = try super.makeDocument(for: urlOrNil, withContentsOf: contentsURL, ofType: typeName)
        
        associateActiveContainer(to: doc)
        
        return doc
    }
    
    open override func makeUntitledDocument(ofType typeName: String) throws -> NSDocument {
        let doc = try super.makeUntitledDocument(ofType: typeName)
        
        associateActiveContainer(to: doc)
        
        return doc
    }
    
    override open func removeDocument(_ document: NSDocument) {
        disassociateDocument(document)

        super.removeDocument(document)
    }
    
    private func setActiveContainer(_ container: Container) {
        self.activeContainer = container
    }
    
    private func clearActiveContainer() {
        self.activeContainer = nil
    }
    
    private func associateActiveContainer(to document: NSDocument) {
        guard let container = activeContainer else { return }
        
        associateDocument(document, to: container)
        
        // this is one-shot variable, used to hook into the NSDocument lifecycle at the
        // most convenient times.
        clearActiveContainer()
    }
    
    /// Called when a document is being associated to a container
    ///
    /// The default implemenation does nothing. Subclasses can use this to establish
    /// a relationship, if it is appropriate for the document/container type.
    open func associateDocument(_ document: NSDocument, to container: Container) {
    }
    
    /// Called when a document is being removed.
    ///
    /// The default implemenation does nothing. Subclasses can use this to tear down
    /// a relationship, if it is appropriate for the document/container type.
    open func disassociateDocument(_ document: NSDocument) {
    }
    
    /// Hook into ContainedDocument window restoration
    ///
    /// This is useful for encoding the window restoration state needed for
    /// restoring the document-container relationship. This only works for
    /// ContainedDocument subclasses. And, if you do more state restoration
    /// work in your subclass, make sure to call super there.
    open func encodeRestorableState(with coder: NSCoder, for document: NSDocument) {
    }
    
    /// Hook into ContainedDocument window restoration
    ///
    /// This is useful for restoring the window restoration state. This happens
    /// very early in the NSDocument lifecycle, so the document-container
    /// relationship can be established before UI is created. This only works for
    /// ContainedDocument subclasses. And, if you do more state restoration
    /// work in your subclass, make sure to call super there.
    open func restoreState(with coder: NSCoder, for document: NSDocument) {
    }
    
    open func openDocument(withContentsOf url: URL, in container: Container, display: Bool, completionHandler: @escaping (Result<(NSDocument, Bool), Error>) -> Void) {
        self.setActiveContainer(container)
        
        openDocument(withContentsOf: url, display: display) { (result) in
            completionHandler(result)
        }
    }
    
    open func openUntitledDocumentAndDisplay(_ displayDocument: Bool, in container: Container) throws -> NSDocument {
        setActiveContainer(container)
  
        return try super.openUntitledDocumentAndDisplay(displayDocument)
    }
}
