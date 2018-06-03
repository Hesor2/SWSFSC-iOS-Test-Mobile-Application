import Foundation

public class User : DBObject
{
    public var name: String
    
    required public init(dictionary:[String:Any])
    {
        name = dictionary["name"] as! String
        super.init(dictionary: dictionary)
    }
    
    public init(name: String)
    {
        self.name = name;
        super.init(dictionary: ["name" : name])
    }
    
    public func toJSON() -> Data?
    {
        let encoder = JSONEncoder()
        let dictionary = ["name" : name]
        if let jsonData = try? encoder.encode(dictionary)
        {
            return jsonData
        }
        return nil
    }
}
