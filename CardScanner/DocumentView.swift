//
//  DocumentView.swift
//  CardScanner
//
//  Created by Luke Van In on 2017/02/28.
//  Copyright © 2017 Luke Van In. All rights reserved.
//

import UIKit

class DocumentView: UIView {
    
    var image: UIImage? {
        didSet {
            documentImageView.image = image
        }
    }
    
    var document: Document? {
        didSet {
            invalidateAnnotations()
        }
    }
    
    private var annotationsRenderer: AnnotationsRenderer?
    
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var annotationsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = documentImageView.layer
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 0.25
//        layer.shadowRadius = 4
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    func invalidateAnnotations() {
        annotationsRenderer = nil
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        guard let imageSize = image?.size else {
            documentImageView.image = nil
            annotationsImageView.image = nil
            return
        }
        
        let scale = calculateScale(
            from: imageSize,
            to: bounds.size
        )
        
        let actualSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
        
//        annotationsImageView.image = renderAnnotations(size: actualSize)
        
        let origin = CGPoint(
            x: round((bounds.size.width - actualSize.width) * 0.5),
            y: round((bounds.size.height - actualSize.height) * 0.5)
        )
        let frame = CGRect(origin: origin, size: actualSize)
        documentImageView.frame = frame
        annotationsImageView.frame = frame
        
        let layer = documentImageView.layer
        layer.shadowPath = UIBezierPath(rect: documentImageView.bounds).cgPath
    }
    
    private func calculateScale(from sourceSize: CGSize, to targetSize: CGSize) -> CGFloat {
        
        let sourceAspect = sourceSize.width / sourceSize.height
        let targetAspect = targetSize.width / targetSize.height
        let scale: CGFloat
        
        if sourceAspect > targetAspect {
            // Image is wider aspect than available area.
            // Scale to width.
            scale = targetSize.width / sourceSize.width
        }
        else {
            // Image is narrower aspect than available area.
            // Scale to height.
            scale = targetSize.height / sourceSize.height
        }
        
        return scale
    }

//    private func renderAnnotations(size: CGSize) -> UIImage? {
//        
//        guard let document = self.document else {
//            return nil
//        }
//        
//        if annotationsRenderer == nil {
//            annotationsRenderer = TextAnnotationsRenderer(document: document)
//        }
//        
//        return annotationsRenderer?.render(size: size)
//    }
}
