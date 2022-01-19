//
//  CustomTableViewCell.swift
//  Google News
//
//  Created by Ergün Yunus Cengiz on 8.01.2022.
//

import UIKit


class CustomCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "CustomCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let imageViewOfNews: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bottomFixedLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imageViewOfNews)
        contentView.addSubview(bottomFixedLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageViewOfNews.frame = CGRect(x: 0,
                                       y: 0,
                                       width: contentView.frame.size.width,
                                       height: 200)
        
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 210,
                                  width: contentView.frame.size.width - 20,
                                  height: 60
        )
        
        subtitleLabel.frame = CGRect(x: 10,
                                  y: 280,
                                  width: contentView.frame.size.width - 20,
                                  height: 60
        )
        
        bottomFixedLabel.frame = CGRect(x: contentView.frame.size.width - 120, y: 350, width: 120, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        imageViewOfNews.image = nil
        bottomFixedLabel.text = nil
    }
    
    public func configure(with model: NewsModel) {
        var model = model
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        bottomFixedLabel.text = "Google News"
        if let data = model.imageData {
            imageViewOfNews.image = UIImage(data: data)
        }else if let url = model.imageUrl {
            URLSession.shared.dataTask(with: url) {data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                model.imageData = data
                DispatchQueue.main.async {
                    self.imageViewOfNews.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
