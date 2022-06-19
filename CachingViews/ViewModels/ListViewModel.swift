//
//  ListViewModel.swift
//  CachingViews
//
//  Created by Connor Przybyla on 6/19/22.
//

import Foundation

protocol ViewModel {
    var names: [String] { get set }
    var filteredNames: [String] { get set }
}

class ListViewModel: ViewModel {
    var names: [String]
    var filteredNames: [String]
    
    init(names: [String]) {
        self.names = names
        self.filteredNames = names
    }
}
