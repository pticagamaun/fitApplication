//
//  UserModel.swift
//  Fitness-App-1.0
//
//  Created by Vadim on 24.11.2022.
//

import RealmSwift

class UserModel: Object {
    
    @Persisted var userFirstName: String = "Unknonwed"
    @Persisted var userSecondName: String = "Unknonwed"
    @Persisted var userHeight: Int = 0
    @Persisted var userWeight: Int = 0
    @Persisted var userTarget: Int = 0
    @Persisted var userPhoto: Data?
}
