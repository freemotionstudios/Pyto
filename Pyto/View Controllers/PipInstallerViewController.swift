//
//  PipInstallerViewController.swift
//  Pyto
//
//  Created by Adrian Labbé on 3/20/19.
//  Copyright © 2019 Adrian Labbé. All rights reserved.
//

import UIKit

/// A View controller for running `pip` commands.
@objc class PipInstallerViewController: EditorSplitViewController {
    
    @objc private func closeViewController() {
        return dismiss(animated: true, completion: {
            (((UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.viewControllers?[2] as? UINavigationController)?.visibleViewController as? PipViewController)?.webView.reload()
        })
    }
    
    private var command = ""
    
    /// Initializes for running given `pip` command.
    ///
    /// - Parameters:
    ///     - command: The command to run. Without the program name. For example, `install bottle` for running `pip install bottle`.
    init(command: String) {
        super.init(nibName: nil, bundle: nil)
        self.command = command
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// The last visible instance.
    static var shared: PipInstallerViewController?
    
    // MARK: - Editor split view controller
    
    override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: "C", modifierFlags: .control, action: #selector(interrupt), discoverabilityTitle: Localizable.interrupt)]
    }
    
    override func loadView() {
        super.loadView()
        
        if let repl = Bundle.main.url(forResource: "installer", withExtension: "py") {
            editor = EditorViewController(document: repl)
            editor.args = command
        }
        console = ConsoleViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(console)
        view.addSubview(console.view)
        console.view.frame = view.frame
        console.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PipInstallerViewController.shared = self
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeViewController))]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Python.shared.isScriptRunning {
            editor.stop()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.editor.run()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.editor.run()
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {}
}

