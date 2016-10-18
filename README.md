# ExpWKWebViewLoadImages
This is a project to test WKWebView's ability to load images.

As explained in [my question on Stackoverflow](http://stackoverflow.com/q/39901982/2062785) I ran into a problem with WKWebView: Using its `loadHTMLString(_: baseURL:)` method it failed to load any local resources like images or CSS files on a real device while (while it did load the resources on Simulator).

With the input I received from several answers I created this project to test WKWebView's image loading ability in different situations:

1. Loading a website from the web with `load(_:)` using a URLRequest.
2. Loading a plain html string with `loadHTMLString(_: baseURL:)` using the Bundle's root URL as baseURL. (The image is stored in the Bundle's root folder at Build time.)
3. Loading a plain html string with `loadHTMLString(_: baseURL:)` using the default Library URL as baseURL. (The image is downloaded from the web and stored in the Library folder.)

While in the first and second case everything works as expected, the webview fails to load the image in the third case.

It seems like either the webview doesn't have access to the Library folder or it cannot load any resources that have been added after build time. 🤔
