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
    
    var xmlDictArr: [[String: Any]]!
    var xmlDict: [String: Any] = [:]
    var currentElementValue = ""
    var currentElement = ""
    var hasInitialised = false
    var parser: XMLParser!
    
    @IBAction func parseXml(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func fetchAJoke(category: String) {
        
        let endPoint = "https://jokeapi.p.rapidapi.com/category/\(category)?format=xml"
        
        print(endPoint)
        
        guard let url = URL(string: endPoint) else {
            print("Error in creating url")
            return
        }
        
        let urlRequest = URLRequest(url: url)
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
                if let result = self.xmlDictArr {
                    let myJoke = result.map { return JokeModel(details: $0) }
                }
            }
        }
}

extension ViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "" {
            xmlDictArr = []
        } else if elementName == "" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, currentElement != "" {
           xmlDict.updateValue(string, forKey: currentElement)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "" {
            xmlDictArr.append(xmlDict)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("document ended")
        parsingCompleted()
    }
}
