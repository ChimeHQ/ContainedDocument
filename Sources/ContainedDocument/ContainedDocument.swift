import AppKit

open class ContainedDocument<Container>: NSDocument {
    private var documentController: ContainedDocumentController<Container>? {
        return NSDocumentController.shared as? ContainedDocumentController<Container>
    }
    
    override open func restoreWindow(withIdentifier identifier: NSUserInterfaceItemIdentifier, state: NSCoder, completionHandler: @escaping (NSWindow?, Error?) -> Void) {
        // this method *must* be used so we can restore the container before the rest of the
        // state restoration machinery in NSDocumentController sets everything up. This
        // ensures that our container is set before makeWindowControllers gets invoked, which
        // can make other UI management stuff easier.
        documentController?.restoreState(with: state, for: self)
        
        super.restoreWindow(withIdentifier: identifier, state: state, completionHandler: completionHandler)
    }
    
    override open func encodeRestorableState(with coder: NSCoder) {
        documentController?.encodeRestorableState(with: coder, for: self)

        super.encodeRestorableState(with: coder)
    }

    open override func duplicate() throws -> NSDocument {
        // have to hook in here, as there isn't another way to know what
        // document is being duplicated
        documentController?.duplicatingDocument(self)

        return try super.duplicate()
    }
}
