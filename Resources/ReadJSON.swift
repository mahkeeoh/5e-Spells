//
//  JSON Decoder.swift
//  DM Encounters
//
//  Created by Mikael Olezeski on 1/30/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func readJson(with title: String) -> [Any]?
    {
        do
        {
            if let file = Bundle.main.url(forResource: title, withExtension: "json")
            {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                do
                {
                    let spells = try decoder.decode([FailableDecodable<Spell>].self, from: data).flatMap { $0.base }
                
                    return spells
                } catch
                {
                    print("Error decoding")
                }
                
            }
        }
        catch
        {
            print("Error loading JSON")
        }
        
        print("Error finding JSON file")
        return nil
    }
    
    struct FailableDecodable<Base : Decodable> : Decodable
    {
        
        let base: Base?
        
        init(from decoder: Decoder) throws
        {
            let container = try decoder.singleValueContainer()
            self.base = try? container.decode(Base.self)
        }
    }
}

