import UIKit

class StoryImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
        layer.masksToBounds = false
        clipsToBounds = true
    }
}
