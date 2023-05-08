//
//  NetworkManagerAF.swift
//  TournamentManager1
//
//  Created by tamzimun on 23.06.2022.
//

import Foundation
import SwiftKeychainWrapper

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
    
    let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")

    var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "localhost"
//        "hack2-jusan.azurewebsites.net"
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
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
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
                    print(response)
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
    
    func postTournaments(token: String, credentials: AddTournament, completion: @escaping (Result<String?, Error>) -> Void) {
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
   
    func loadTournaments(token: String, completion: @escaping ([TournamentLists]) -> Void) {
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/registration"
        
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
                print("Error: HTTP request failed")
                return
            }
            do {
                
                let tourArray: [TournamentLists] = try JSONDecoder().decode([TournamentLists].self, from: data)
                
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
    
    func loadTournamentDetail(token: String, id: Int, completion: @escaping (TournamentDetail) -> Void) {
        
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/id/\(id)"
        
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
                print("Error: HTTP request failed")
                return
            }
            do {
                let tourDetails = try JSONDecoder().decode(TournamentDetail.self, from: data)
                
                DispatchQueue.main.async {
                    completion(tourDetails)
                }
                
            } catch {
                print("no json")
            }
        }
        task.resume()
    }
    
    func loadTournamentBracket(id: Int, completion: @escaping (TournamentBracket) -> Void) {
        
        var components = urlComponents
        components.path = "/api/v1/app/tournament/tourney/bracket/\(id)"
        
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
                return
            }
            do {
                let tourBracket = try JSONDecoder().decode(TournamentBracket.self, from: data)
                print(tourBracket)
                DispatchQueue.main.async {
                    completion(tourBracket)
                }
                
            } catch {
                print("no json")
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
                
                let leaders = try JSONDecoder().decode([Leader].self, from: data)
                DispatchQueue.main.async {
                    completion(leaders)
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
    
    func loadProfileInfo(completion: @escaping (User) -> Void) {
        
        var components = urlComponents
        components.path = "/api/v1/app/user"
        
        guard let url = components.url else {
            return
        }
    
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer_\(String(describing: retrievedToken))", forHTTPHeaderField: "Authorization")
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
                print("Error: HTTP request failed \(String(describing: self.retrievedToken))")
                print(urlRequest.description)
                return
            }
            do {
                let userInfo = try JSONDecoder().decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    completion(userInfo)
                }
                
            } catch {
                print("no json")
            }
        }
        task.resume()
    }
}

