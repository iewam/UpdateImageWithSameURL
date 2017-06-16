# UpdateImageWithSameURL

- 使用`SDWebImage`在不修改图片链接的情况下，从后台获取新的图片

1、`配置请求的header，在application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions时，设置请求头`

![配置HeaderFilter](https://github.com/iewam/UpdateImageWithSameURL/blob/master/LastModified/LastModified/config.png)

- 将本地缓存图片的修改日期添加在请求头当中，如果服务器后台同一URL的图片有被修改，会在响应头的中返回`304 Not Modified`的状态码，如果状态码为`304`会在内部取消请求操作，并加载本地缓存图片返回。查看`SDWebImage`中`SDWebImageDownloaderOperation`的`NSURLSessionDataDelegate`回调方法：
```
  #pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    //'304 Not Modified' is an exceptional one
    if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode < 400 && ((NSHTTPURLResponse *)response).statusCode != 304)) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
        for (SDWebImageDownloaderProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(0, expected, self.request.URL);
        }
        
        self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
        self.response = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadReceiveResponseNotification object:self];
        });
    }
    else {
        NSUInteger code = ((NSHTTPURLResponse *)response).statusCode;
        
        //This is the case when server returns '304 Not Modified'. It means that remote image is not changed.
        //In case of 304 we need just cancel the operation and return cached image from the cache.
        // 如果返回状态码为 304 会在内部取消该操作，并获取本地图片缓存展示
        if (code == 304) {
            [self cancelInternal];
        } else {
            [self.dataTask cancel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:self];
        });
        
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:((NSHTTPURLResponse *)response).statusCode userInfo:nil]];

        [self done];
    }
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

```

2、`使用 SDWebImage 加载图片，选择对应的options为：SDWebImageRefreshCached`

![加载图片](https://github.com/iewam/UpdateImageWithSameURL/blob/master/LastModified/LastModified/use.png)
