//
//  SecondViewController.swift
//  Animations
//
//  Created by Pyramidions on 11/02/21.
//

import UIKit
class SecondCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 10
    }
    
    func configure(with cellData: CellData)
    {
        imageView.image = cellData.image
    }
}

class SecondViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private(set) var locationImageView: UIImageView!
    @IBOutlet private(set) var locationLabel: UILabel!
    @IBOutlet private(set) var closeButton: UIButton!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var downloadbutton : UIButton!
    @IBOutlet weak var loadingImage: UIImageView!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    
    
    var data: CellData!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainStack.layer.cornerRadius = 25
        playButton.layer.cornerRadius = 25
        downloadbutton.layer.cornerRadius = 25
        locationImageView.layer.cornerRadius = 20
        let cross = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        closeButton.setImage(cross, for: .normal)
        closeButton.tintColor = .black
        locationImageView.image = data.image
        locationLabel.text = data.title
        loadingImage.isHidden = false
    }

    
    @IBAction func download(sender:UIButton)
    {
        downloadbutton.isHidden = true
        playButton.isHidden = true
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "play", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView2 = UIImageView(image: advTimeGif)
        imageView2.frame = CGRect(x: 0 ,y: 0, width: self.loadingImage.frame.size.width, height:  self.loadingImage.frame.size.height)
        self.loadingImage.addSubview(imageView2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5)
        {
            self.loadingImage.isHidden = true
            self.downloadbutton.isHidden = true
            self.playButton.isHidden = false
        }
    }
    
    
    @IBAction func playAtn(_ sender: Any)
    {
        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let newVC = StoryBoard.instantiateViewController(withIdentifier: "ThirdViewController")as! ThirdViewController
        self.present(newVC, animated: true, completion: nil)
    }
    @IBAction func close(_ sender: Any)
    {
        dismiss(animated: true)
    }
    
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
        cell.configure(with: DataManager.data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension SecondViewController
{
    enum Constant
    {
        static let cellSpacing: CGFloat = 10
    }
}
extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}

