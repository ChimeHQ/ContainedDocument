<div align="center">

[![Platforms][platforms badge]][platforms]
[![Documentation][documentation badge]][documentation]
[![Discord][discord badge]][discord]

</div>

# ContainedDocument

ContainedDocument allows you to nest `NSDocument` instances inside of abstract containers. These can be anything you need, including other `NSDocument` instances. This turns out to be a very tricky thing to do, and requires careful management of an `NSDocumentController` to make it possible.

Supporting the full range of `NSDocument` operations and interactions is challenging. I was able to pull off many of them, but the coordination still requires subclassing both `NSDocument` and `NSDocumentController`. 

## Integration

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/ContainedDocument", from: "1.0.0")
]
```

## Classes

**ContainedDocumentController**

An `NSDocumentController` subclass that manages the `NSDocument` life-cycle and relationship to your containers. To use it, you must override the three container-document association methods. Restorable state is supported, but is optional.

```swift
open func associateDocument(_ document: NSDocument, to container: Container)
open func disassociateDocument(_ document: NSDocument)
open func documentContainer(for document: NSDocument) -> Container?

open func encodeRestorableState(with coder: NSCoder, for document: NSDocument)
open func restoreState(with coder: NSCoder, for document: NSDocument)
// ...
```

Also, don't forget that an `NSDocumentController` is global to your AppKit process. You must instantiate your subclass as soon as possible to ensure it is being used.

**ContainedDocument**

This is an `NSDocument` subclass that makes it possible to support document duplication and window restoration.

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. A [Discord server][discord] is also available for live help, but I have a strong bias towards answering in the form of documenation.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[platforms]: https://swiftpackageindex.com/ChimeHQ/ContainedDocument
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FContainedDocument%2Fbadge%3Ftype%3Dplatforms
[documentation]: https://swiftpackageindex.com/ChimeHQ/ContainedDocument/main/documentation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue
[discord]: https://discord.gg/esFpX6sErJ
[discord badge]: https://img.shields.io/badge/Discord-purple?logo=Discord&label=Chat&color=%235A64EC
