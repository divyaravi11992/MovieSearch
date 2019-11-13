//
//  MovieSearchResultTableViewCell.swift
//  MovieSearch
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 Ravi, Divya. All rights reserved.
//

import UIKit

class MovieSearchResultTableViewCell: UITableViewCell {
        
        @IBOutlet var title: UILabel!
        @IBOutlet var overview: UILabel!
        @IBOutlet var poster: UIImageView!
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
}
