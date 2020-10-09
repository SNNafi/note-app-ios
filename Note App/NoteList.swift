//
//  NoteList.swift
//  Note App
//
//  Created by Shahriar Nasim Nafi on 9/10/20.
//  Copyright © 2020 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit

class NoteList: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var priorityImage: UIImageView!
    @IBOutlet weak var editNote: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpNote(for note: Note) {
        titleLable.text = note.title
        contentLabel.text = note.content
        priorityImage.image = !note.priority ? UIImage(named: "arrow_red") : UIImage(named: "arrow_yellow")
    }
    
}
