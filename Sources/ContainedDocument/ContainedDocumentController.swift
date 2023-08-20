import AppKit

open class ContainedDocumentController<Container>: BaseDocumentController {
    /// The container currently being used to open/create a document
    ///
    /// This is one-shot variable, used to hook into the NSDocument lifecycle at the
    /// most convenient times. It should never survive longer than one operation.
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

    func duplicatingDocument(_ document: NSDocument) {
        let existingContainer = documentContainer(for: document)

        if let container = existingContainer {
            setActiveContainer(container)
        }
    }

    override open func duplicateDocument(withContentsOf url: URL, copying duplicateByCopying: Bool, displayName displayNameOrNil: String?) throws -> NSDocument {
        let newDoc = try super.duplicateDocument(withContentsOf: url, copying: duplicateByCopying, displayName: displayNameOrNil)

        self.activeContainer = nil

        return newDoc
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

    /// Used to query the current container of a document.
    ///
    /// The default implemenation returns nil.
    open func documentContainer(for document: NSDocument) -> Container? {
        return nil
    }
    
    /// Hook into ContainedDocument window restoration
    ///
    /// This is useful for encoding the window restoration state needed for
    /// restoring the document-container relationship. This only works for
    /// `ContainedDocument` subclasses. And, if you do more state restoration
    /// work in your subclass, make sure to call super there.
    open func encodeRestorableState(with coder: NSCoder, for document: NSDocument) {
    }
    
    /// Hook into ContainedDocument window restoration
    ///
    /// This is useful for restoring the window restoration state. This happens
    /// very early in the `NSDocument` lifecycle, so the document-container
    /// relationship can be established before UI is created. This only works for
    /// `ContainedDocument` subclasses. And, if you do more state restoration
    /// work in your subclass, make sure to call super there.
    open func restoreState(with coder: NSCoder, for document: NSDocument) {
    }
    
    open func openDocument(withContentsOf url: URL, in container: Container, display: Bool, completionHandler: @escaping (Result<(NSDocument, Bool), Error>) -> Void) {
        setActiveContainer(container)
        
        openDocument(withContentsOf: url, display: display) { (result) in
            self.activeContainer = nil
            completionHandler(result)
        }
    }

    @available(macOS 10.15, *)
    open func openDocument(withContentsOf url: URL, in container: Container, display: Bool) async throws -> (NSDocument, Bool) {
        return try await withCheckedThrowingContinuation({ continuation in
            openDocument(withContentsOf: url, in: container, display: display) { result in
                continuation.resume(with: result)
            }
        })
    }

    open func openUntitledDocumentAndDisplay(_ displayDocument: Bool, in container: Container) throws -> NSDocument {
        setActiveContainer(container)

        let doc = try super.openUntitledDocumentAndDisplay(displayDocument)

        self.activeContainer = nil

        return doc
    }
}

extension ContainedDocumentController {
    private func setActiveContainer(_ container: Container) {
        assert(activeContainer == nil)
        self.activeContainer = container
    }

    private func associateActiveContainer(to document: NSDocument) {
        guard let container = activeContainer else { return }

        associateDocument(document, to: container)

        // This is really just paranoia. But, it's not good at all
        // if this value remains set for too long. Can corrupt state
        // and leak.
        self.activeContainer = nil
    }
}
