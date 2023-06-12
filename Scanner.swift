import UIKit
import VisionKit

class Scanner: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func touchUpInsideCameraButton( Sender:Any){
        configureDocumentView()
    }

    private func configureDocumentView() {
   //     guard VNDocumentCameraViewController.isSupported else { return } // silinebilir yaratılan metodun controllera uyumununu kontrol eder

        let controller = VNDocumentCameraViewController()
        controller.delegate = self
        self.present(controller, animated: true)
    }
}

extension Scanner: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController( controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {

    for index in 0 ..< scan.pageCount {
        let image = scan.imageOfPage(at: index)

        print(image)
      // save image
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
}
        controller.dismiss(animated: true, completion: nil)
    }
}
 
