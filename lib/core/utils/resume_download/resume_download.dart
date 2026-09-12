// Cross-platform "Download Resume" action.
//
// Resolves at compile time to the correct implementation:
//  - Flutter Web    -> triggers a browser download via an <a download> tag
//  - iOS/Android/Desktop -> writes the bundled PDF to a temp file and
//                           opens it with the OS default viewer/share sheet
export 'resume_download_stub.dart'
    if (dart.library.html) 'resume_download_web.dart'
    if (dart.library.io) 'resume_download_io.dart';
