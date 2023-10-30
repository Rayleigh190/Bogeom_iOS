//
//  CaptureViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/19.
//

import UIKit
import AVFoundation
import Vision
import Photos
import CoreLocation

class CaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var isCaptured: Bool = false
    var hasPerformedSegue = false
    var image: UIImage? // 카메라로 촬영한 이미지
    var croppedImage: UIImage? // 객체 탐지로 자른 이미지
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest // 높은 위치 정확도
        manager.delegate = self
        
        return manager
     }()
    
    var userLat: Double?
    var userLon: Double?
    
    var objectBounds: CGRect!
//    var outputImage : UIImage!
    
    // Capture
    var bufferSize: CGSize = .zero
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    
    // UI and Layers
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var blurBGView: UIVisualEffectView!
    var rootLayer: CALayer! = nil
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private var detectionLayer: CALayer! = nil
    
    // Vision
    private var requests = [VNRequest]()
    
    var count:Int = 0 // 카메라 화면에 들어온 회수를 카운트
    
    // Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        count += 1
        setupCapture()
        setupOutput()
        setupLayers()
        setupUI()
        try? setupVision()
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        count += 1
        if count > 2 { // nav bar back을 통해 뒤로 이동해도 카메라 세션이 다시 시작 되게 함
            setupLayers()
            setupUI()
            try? setupVision()
            DispatchQueue.global(qos: .background).async {
                        self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop location tracking when leaving the view controller
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        hasPerformedSegue = false
    }
    deinit {
        // Ensure that the locationManager is deallocated properly
        locationManager.delegate = nil
    }
    
    func setupUI() {
        captureButton.layer.cornerRadius = captureButton.bounds.height/2
        captureButton.layer.masksToBounds = true
        blurBGView.layer.cornerRadius = blurBGView.bounds.height/2
        blurBGView.layer.masksToBounds = true
        let chevronLeft = UIImage(systemName: "chevron.left")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: chevronLeft, style: .plain, target: self, action: #selector(CaptureViewController.tapToBack))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func tapToBack() {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        // TODO: photoOutput의 capturePhoto 메소드
        // orientation
        // photooutput
        
        let videoPreviewLayerOrientation = self.previewLayer.connection?.videoOrientation
        DispatchQueue.global(qos: .background).async {
            let connection = self.photoOutput.connection(with: .video)
            connection?.videoOrientation = videoPreviewLayerOrientation!
            let setting = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: setting, delegate: self)
        }
    }
    
    func savePhotoLibrary(image: UIImage) {
        // TODO: capture한 이미지 포토라이브러리에 저장
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (_, error) in
//                    DispatchQueue.main.async {
//                        self.photoLibraryButton.setImage(image, for: .normal)
//                    }
                    print(image.size)
                })
            } else {
                print(" error to save photo library")
            }
        }
    }
    
    func setupCapture() {
        var deviceInput: AVCaptureDeviceInput!
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high //.photo //.vga640x480

        guard captureSession.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(deviceInput)

        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        // Add photo output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }

        captureSession.commitConfiguration()
    }
    
    func setupOutput() {
        let videoDataOutput = AVCaptureVideoDataOutput()
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            captureSession.commitConfiguration()
            return
        }
    }
    
    func setupLayers() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        rootLayer = previewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        
        detectionLayer = CALayer()
        detectionLayer.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionLayer.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionLayer)
        
        let xScale: CGFloat = rootLayer.bounds.size.width / bufferSize.height
        let yScale: CGFloat = rootLayer.bounds.size.height / bufferSize.width
        
        let scale = fmax(xScale, yScale)
    
        // rotate the layer into screen orientation and scale and mirror
        detectionLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        // center the layer
        detectionLayer.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
    }
    
    func setupVision() throws {
        guard let modelURL = Bundle.main.url(forResource: "yolov5s", withExtension: "mlmodelc") else {
            throw NSError(domain: "ViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    if let results = request.results {
                        let maxSizeObjectObservation = self.getBigResult(results)
                        self.drawResults(maxSizeObjectObservation)
                        
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        do {
            // returns true when complete https://developer.apple.com/documentation/vision/vnimagerequesthandler/2880297-perform
//            let start = CACurrentMediaTime()
            try imageRequestHandler.perform(self.requests)
//            inferenceTime = (CACurrentMediaTime() - start)

        } catch {
            print(error)
        }
    }
    
    func getBigResult(_ results: [Any]) -> VNRecognizedObjectObservation {
        var boxSizeList = [VNRecognizedObjectObservation:Double]()
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            let boxSize:Double = objectObservation.boundingBox.size.height*objectObservation.boundingBox.size.width
            boxSizeList.updateValue(boxSize, forKey: objectObservation)
        }
        let maxBox = boxSizeList.max(by: {$0.value < $1.value}) ?? nil
        guard let maxSizeObjectObservation = maxBox?.key else {
            let temp = VNRecognizedObjectObservation()
            return temp
        }
        return maxSizeObjectObservation
    }
    
    func drawResults(_ result: VNRecognizedObjectObservation) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionLayer.sublayers = nil // Clear previous detections from detectionLayer
//        inferenceTimeLayer.sublayers = nil
        
        let objectObservation = result
        // Detection with highest confidence
//        print(objectObservation.labels.count)
        if !isCaptured {
            if objectObservation.labels.count > 0 {
                let topLabelObservation = objectObservation.labels[0]
                
                // Rotate the bounding box into screen orientation
                let boundingBox = CGRect(origin: CGPoint(x:(1-objectObservation.boundingBox.origin.y-objectObservation.boundingBox.size.height)*0.9, y:objectObservation.boundingBox.origin.x*0.65), size: CGSize(width:objectObservation.boundingBox.size.height*1.5,height:objectObservation.boundingBox.size.width*1.5))
            
                objectBounds = VNImageRectForNormalizedRect(boundingBox, Int(bufferSize.width ), Int(bufferSize.height))
                
                let shapeLayer = createRectLayer(objectBounds, colors[topLabelObservation.identifier]!)
                
    //            let formattedString = NSMutableAttributedString(string: String(format: "\(topLabelObservation.identifier)\n %.1f%% ", topLabelObservation.confidence*100).capitalized)
    //
    //            let textLayer = createDetectionTextLayer(objectBounds, formattedString)
    //            shapeLayer.addSublayer(textLayer)
                detectionLayer.addSublayer(shapeLayer)
            }
        }
        
//        print("아아아")
        // Crop the captured image based on the detection results
        if let cgImage = image?.cgImage,
           let croppedCGImage = cgImage.cropping(to: objectBounds) {
            let croppedImage = UIImage(cgImage: croppedCGImage)
//            print("구구구")
            // Perform the segue with the cropped image as sender
            if isCaptured && !hasPerformedSegue {
//                print("타타타")
                hasPerformedSegue = true
                performSegue(withIdentifier: "showSearch", sender: croppedImage)
                isCaptured = false
            }
        }
        
        CATransaction.commit()
        
    }
        
    // Clean up capture setup
//    func teardownAVCapture() {
//        previewLayer.removeFromSuperlayer()
//        previewLayer = nil
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearch" {
            let vc = segue.destination as? SearchViewController
            if let priceImg = sender as? UIImage {
                vc?.cropImage = priceImg
                vc?.userLat = userLat
                vc?.userLon = userLon
            }
        }
    }

}


extension CaptureViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // TODO: capturePhoto delegate method 구현
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        image = UIImage(data: imageData)
//        guard let cgImageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {print("실패"); return}
//        guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil) else {return}
        
        // Perform object detection on the captured image
        performObjectDetection(image!)
        isCaptured = true
//        self.savePhotoLibrary(image: image!)
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func performObjectDetection(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try requestHandler.perform(requests)
        } catch {
            print(error)
        }
    }
}

extension CaptureViewController: CLLocationManagerDelegate {
    
    func getLocationUsagePermission() {
        //location4
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //location5
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude
        
        userLat = Double(latitude)
        userLon = Double(longtitude)
    }
}
