//
//  Constants.swift
//  ConceptubeTest
//
//  Created by blue on 15/12/2021.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseAuth = databaseRoot.child("auth")
    }
}
