# ISScrollViewPageSwift

Easy implementation if you need put yours UIViewControllers inside an UIScrollView navigation style.

## Current Version

Version: 0.1.4

## How to use it?

You can choice Horizontally navigation or Vertically navigation.

- How to set my view controllers?

```swift
var controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
                   SecondViewController(nibName:"SecondViewController",bundle:nil),
                   ThirdViewController(nibName:"ThirdViewController",bundle:nil)]

self.scrollViewPage.setViewControllers(controllers)
```        

- Set Navigation Type

```swift
self.scrollViewPage.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally
```

![alt tag](http://media.giphy.com/media/3xz2BMFd73WBt7YhiM/giphy.gif)

or 

self.scrollViewPage.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageVertically

![alt tag](http://i.giphy.com/lXiRrhjp7gsq9hdBe.gif)

## Contact

If you have any questions comments or suggestions, send me a message. If you find a bug, or want to submit a pull request, let me know.

* daniel@ilhasoft.com.br
* https://twitter.com/danielamarall

## Copyright and license

Copyright (c) 2015 Daniel Amaral (https://twitter.com/danielamarall). Code released under [the MIT license](LICENSE).
