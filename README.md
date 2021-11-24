#  AcmeBrowser



a. How to run your project

Requirements:
- Xcode 13.1
- iOS 15+

Open the `acme-browser.xcodeproj`, wait for the project to index, then press CMD + R to run.

<img width="1198" alt="image" src="https://user-images.githubusercontent.com/15709918/143159971-754b7fc6-bf3d-4ccf-844a-7eb0d4b8091f.png">
At a high level, this is how the components interact. There is a composition root, `AppDependencies` that is responsible for creating and hold references to view controller and their dependencies. The components that are being held loosely use the other dependencies indicated by the solid line.


b. Any additional features you implemented
- I added the bookmarks functionality. This was very simple given that the architecture already supports adding new view controllers easily. We also can inject the same bookmark store into the BookmarksViewController and BrowserViewModel
c. Your approach to the product, including any design decisions or tradeoffs you made
- I opted to start with a manual, lightweight DI container. Since everything is abstracted I found it extremely easy to pass around the storage objects for bookmarks and tabs. We could also replace it with Core Data/NSUserDefaults and the functionality won't change.
- I tried to showcase dependency injection wherever possible. There were a few places in the app where I called `UIApplication` directly, and in a more complex scenario, we would want to also turn that into an protocol and inject the implementation.
- I chose delegation as the main communication pattern between components and closure injection where I felt the use case was more simple. There is also one place in the app in the view model that I use Combine because I thought it would be more clear to see a property observed (if we use delegation we could name the variable `bookmarkWasUpdated`, but there are too many ways you can interpret that)
- Approach to finer details are written in the comments
- The BrowserViewController is the main controller that deals with delegate routing and data, and I found that I was starting to need a lot of delegation to communicate between the its many subviews. In production, we can start to consider possibly moving parts of the views into their own container view controller and have shared view models. 
- For the BookmarksViewController and TabsViewController, I decided that the business logic was simple enough I could directly inject dependencies in the view controller and not need any extra indirection.
- Unfortunately I was not able to separate the WkWebView into a clean type to use for tabs. The WKWebView object does not allow the user to set its history stack manually. This means that if we cannot easily persist the back and forward stack of a single WKWebView and repopulate the data. We would have to implement a custom navigation stack and intercept the back() and forward() methods if we want to be able to save each tab and its associated data to Core Data or NSUserDefaults. In terms of architecture, it is also not ideal to be importing WebKit and having Webkit dependencies in non-UI code. This couples our implementation and makes it difficult to extend functionality to, for instance, a new WebKit type if Apple comes out with a different one in the future (like UIWebView vs WKWebView). With more time, a wrapper around WKWebView with a custom history stack would be a more ideal implementation.
- The toolbar items are slightly off because the widths of the SFSymbols are different
