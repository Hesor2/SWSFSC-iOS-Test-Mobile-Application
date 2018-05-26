import Foundation
//seasons/current
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
        print(name)
        start_date = dateFormatter.date(from: dictionary["start_date"] as! String)!
        print(start_date)
        end_date = dateFormatter.date(from: dictionary["end_date"] as! String)!
        super.init(dictionary: dictionary)
    }
    
    override public func toDictionay() -> [String:Any]
    {
        return ["name" : name, "start_date" : start_date, "end_date" : end_date]
    }
}
