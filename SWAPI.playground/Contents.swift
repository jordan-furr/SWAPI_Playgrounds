import Foundation

struct Person: Codable {
    let name: String
    let films: [URL]
    let birth_year: String
}

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

func fetchFilm(url: URL) {
        SwapiService.fetchFilm(url: url) { film in
            if let film = film {
            print(film)
                print ("""
                ************
            """)
        }
    }
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personEndpoint = "people"
    static private let filmEndpoint = "films"
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil)}
        var personURL = baseURL.appendingPathComponent(personEndpoint)
        personURL = personURL.appendingPathComponent("\(id)")
        // 2 - Contact server
        URLSession.shared.dataTask(with: personURL) { (data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // 4 - Check for data
            guard let data = data else {return completion(nil)}
            // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
        }.resume()
    }

    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
             // 2 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // 3 - Check for data
            guard let data = data else { return completion(nil)}
            
            // 4 - Decode Film from JSON
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
        }.resume()
    }
}

SwapiService.fetchPerson(id: 11) { person in
    if let person = person {
        print(person)
        for i in person.films {
            fetchFilm(url: i)
        }
        print ("""
-----------------------------------
""")
    }
}



