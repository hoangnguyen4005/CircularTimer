//
//  CircularTimerView.swift
//  CircularTimerView
//
//  Created by Chi Hoang on 30/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit

public protocol CircularTimerViewDelegate: class {
    func didComplete(_ timerView: CircularTimerView)
}

public class CircularTimerView: UIView {
    @IBOutlet weak var contentView: UIView!

    //PUBLIC
    public var lineWidth: CGFloat = 4.0
    public var trackStrokeColor: UIColor = #colorLiteral(red: 0, green: 0.3607843137, blue: 0.5176470588, alpha: 1)
    public var progressStrokeColor: UIColor = UIColor(red: 230.0/255.0,
                                                      green: 231.0/255.0,
                                                      blue: 232.0/255.0,
                                                      alpha: 1.0)
    public var duration: Double = 0.0
    public weak var delegate: CircularTimerViewDelegate?
    public var contentColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set(value) {
            self.contentView.backgroundColor = value
        }
    }

    //PRIVATE
    private var count: Double = 0.0 {
        didSet {
            if count >= 0 {
                let string = String(count) + " s"
                self.percentageLabel.text = string
                self.percentageLabel.textColor = count == 0 ? #colorLiteral(red: 0.937254902, green: 0.2509803922, blue: 0.2117647059, alpha: 1)  : #colorLiteral(red: 0, green: 0.3607843137, blue: 0.5176470588, alpha: 1)
            }
        }
    }
    private var timer: Timer?
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()

    //METHOD
    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    /// :nodoc:
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /// :nodoc:
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.clear
        _ = fromNib(nibName: String(describing: CircularTimerView.self), isInherited: true)
        self.percentageLabel.font = UIFont.systemFont(ofSize: 16)
        self.percentageLabel.textColor = #colorLiteral(red: 0, green: 0.3607843137, blue: 0.5176470588, alpha: 1)
    }

    @objc func updateTime() {
        count -= 1
        if count == 0 {
            self.delegate?.didComplete(self)
            timer?.invalidate()
        }
    }

    public func setupCircularTimer() {
        self.contentView.layoutIfNeeded()
        self.trackLayer.removeFromSuperlayer()
        self.progressLayer.removeFromSuperlayer()

        let center = contentView.center
        self.contentView.addSubview(percentageLabel)
        percentageLabel.anchor(top: self.contentView.topAnchor,
                               leading: self.contentView.leadingAnchor,
                               bottom: self.contentView.bottomAnchor,
                               trailing: self.contentView.trailingAnchor,
                               padding: .zero,
                               size: .zero)
        percentageLabel.center = center

        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: contentView.frame.width/2.0,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3*CGFloat.pi/2,
                                        clockwise: true)

        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = trackStrokeColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        contentView.layer.addSublayer(trackLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = progressStrokeColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        contentView.layer.addSublayer(progressLayer)
    }

    public func startCountDownTime() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        self.count = duration
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(integerLiteral: duration)

        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "urSoBasic")
    }
}
