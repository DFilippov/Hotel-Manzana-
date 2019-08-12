//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Ayu Filippova on 10/08/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType?
    var wifi: Bool
}


