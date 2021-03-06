import Foundation

public class Season : DBObject
{
    public let name: String
    public let start_date: Date
    public let end_date: Date
    
    required public init(dictionary:[String:Any])
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        name = dictionary["name"] as! String
        start_date = dateFormatter.date(from: dictionary["start_date"] as! String)!
        end_date = dateFormatter.date(from: dictionary["end_date"] as! String)!
        super.init(dictionary: dictionary)
    }
    
    public init(name: String, start_date: Date, end_date: Date)
    {
        self.name = name
        self.start_date = start_date
        self.end_date = end_date
        super.init(dictionary: ["yup" : 1])
    }
    
    public func toDictionay() -> [String:Any]
    {
        return ["name" : name, "start_date" : start_date, "end_date" : end_date]
    }
    
    public func toJSON() -> Data?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let encoder = JSONEncoder()
        let dictionary = ["name" : name, "start_date" : dateFormatter.string(from: start_date), "end_date" : dateFormatter.string(from: end_date)]
        if let jsonData = try? encoder.encode(dictionary)
        {
            return jsonData
        }
        return nil
    }
    
    public func toJSON(page: Int) -> Data?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let encoder = JSONEncoder()
        let dictionary = ["season_name" : name, "page" : String(page), "page_size" : String(Paging.page_size)]
        if let jsonData = try? encoder.encode(dictionary)
        {
            return jsonData
        }
        return nil
    }
}
