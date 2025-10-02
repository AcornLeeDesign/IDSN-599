//
//  blah.swift
//  Touch and Gestures
//
//  Created by Aaron Lee on 10/2/25.
//

import SwiftUI

class UserData: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
}
