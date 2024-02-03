import Foundation

struct UnicornModel: Codable {
    let _id: String
    let name: String
    let age: Int
    let colour: String
    // Add other properties as needed
}

// Given Api

class APIClient {
    static let shared = APIClient()
    
    func fetchDataFromAPI(completion: @escaping ([UnicornModel]?, Error?) -> Void) {
        guard let url = URL(string: "https://crudcrud.com/api/0cc3c3d1b9ef4c77b46aef6e3d2e6be9/unicorns") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let unicornModels = try decoder.decode([UnicornModel].self, from: data)
                    completion(unicornModels, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, NSError(domain: "No data received from the server.", code: 0, userInfo: nil))
            }
        }.resume()
    }
}
