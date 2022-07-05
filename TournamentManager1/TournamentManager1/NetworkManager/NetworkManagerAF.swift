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
    case dontHaveRights(String)
}


struct Response: Codable {
    let id: String
    let username: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case token
    }
}

extension APINetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "Error: Did not receive data"
        case .httpRequestFailed:
            return "Error: HTTP request failed"
        case .dontHaveRights:
            return "Error: You don't have rights"
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
    
    func postTournaments(token: String, credentials: TournamentDto, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/create"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(credentials)
        
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print(error!)
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
                    print(response!)
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
    
    func loadTournaments(completion: @escaping ([TournamentDetails]) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/registration"
        
        guard let requestUrl = components.url else {
            print("wrong url")
            return
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
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
                print("no json")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }
   
    func loadActiveTournaments(token: String, completion: @escaping ([ActiveTournament]) -> Void) {
        
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/started"
        
        guard let url = components.url else {
            return
        }
    
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer_\(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("HTTP request error \(String(describing: response))")
                return
            }
            do {
                let tourArray: [ActiveTournament] = try JSONDecoder().decode([ActiveTournament].self, from: data)
                DispatchQueue.main.async {
                    completion(tourArray)
                }
                
            } catch {
                print("no json")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }

    func postJoinTour(token: String, id: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/join/\(id)"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(id)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print(error!)
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
                    print(response!)
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
    
    func postStartTour(token: String, id: Int, completion: @escaping (Result<String?, Error>) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/start/\(id)"
        guard let url = components.url else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(id)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print(error!)
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
                    print(response!)
                }
                return
            }
            
//            guard let response = response as? HTTPURLResponse, (406) ~= response.statusCode else {
//                DispatchQueue.main.async {
//                    completion(.failure(GameError.notPermitted(406)))
//                    print(response)
//                }
//                return
//            }
            print("my error code is \(error!._code)")
            
            let message = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(.success(message))
            }

        }
        task.resume()
    }
    
    func loadLeaderBoard(id: Int, completion: @escaping ([Leader]) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/leaderboard/\(id)"
        
        guard let requestUrl = components.url else {
            print("wrong url")
            return
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
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
                var leadersArray = [Leader]()
                let test = try JSONSerialization.jsonObject(with: data)
                if let jsonArray = test as? [[String:Any]] {

                   for x in jsonArray {
                       let leaders = Leader(name: x["name"] as! String, surname: x["surname"] as! String, score: x["score"] as! Int)
                       leadersArray.append(leaders)
                   }
                }
                DispatchQueue.main.async {
                    completion(leadersArray)
                }
                
            } catch {
                print("no json")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        task.resume()
    }
}

