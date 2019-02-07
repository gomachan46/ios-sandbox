//
// Created by USER on 2019-02-07.
// Copyright (c) 2019 gomachan46. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    private var current: UIViewController

    init () {
        current = TabBarController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}
