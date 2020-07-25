# ChatApp iOS
A simple chat application using basic MVVM, SnapKit, IGListKit, RxSwift/RxCocoa, and SocketIO.

# ChatApp API Service
- Check out the <a href="https://github.com/justinetabin/chatapp-api-service">**API**</a>.
- Swagger API <a href="http://13.212.2.125:8000/documentation">**Docs**</a>.

# Architecture Overview
This project's architecture highlights separation of concerns.

### Service Layer
- Encapsulates the interaction between 3rd party service or API.

### Worker Layer
- Encapsulates the complex business or presentation logic and make them reusable.

### Scene Layer
- The UI that can be easily added or swapped in and out without changing any business logic.

# Dependencies
* SnapKit
* IGListKit
* RxSwift & RxCocoa
* Socket.IO Client
* GrowingTextView

# Additional Features
- Dark Mode
- Pagination
- Failed Message Retry
- Portrait / Landscape Mode

# Room for improvements
- Offline Messages Support (CoreData or RealmSwift)
- Unit Tests

