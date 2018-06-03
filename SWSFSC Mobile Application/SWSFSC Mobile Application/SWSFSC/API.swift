import Foundation
import Firebase
import FirebaseAuth

public class API
{
    private static var baseUrl = ""
    private static var serviceCode = ""
    
    public enum APIError:Error
    {
        case AccessDenied
    }
    
    private static func makeRequest(url : String, method: String, body: Data?, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    {
        //getIDTokenForcingRefresh:(BOOL)forceRefresh
        //completion:(nullable FIRAuthTokenCallback)completion;
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(false) {idToken, error in
            if let error = error
            {
                completion(nil, nil, error)
                return
            }
            //print(String(describing: idToken))
            // Send token to your backend via HTTPS
            // ...
            guard let requestUrl = URL(string:baseUrl+url) else { return }
            var request = URLRequest(url:requestUrl)
            request.httpMethod = method
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            request.setValue(serviceCode, forHTTPHeaderField: "ServiceCode")
            if body != nil
            {
                request.httpBody = body
            }
            
            let config = URLSessionConfiguration.default // Session Configuration
            let session = URLSession(configuration: config) // Load configuration into Session
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) in
                
                DispatchQueue.main.async
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("statusCode: \(httpResponse.statusCode)")
                            if httpResponse.statusCode != 200
                            {
                                completion(nil, response, APIError.AccessDenied)
                            }
                            completion(data, response, error)
                        }
                        
                }
            })
            task.resume()
        }
    }
    
    private static func makeUnauthorizedRequest(url : String, method: String, body: Data?, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    {
        guard let requestUrl = URL(string:baseUrl+url) else { return }
        var request = URLRequest(url:requestUrl)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(serviceCode, forHTTPHeaderField: "ServiceCode")
        if body != nil
        {
            request.httpBody = body
        }
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            DispatchQueue.main.async
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("statusCode: \(httpResponse.statusCode)")
                        if httpResponse.statusCode != 200
                        {
                            completion(nil, response, APIError.AccessDenied)
                        }
                        completion(data, response, error)
                    }
                    
            }
        })
        task.resume()
    }
    
    private static func fromJSONCollection<T: DBObject>(collectionID: String, data: Data?) -> [T]
    {
        var objectArray = [T]()
        if data != nil
        {
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                {
                    if let objects = json[collectionID] as? [[String: Any]]
                    {
                        for item in objects
                        {
                            let object = T(dictionary: item)
                            
                            objectArray.append(object)
                        }
                    }                    
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
        return objectArray
    }
    
    /*private static func toJSONCollection<T: DBObject>(collectionID: String, collection: [T]) -> Data?
    {
        var dictionary = [[String:Any]]()
        for item in collection
        {
            dictionary.append(item.toDictionay())
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: [collectionID:dictionary], options: [])
        {
            return jsonData
        }
        else
        {
            return nil
        }
    }*/
    
    public static func setConnection(newBaseUrl: String, newServiceCode: String)
    {
        baseUrl = newBaseUrl
        serviceCode = newServiceCode
    }
    
    public class Authorization
    {
        private static var baseUrl = "authorization"
        
        public static func checkOwner(completion: @escaping (_ isOwner: Bool) -> Void)
        {
            API.makeRequest(url: baseUrl+"/checkOwner", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
            })
        }

        public static func createAdmin(admin: Admin, completion: @escaping (_ complete: Bool) -> Void)
        {
            let json = admin.toJSON()
            API.makeRequest(url: baseUrl+"/createAdmin", method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
            })
        }

        public static func checkAdmin(completion: @escaping (_ isAdmin: Bool) -> Void)
        {
            API.makeRequest(url: baseUrl+"/checkAdmin", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
            })
        }
        
        public static func register(user: User, completion: @escaping (_ complete: Bool) -> Void)
        {
            let json = user.toJSON()
            API.makeRequest(url: baseUrl+"/register", method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
            })
        }
        
        public static func checkName(name: String, completion: @escaping (_ available: Bool) -> Void)
        {
            let json = User(name: name).toJSON()
            API.makeUnauthorizedRequest(url: baseUrl+"/checkName", method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
                })
        }
    }
    
    public class Seasons
    {
        private static var baseUrl = "seasons"
        
        public static func getAll(page: Int, completion: @escaping (_ seasons: [Season]?, _ error: Error?) -> Void)
        {
            let json = Paging(page: page).toJSON()
            API.makeRequest(url: baseUrl, method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let seasons = API.fromJSONCollection(collectionID: "seasons", data: data) as [Season]?
                        {
                            completion(seasons, nil)
                        }
                    }
            })
        }
        
        public static func create(season: Season, completion: @escaping (_ complete: Bool) -> Void)
        {
            let json = season.toJSON()
            API.makeRequest(url: baseUrl+"/create", method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(false)
                    }
                    else
                    {
                        completion(true)
                    }
            })
        }
        
        public static func getCompetitions(season: Season, page: Int, completion: @escaping (_ competitions: [Competition]?, _ error: Error?) -> Void)
        {
            let json = season.toJSON(page: page)
            API.makeRequest(url: baseUrl+"/competitions", method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let competitions = API.fromJSONCollection(collectionID: "competitions", data: data) as [Competition]?
                        {
                            completion(competitions, nil)
                        }
                    }
            })
        }
        
        public static func getHighscore(season: Season, page: Int, completion: @escaping (_ scores: [UserScore]?, _ error: Error?) -> Void)
        {
            let json = season.toJSON(page: page)
            API.makeRequest(url: baseUrl+"/highscore", method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil,error)
                    }
                    else
                    {
                        if let userScores = API.fromJSONCollection(collectionID: "userScores", data: data) as [UserScore]?
                        {
                            completion(userScores, nil)
                        }
                    }
            })
        }
    }
    
    public class Competitions
    {
        private static var baseUrl = "competitions"
        
        /*public static func getAll(season: Season, page: Int, completion: @escaping (_ seasons: [Season]?, _ error: Error?) -> Void)
        {
            let json = season.toJSON(page: page)
            API.makeRequest(url: baseUrl, method: "POST", body: json, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let seasons = API.fromJSONCollection(collectionID: "seasons", data: data) as [Season]?
                        {
                            completion(seasons, nil)
                        }
                    }
            })
        }*/
    }
    
}


