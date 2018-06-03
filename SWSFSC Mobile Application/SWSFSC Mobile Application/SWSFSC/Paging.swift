import Foundation

public class Paging
{
    public var page: Int
    public static let page_size: Int = 10
    
    required public init(page: Int)
    {
        self.page = page
    }
    
    public func toJSON() -> Data?
    {
        let encoder = JSONEncoder()
        let dictionary = ["page" : page, "page_size" : Paging.page_size]
        if let jsonData = try? encoder.encode(dictionary)
        {
            return jsonData
        }
        return nil
    }
}
