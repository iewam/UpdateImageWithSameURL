# UpdateImageWithSameURL
- 使用`SDWebImage`在不修改图片链接的情况下，从后台获取新的图片

1、`配置请求的header，在application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions时，设置请求头`

![配置HeaderFilter](https://github.com/iewam/UpdateImageWithSameURL/blob/master/LastModified/LastModified/config.png)

2、`使用 SDWebImage 加载图片，选择对应的options为：SDWebImageRefreshCached`

![加载图片](https://github.com/iewam/UpdateImageWithSameURL/blob/master/LastModified/LastModified/use.png)
