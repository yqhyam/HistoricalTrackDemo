//
//  ATrackVC.swift
//  HistoricalTrackDemo
//
//  Created by YaM on 2019/4/19.
//  Copyright © 2019 yam. All rights reserved.
//

import UIKit
import MAMapKit

class AMapTrackVC: UIViewController {

    var mapView: MAMapView!
    // 路线
    var t_coors: [CLLocationCoordinate2D]!
    // 动画标注
    var myLocation: MAAnimatedAnnotation!
    // 是否在播放
    var isPlaying = false
    // 播放按钮
    var playItem: UIBarButtonItem!
    //当前位置
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addOverlay()
        addAnnotation()
    }
    
    func setupViews() {
        
        // navs
        playItem = UIBarButtonItem(title: "播放", style: .plain, target: self, action: #selector(playAndPause))
        navigationItem.rightBarButtonItem = playItem

        
        // maps
        t_coors = [CLLocationCoordinate2D(latitude: 30.468233235678, longitude: 114.18888671875), CLLocationCoordinate2D(latitude: 30.464500325521, longitude: 114.188798556858), CLLocationCoordinate2D(latitude: 30.459150119358, longitude: 114.188088107639), CLLocationCoordinate2D(latitude: 30.452785101997, longitude: 114.186635742188), CLLocationCoordinate2D(latitude: 30.44966905382, longitude: 114.185159776476), CLLocationCoordinate2D(latitude: 30.447038302952, longitude: 114.183133138021), CLLocationCoordinate2D(latitude: 30.444810384115, longitude: 114.180692274306), CLLocationCoordinate2D(latitude: 30.439356011285, longitude: 114.172794596355), CLLocationCoordinate2D(latitude: 30.435231662327, longitude: 114.168071831598), CLLocationCoordinate2D(latitude: 30.429788682726, longitude: 114.163723687066), CLLocationCoordinate2D(latitude: 30.423109266494, longitude: 114.160228949653), CLLocationCoordinate2D(latitude: 30.418595920139, longitude: 114.158114420573), CLLocationCoordinate2D(latitude: 30.418362087674, longitude: 114.157883300782), CLLocationCoordinate2D(latitude: 30.418212619358, longitude: 114.157603624132), CLLocationCoordinate2D(latitude: 30.418129340278, longitude: 114.15730061849), CLLocationCoordinate2D(latitude: 30.417980414497, longitude: 114.156606445313), CLLocationCoordinate2D(latitude: 30.417832573785, longitude: 114.156375325521), CLLocationCoordinate2D(latitude: 30.41764702691, longitude: 114.156175672744), CLLocationCoordinate2D(latitude: 30.417397189671, longitude: 114.156064181858), CLLocationCoordinate2D(latitude: 30.416565483941, longitude: 114.155768500435), CLLocationCoordinate2D(latitude: 30.416499294705, longitude: 114.155768500435), CLLocationCoordinate2D(latitude: 30.416433376737, longitude: 114.155808648004), CLLocationCoordinate2D(latitude: 30.416381022136, longitude: 114.155880262587), CLLocationCoordinate2D(latitude: 30.416264919705, longitude: 114.156087782119), CLLocationCoordinate2D(latitude: 30.41464029948, longitude: 114.160810546875), CLLocationCoordinate2D(latitude: 30.414220377605, longitude: 114.161791720921), CLLocationCoordinate2D(latitude: 30.413837619358, longitude: 114.162294379341), CLLocationCoordinate2D(latitude: 30.413553059896, longitude: 114.162573513455), CLLocationCoordinate2D(latitude: 30.41305202908, longitude: 114.162852918837), CLLocationCoordinate2D(latitude: 30.412351616754, longitude: 114.163091905382), CLLocationCoordinate2D(latitude: 30.412001681858, longitude: 114.163091905382), CLLocationCoordinate2D(latitude: 30.411319715712, longitude: 114.162956271702), CLLocationCoordinate2D(latitude: 30.410833875869, longitude: 114.162724880643), CLLocationCoordinate2D(latitude: 30.406075846355, longitude: 114.159353027344), CLLocationCoordinate2D(latitude: 30.401149088542, longitude: 114.155698784723), CLLocationCoordinate2D(latitude: 30.395622287327, longitude: 114.150759277344), CLLocationCoordinate2D(latitude: 30.39089436849, longitude: 114.146170518664), CLLocationCoordinate2D(latitude: 30.388713378907, longitude: 114.143856065539), CLLocationCoordinate2D(latitude: 30.388699815539, longitude: 114.143752441407), CLLocationCoordinate2D(latitude: 30.388699815539, longitude: 114.143688693577), CLLocationCoordinate2D(latitude: 30.38875, longitude: 114.143584798178), CLLocationCoordinate2D(latitude: 30.389031846789, longitude: 114.143600802952)]

        AMapServices.shared().apiKey = "ea8957728aef2552f1adc8ba9bc80168"
        
        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.showsCompass = false
        view.addSubview(mapView)
        
        if self.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = []
        }
    }

    // 添加路线
    func addOverlay() {
        let line = MAPolyline(coordinates: &t_coors, count: UInt(t_coors.count))
        mapView.add(line)
        mapView.showOverlays(mapView.overlays, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
    
    // 添加标注
    func addAnnotation() {
        let ann = MAPointAnnotation()
        ann.coordinate = t_coors.first!
        ann.title = "start"
        mapView.addAnnotation(ann)
        
        let ann1 = MAPointAnnotation()
        ann1.coordinate = t_coors.last!
        ann1.title = "end"
        mapView.addAnnotation(ann1)
        
        myLocation = MAAnimatedAnnotation()
        myLocation.coordinate = t_coors.first!
        mapView.addAnnotation(myLocation)
    }
    
    //播放暂停
    @objc func playAndPause() {
        isPlaying = !isPlaying
        
        if isPlaying {
            
            playItem.title = "暂停"
            print("开始播放")

            if myLocation == nil {
                myLocation = MAAnimatedAnnotation()
                myLocation?.coordinate = t_coors[0]
                mapView?.addAnnotation(myLocation)
            }
            
            mapView?.setCenter((myLocation?.coordinate)!, animated: true)
            mapView?.setZoomLevel(14, animated: false)
            mapView?.isScrollEnabled = false
            animateToNextCoordinate()
            
        }
        else {
            
            mapView?.isScrollEnabled = true
            playItem.title = "播放"
            print("暂停播放")
            
            if let view = mapView?.view(for: myLocation) {
                view.layer.removeAllAnimations()
            }
            
        }
    }
    
    // 移动到下一个点
    func animateToNextCoordinate() {
        
        if myLocation == nil {
            return
        }
        
        if currentIndex == t_coors.count {
            currentIndex = 0
            playAndPause()
            return
        }
        
        let nextCoor = t_coors[currentIndex]
        let preCoor = (currentIndex == 0 ? nextCoor : myLocation?.coordinate)!
        
        var aniCoors: Array<CLLocationCoordinate2D> = [CLLocationCoordinate2DMake(0, 0), CLLocationCoordinate2DMake(0, 0)]
        aniCoors[0] = preCoor
        aniCoors[1] = nextCoor
        
        let duration: TimeInterval = 0.1
        
        setCenter(coor: nextCoor, duration: duration)
        
        let _ = myLocation?.addMoveAnimation(withKeyCoordinates: &aniCoors, count: 2, withDuration: CGFloat(duration), withName: "", completeCallback: { [weak self] (finished) in
            
            if self?.isPlaying == false {
                return
            }
            
            print("current index = ", self?.currentIndex ?? 0)
            self?.currentIndex += 1
            
            if finished {
                self?.animateToNextCoordinate()
            }
        })
    }
    
    // 锁定屏幕
    func setCenter(coor: CLLocationCoordinate2D, duration: TimeInterval) {
        
        let state = MAMapStatus()
        state.centerCoordinate = coor
        state.zoomLevel = (mapView?.zoomLevel)!
        mapView?.setMapStatus(state, animated: true, duration: duration)
    }
}

extension AMapTrackVC: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let polylineView = MAPolylineRenderer(overlay: overlay)
            polylineView?.strokeColor = UIColor.blue
            polylineView?.lineWidth = 4
            return polylineView
        }
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        let pointID = "pointReuseIndetifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointID)
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointID)
        }
        if annotation.isEqual(myLocation) {
            annotationView?.image = #imageLiteral(resourceName: "ico_map_car")
        }
        return annotationView
    }
}
