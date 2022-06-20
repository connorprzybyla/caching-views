//
//  TableViewCell.swift
//  CachingViews
//
//  Created by Connor Przybyla on 6/19/22.
//

import UIKit

protocol UITableViewCellConfigurable {
    func configure(with viewModel: ListViewModelable)
}

class TableViewCell: UITableViewCell, UITableViewCellConfigurable {
    
    private let image = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(image)
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    private func setupAutoLayout() {
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 350),
            image.heightAnchor.constraint(equalToConstant: 350),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(with viewModel: ListViewModelable) {
        viewModel.getImage { [weak self] image in
            DispatchQueue.main.async {
                self?.image.image = image
            }
        }
    }
}
