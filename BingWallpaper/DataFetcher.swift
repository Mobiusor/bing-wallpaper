import Foundation
import Cocoa
import Alamofire
import SWXMLHash

public protocol DataFetcherDelegate {
    
    func imageFetched(image: NSImage)
    
    func imageInfoFetched(info: WallpaperInfo)
}

public class DataFetcher {
    
    public var delegate: DataFetcherDelegate? = nil
    
    public func fetchWallpaperInfoAsync() {
        Alamofire.request(.GET, Constants.pictureInfoUrl)
            .validate()
            .responseString { response in
                if let value = response.result.value {
                    let xml = SWXMLHash.parse(value)
                    let image = xml["images"]["image"]
                    
                    let info = WallpaperInfo()
                    let urlBase = image["urlBase"].element?.text
                    info.url = Constants.pictureUrlTemplate.stringByReplacingOccurrencesOfString("{0}", withString: urlBase!, options: NSStringCompareOptions.LiteralSearch, range: nil)
                    info.copyright = image["copyright"].element?.text
                    info.startDate = image["startdate"].element?.text
                    info.endDate = image["enddate"].element?.text
                    self.delegate?.imageInfoFetched(info)
                } else {
                    Log.sharedInstance.log.error("fetch wallpaper infomation failed")
                }

            }
    }
    
    public func fetchWallpaperAsync(info: WallpaperInfo) {
        Alamofire.request(.GET, info.url)
            .validate()
            .responseData { response in
                if let data = response.result.value {
                    let image = NSImage(data: data)
                    self.delegate?.imageFetched(image!)
                } else {
                    Log.sharedInstance.log.error("fetch wallpaper image failed")
                }
            }
    }
}
