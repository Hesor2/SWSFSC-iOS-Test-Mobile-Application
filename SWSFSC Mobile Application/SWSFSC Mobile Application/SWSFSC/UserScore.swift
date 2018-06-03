import Foundation

public class UserScore : DBObject
{
    public let position: Int
    public let user_name: String
    public let score: Int
    
    public required init(dictionary: [String : Any])
    {
        position = dictionary["position"] as! Int
        user_name = dictionary["user_name"] as! String
        score = dictionary["score"] as! Int
        super.init(dictionary: dictionary)
    }
}
