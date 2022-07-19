//
//  ListViewModel.swift
//  CachingViews
//
//  Created by Connor Przybyla on 6/19/22.
//

import UIKit

protocol ListViewModelable {
    func getImage(completion: ((UIImage?) -> Void)?)
}

class ListViewModel: ListViewModelable {
    
    private var cachedImage: UIImage?
    private var isPrefetching = false
    private var callback: ((UIImage?) -> Void)?
    
    func getImage(completion: ((UIImage?) -> Void)?) {
        defer {
            self.callback = nil
        }
        
        if let image = cachedImage {
            completion?(image)
            return
        }
        
        guard !isPrefetching else {
            self.callback = completion
            return
        }
        
        isPrefetching = true
        
        guard let url = URL(string: "https://picsum.photos/200") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            
            let image = UIImage(data: data)
            self?.cachedImage = image
            self?.callback?(image)
            completion?(image)
        }
        
        task.resume()
    }
}
