import UIKit
import Flutter

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showFlutter()
    }

    func showFlutter() {
        let flutterEngine = FlutterEngine(name: "my flutter engine")
        flutterEngine.run()
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.extensionContext?.cancelRequest(
            withError: NSError(domain: Bundle.main.bundleIdentifier!, code: 0))
    }
}
