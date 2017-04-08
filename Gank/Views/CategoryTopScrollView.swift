import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CategoryTopScrollView: UIControl {
    
    fileprivate typealias Item = UILabel
    
    var datas: [String] = ["所有", "iOS", "前端", "Android", "拓展资源", "福利", "休息视频", "瞎推荐"]
    private(set) var eachWidth = [CGFloat]()
    fileprivate var labels = [UILabel]()
    private var locations = [CGFloat]()
    fileprivate var lastSelectedIndex: Int = 0
    
    public var valueChanged: ((Int) -> Void)?
    public var value: Int = 0
    
    fileprivate weak var scrollView: UIScrollView?
    
    private var selectedLabel: UILabel!
    
    private var scrollViewContentWidth: CGFloat = 0.0
    fileprivate var lastContentOffsetX: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerTapGesture(gesture:)))
        let scrollView = UIScrollView()
            .then({
                $0.alwaysBounceHorizontal = false
                $0.alwaysBounceVertical = false
                $0.bounces = true
                $0.contentInset = UIEdgeInsets.zero
                $0.showsVerticalScrollIndicator = false
                $0.showsHorizontalScrollIndicator = false
                $0.addGestureRecognizer(tap)
            })
        
        self.scrollView = scrollView
        addSubview(scrollView)
        
        datas.forEach({ [weak self] element in
            let font = UIFont.boldSystemFont(ofSize: 22)
            let width = element.boundsWidth(font: font, height: 30.0)
            self?.eachWidth.append(width + 30)
            self?.scrollViewContentWidth += (width + 30)
            
            let label = UILabel().then({
                $0.text = element
                $0.font = UIFont.boldSystemFont(ofSize: 22)
                $0.textColor = UIColor.gray.lighter()
                $0.textAlignment = .center
            })
            self?.labels.append(label)
            self?.scrollView?.addSubview(label)
        })
        
        self.backgroundColor = UIColor.white
        makeContraints()
        
        selectedLabel = labels[0]
        sendActions(for: .touchUpInside)

        var currentWidth: CGFloat = 0.0
        for i in 0 ... eachWidth.count {
            if i > 0 {
                locations.append(currentWidth + eachWidth[i - 1])
                currentWidth += eachWidth[i - 1]
            }
            else if i == 0 {
                locations.append(0)
            }
        }
        
        setSelected(0, animated: true)
        labels[0].textColor = UIColor.darkGray
    }
    
    @objc fileprivate func handlerTapGesture(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: scrollView)
        for i in 0 ..< (locations.count - 1) {
            if location.x >= locations[i] && location.x <= locations[i + 1] {
                self.setSelected(i, animated: true)
                break
            }
        }
    }
    
    func makeContraints() {
        scrollView?.snp.makeConstraints({ [weak self] in
            guard let strongSelf = self else { return }
            $0.edges.equalTo(strongSelf.snp.edges)
                .inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        })
        
        for (index, label) in labels.enumerated() {
            let currentWidth = eachWidth[index]
            if index == 0 {
                label.snp.makeConstraints({ [weak self] in
                    guard let strongSelf = self else { return }
                    $0.left.equalTo(strongSelf.scrollView!.snp.left)
                    $0.top.equalTo(strongSelf.scrollView!.snp.top)
                    $0.bottom.equalTo(strongSelf.scrollView!.snp.bottom)
                    $0.width.equalTo(currentWidth)
                })
            }
            else if index == (labels.count - 1) {
                let lastLabel = labels[index - 1]
                label.snp.makeConstraints({ [weak self] in
                    guard let strongSelf = self else { return }
                    $0.left.equalTo(lastLabel.snp.right)
                    $0.top.equalTo(lastLabel.snp.top)
                    $0.bottom.equalTo(lastLabel.snp.bottom)
                    $0.width.equalTo(currentWidth)
                    $0.right.equalTo(strongSelf.scrollView!.snp.right)
                })
            }
            else {
                let lastLabel = labels[index - 1]
                label.snp.makeConstraints({
                    $0.left.equalTo(lastLabel.snp.right)
                    $0.top.equalTo(lastLabel.snp.top)
                    $0.bottom.equalTo(lastLabel.snp.bottom)
                    $0.width.equalTo(currentWidth)
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryTopScrollView {
    func setSelected(_ index: Int, animated: Bool = true) {
        guard lastSelectedIndex != index,
            let scrollView = self.scrollView else {
                return
        }
        
        let lastLabel = labels[lastSelectedIndex]
        lastLabel.textColor = UIColor.lightGray.lighter()
        let label = labels[index]
        label.textColor = UIColor.darkGray
        lastSelectedIndex = index
        
        let centerX = label.frame.origin.x + label.frame.size.width * 0.5
        let currentSizeWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.frame.width
        
        var contentOffset = CGPoint.zero
        if centerX > scrollView.frame.size.width * 0.5
            && (currentSizeWidth - centerX) > scrollViewWidth * 0.5 {
            contentOffset = CGPoint(x: centerX - scrollViewWidth * 0.5, y: 0)
        }
        else if (currentSizeWidth - centerX) < scrollViewWidth * 0.5 {
            contentOffset = CGPoint(x: currentSizeWidth - scrollViewWidth, y: 0)
        }
        scrollView.setContentOffset(contentOffset, animated: true)
        
        value = index
        valueChanged?(index)
        sendActions(for: .valueChanged)
    }
}
