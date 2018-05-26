import Foundation
import Firebase
import FirebaseAuth

public class API
{
    private static var baseUrl = ""
    private static var serviceCode = ""
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
            print(String(describing: idToken))
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
            //config.httpAdditionalHeaders?["Authorization"] = idToken
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
                                completion(nil, response, error)
                            }
                            completion(data, response, error)
                        }
                        
                }
            })
            task.resume()
        }
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
                    //print("array size: \(objectArray.count)")
                    
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
        return objectArray
    }
    
    private static func toJSONCollection<T: DBObject>(collectionID: String, collection: [T]) -> Data?
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
    }
    
    public static func setConnection(newBaseUrl: String, newServiceCode: String)
    {
        baseUrl = newBaseUrl
        serviceCode = newServiceCode
    }
    
    /*
    public class Allergies
    {
        private static var baseUrl = "allergies"
        
        public static func getAllergies(completion: @escaping (_ allergies: [Allergy]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl, method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        if let allergies = API.fromJSONCollection(collectionID: "allergies", data: data) as [Allergy]?
                        {
                            completion(allergies, nil)
                        }
                    }
            })
        }
        
        public static func getUserAllergies(completion: @escaping (_ allergies: [Allergy]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl + "/user", method: "GET", body: nil, completion:
                {
                    (data, response, error) in
                    if error != nil
                    {
                        completion(nil, error)
                    }
                    else
                    {
                        
                        if let allergies = API.fromJSONCollection(collectionID: "allergies", data: data) as [Allergy]?
                        {
                            completion(allergies, nil)
                        }
                    }
            })
        }
        
    }
    */
    public class Seasons
    {
        private static var baseUrl = "seasons"
        
        public static func getAll(completion: @escaping (_ seasons: [Season]?, _ error: Error?) -> Void)
        {
            API.makeRequest(url: baseUrl, method: "GET", body: nil, completion:
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
        
        
    }
    
}


