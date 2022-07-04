//
//  NetworkManagerAF.swift
//  TournamentManager1
//
//  Created by Aida Moldaly on 23.06.2022.
//

import Foundation


enum APINetworkError: Error {
    case dataNotFound
    case httpRequestFailed
}

extension APINetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "Error: Did not receive data"
        case .httpRequestFailed:
            return "Error: HTTP request failed"
        }
    }
}

final class NetworkManagerAF {

    static var shared = NetworkManagerAF()

    var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8189
        return components
    }()

    private let session: URLSession

    private init() {
        session = URLSession(configuration: .default)
    }

    func postRegister(credentials: PersonSignUp, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/register"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func postLogin(credentials: PersonLogin, completion: @escaping (Result<String?, Error>) -> Void) {
        
        var components = urlComponents
        components.path = "/api/v1/app/auth"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.dataNotFound))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(APINetworkError.httpRequestFailed))
                }
                return
            }
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }
        }
        task.resume()
    }
    
    func postTournaments(credentials: TournamentDto, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/create"
        guard let url = components.url else {
            return
        }
        let token:String = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhaWRhIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImV4cCI6MTY1NjA0Njk0MiwiaWF0IjoxNjU2MDQzMzQyfQ.v8IGRJ_oo_SNE7rEReLTrHMyemZAxQCRK4AF-xFkHgk"
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)
        
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                        error == nil
                    else {                                       // check for fundamental networking error
                        print("Select another game or updated token")//print("error", error ?? URLError(.badServerResponse))
                        return
                    }
                    
                    guard (200 ... 299) ~= response.statusCode else {  // check for http errors
                        print("statusCode should be 2xx, but is \(response.statusCode)")
                        print("response = \(response)")
                        return
                    }
        }
        task.resume()
    }
    
    
    func loadTournaments(completion: @escaping ([TournamentDetails]) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/registration"
        
        guard let requestUrl = components.url else {
            return
        }
        let task = session.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                var tourArray = [TournamentDetails]()
                let test = try JSONSerialization.jsonObject(with: data)
                if let jsonArray = test as? [[String:Any]] {
                   
                   for x in jsonArray {
                       let tempTour = TournamentDetails(id: x["id"] as! Int, type: x["type"] as! String, status: "Registration", description: x["description"] as! String, participants: x["participants"] as! Int)
                        tourArray.append(tempTour)
                   }
                }
                DispatchQueue.main.async {
                    completion(tourArray)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }

    func loadActiveTournaments(completion: @escaping ([ActiveTournaments]) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/started"
        
        guard let requestUrl = components.url else {
            return
        }
        let task = session.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                var tourArray = [ActiveTournaments]()
                let test = try JSONSerialization.jsonObject(with: data)
                if let jsonArray = test as? [[String:Any]] {
                   
                   for x in jsonArray {
                       let tempTour = ActiveTournaments(id: x["id"] as! Int, name: x["name"] as! String, type: "type", description: x["description"] as! String, participants: x["participants"] as! Int)
                        tourArray.append(tempTour)
                   }
                }
                DispatchQueue.main.async {
                    completion(tourArray)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }

    
    func loadTournamentsMainID(id: Int, completion: @escaping ([TournamentMain]) -> Void ) {
        loadTournamentsMain(path: "/movie/\(id)/credits") { tournaments in
            completion(tournaments)
        }
    }
    
    func loadTournamentsMain(path: String, completion: @escaping ([TournamentMain]) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/id/\(path)"
        
        guard let requestUrl = components.url else {
            return
        }
        let task = session.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                var tourArray = [TournamentMain]()
                let test = try JSONSerialization.jsonObject(with: data)
                if let jsonArray = test as? [[String:Any]] {
                   
                   for x in jsonArray {
                       let tempTour = TournamentMain(id: x["id"] as! Int,name: x["name"] as! String, type: x["type"] as! String, description: x["description"] as! String)
                        tourArray.append(tempTour)
                       }
                }
                DispatchQueue.main.async {
                    completion(tourArray)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }
}

