import Foundation

public class Admin : User
{
    public var payment_information: String
    
    required public init(dictionary:[String:Any])
    {
        payment_information = dictionary["payment_information"] as! String
        super.init(dictionary: dictionary)
    }
    
    public init(name: String, payment_information: String)
    {
        self.payment_information = payment_information
        super.init(name: name)
    }
    
    public override func toJSON() -> Data?
    {
        let encoder = JSONEncoder()
        let dictionary = ["name" : name, "payment_information": payment_information]
        if let jsonData = try? encoder.encode(dictionary)
        {
            return jsonData
        }
        return nil
    }
}
