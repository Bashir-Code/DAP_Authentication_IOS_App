//
//  ViewController.swift
//  DAP_MacLogger
//
//  Created by Bashir Mohammad Abdul on 2025/05/13.


// In your macOS app, ViewController.swift
import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up a simple server to listen for data (this can be a simple HTTP server)
        startServer()
    }
    
    func startServer() {
        // Example of how you could start a server (this is very basic, not a production solution)
        let url = URL(string: "http://localhost:8080/data")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Handle the incoming data here
                print(String(data: data, encoding: .utf8) ?? "No data")
            }
        }
        task.resume()
    }
}


