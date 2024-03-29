//
//  Utils.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/20.
//

import UIKit
import Vision

let classes = [
    "person",
    "bicycle",
    "car",
    "motorcycle",
    "airplane",
    "bus",
    "train",
    "truck",
    "boat",
    "traffic light",
    "fire hydrant",
    "stop sign",
    "parking meter",
    "bench",
    "bird",
    "cat",
    "dog",
    "horse",
    "sheep",
    "cow",
    "elephant",
    "bear",
    "zebra",
    "giraffe",
    "backpack",
    "umbrella",
    "handbag",
    "tie",
    "suitcase",
    "frisbee",
    "skis",
    "snowboard",
    "sports ball",
    "kite",
    "baseball bat",
    "baseball glove",
    "skateboard",
    "surfboard",
    "tennis racket",
    "bottle",
    "wine glass",
    "cup",
    "fork",
    "knife",
    "spoon",
    "bowl",
    "banana",
    "apple",
    "sandwich",
    "orange",
    "broccoli",
    "carrot",
    "hot dog",
    "pizza",
    "donut",
    "cake",
    "chair",
    "couch",
    "potted plant",
    "bed",
    "dining table",
    "toilet",
    "tv",
    "laptop",
    "mouse",
    "remote",
    "keyboard",
    "cell phone",
    "microwave",
    "oven",
    "toaster",
    "sink",
    "refrigerator",
    "book",
    "clock",
    "vase",
    "scissors",
    "teddy bear",
    "hair drier",
    "toothbrush",
    "price tag"
];

let colors = classes.reduce(into: [String: [CGFloat]]()) {
    $0[$1] = [Double.random(in: 0.0 ..< 1.0),Double.random(in: 0.0 ..< 1.0),Double.random(in: 0.0 ..< 1.0),0.5]
}


func createDetectionTextLayer(_ bounds: CGRect, _ text: NSMutableAttributedString) -> CATextLayer {
    let textLayer = CATextLayer()
    textLayer.string = text
    textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
    textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    textLayer.contentsScale = 10.0
    textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
    return textLayer
}

func createInferenceTimeTextLayer(_ bounds: CGRect, _ text: NSMutableAttributedString) -> CATextLayer {
    let inferenceTimeTextLayer = CATextLayer()
    inferenceTimeTextLayer.string = text
    inferenceTimeTextLayer.frame = bounds
    inferenceTimeTextLayer.contentsScale = 10.0
    inferenceTimeTextLayer.alignmentMode = .center
    return inferenceTimeTextLayer
}

func createRectLayer(_ bounds: CGRect, _ color: [CGFloat]) -> CALayer {
    let shapeLayer = CALayer()
    shapeLayer.bounds = bounds
    shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    shapeLayer.backgroundColor = UIColor(hue: 0.125, saturation: 0.83, brightness: 0.94, alpha: 0.5).cgColor
    //CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: color)
    return shapeLayer
}



class Utils {

    /**
     # openExternalLink
     - Parameters:
     - urlStr : String 타입 링크
     - handler : Completion Handler
     - Note: 외부 브라우저로 링크 오픈
     */
    static func openExternalLink(urlStr: String, _ handler:(() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                handler?()
            }
            
        } else {
            UIApplication.shared.openURL(url)
            handler?()
        }
    }
}
