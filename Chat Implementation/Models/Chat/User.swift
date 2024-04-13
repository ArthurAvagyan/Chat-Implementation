//
//  User.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import Foundation

final class User: Codable {
	
	public var id: Int
	public var name: String
	public var avatarUrl: URL?
}
