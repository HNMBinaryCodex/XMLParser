//
//  ViewController.swift
//  XMLParser
//
//  Created by Waveline Media on 12/3/19.
//  Copyright © 2019 DevFest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var jokeLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var xmlDict: [String: Any] = [:]
    var currentElementValue = ""
    var currentElement = ""
    var hasInitialised = false
    var parser: XMLParser!
    var displayJoke: JokeModel!
    
    @IBAction func parseXml(_ sender: UIButton) {
        fetchAJoke(category: "Programming")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func fetchAJoke(category: String) {
        
        loader.startAnimating()
        loader.isHidden = false
        jokeLbl.text = "Joke Processing..."
        
        let endPoint = "https://jokeapi.p.rapidapi.com/category/\(category)?format=xml"
        
        let headers = [
            "x-rapidapi-host": "jokeapi.p.rapidapi.com",
            "x-rapidapi-key": "ce3a2dcffdmsh4bec54f42db20c3p1228d0jsn69caa6958465"
        ]
        
        print(endPoint)
        
        guard let url = URL(string: endPoint) else {
            print("Error in creating url")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) {(data, responseURL, error) in
            if error != nil {
                print("ERROR PARSING DATA")
                return
            }
            if let responseData = data {
                self.parser = XMLParser(data: responseData)
                self.parser.delegate = self
                self.parser.parse()
            }
        }.resume()
    }
    
    func parsingCompleted() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            if !self.xmlDict.isEmpty {
                let myJoke = JokeModel(details: self.xmlDict)
                self.displayJoke = myJoke
                self.configure()
            }
        }
    }
    
    func configure() {
        if displayJoke.type == "single" {
            jokeLbl.text = displayJoke.singleJoke
        } else {
            jokeLbl.text = "\(displayJoke.setup ?? "") \n\n\(displayJoke.delivery ?? "")"
        }
    }
}

extension ViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let stringValue = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !stringValue.isEmpty, !currentElement.isEmpty {
            xmlDict[currentElement] = stringValue
            currentElement = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !elementName.isEmpty {
            currentElement = elementName
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("document ended")
        parsingCompleted()
    }
}
