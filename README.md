# ISScrollViewPageSwift

Easy implementation if you need put yours UIViewControllers inside an UIScrollView navigation style.

You can choice Horizontally navigation or Vertically navigation.

- How to set my view controllers?

        var controllers = [FirstViewController(nibName:"FirstViewController",bundle:nil),
                           SecondViewController(nibName:"SecondViewController",bundle:nil),
                           ThirdViewController(nibName:"ThirdViewController",bundle:nil)]
        
        self.scrollViewPage.setViewControllers(controllers)
        

- Set Navigation Type

self.scrollViewPage.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageHorizontally

![alt tag](http://media.giphy.com/media/3xz2BMFd73WBt7YhiM/giphy.gif)

or 

self.scrollViewPage.scrollViewPageType = ISScrollViewPageType.ISScrollViewPageVertically

![alt tag](http://i.giphy.com/lXiRrhjp7gsq9hdBe.gif)
