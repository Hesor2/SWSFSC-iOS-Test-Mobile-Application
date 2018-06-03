import Foundation

public class Competition : DBObject
{
    public let season_name: String
    public let name: String
    public let start_date: Date
    public let end_date: Date
    public let prize: String
    public let winner: String?
    public let payment_information: String
    public let payment_confirmed: Bool?
    
    required public init(dictionary:[String:Any])
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        season_name = dictionary["season_name"] as! String
        name = dictionary["name"] as! String
        start_date = dateFormatter.date(from: dictionary["start_date"] as! String)!
        end_date = dateFormatter.date(from: dictionary["end_date"] as! String)!
        prize = dictionary["prize"] as! String
        winner = dictionary["winner"] as? String
        payment_information = dictionary["payment_information"] as! String
        payment_confirmed = dictionary["payment_confirmed"] as? Bool
        super.init(dictionary: dictionary)
    }
    
    /*public init(season_name: String, name: String, start_date: Date, end_date: Date, prize: String)
    {
        self.name = name
        self.start_date = start_date
        self.end_date = end_date
        super.init(dictionary: ["yup" : 1])
    }*/
    
    public func toJSON() -> Data?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let encoder = JSONEncoder()
        let dictionary = ["season_name" : season_name, "name" : name, "start_date" : dateFormatter.string(from: start_date), "end_date" : dateFormatter.string(from: end_date), "prize" : prize]
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
        let dictionary = ["season_name" : season_name, "competition_name" : name, "page" : String(page), "page_size" : String(Paging.page_size)]
        if let jsonData = try? encoder.encode(dictionary)
        {
            return jsonData
        }
        return nil
    }
}
