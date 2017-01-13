//
//  GMSMapView+Rx.swift
//  Staxi
//
//  Created by Hoan Pham on 3/17/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import CoreLocation
//import RxExtensions

extension CLLocationCoordinate2D: Equatable { }

public func == (l: CLLocationCoordinate2D, r: CLLocationCoordinate2D) -> Bool {
    return fabs(l.latitude - r.latitude) < 0.00001 && fabs(l.longitude - r.longitude) < 0.00001
}
/*

extension Reactive where Base: GMSMapView {
    
    public var delegate: DelegateProxy {
        return RxGMSMapViewDelegateProxy.proxyForObject(base)
    }
    
    public var selectedMarker: Observable<GMSMarker?> {
        return self.observe(GMSMarker.self, "base.selectedMarker").shareReplay(1)
    }
    
    public var zoom: Observable<Float> {
        return self.observe(Float.self, "base.camera.zoom").filterNil().shareReplay(1)
    }
    
    /**
     * Called before the camera on the map changes, either due to a gesture,
     * animation (e.g., by a user tapping on the "My Location" button) or by being
     * updated explicitly via the camera or a zero-length animation on layer.
     *
     * @param gesture If YES, this is occuring due to a user gesture.
     */
    public var mapWillMove: Observable<Bool> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:willMove:)))
            .map { x in try castOrThrow(Bool.self, x[1]) }
    }
//    - (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture;
    
    
    /**
     * Called repeatedly during any animations or gestures on the map (or once, if
     * the camera is explicitly set). This may not be called for all intermediate
     * camera positions. It is always called for the final position of an animation
     * or gesture.
     */
    public var cameraChanged: Observable<GMSCameraPosition> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didChange:)))
            .map { x in try castOrThrow(GMSCameraPosition.self, x[1]) }
    }
    
    public var coordinateChanged: Observable<CLLocationCoordinate2D> {
        return cameraChanged.map { $0.target }.distinctUntilChanged()
    }
//    - (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position;
    
    /**
     * Called when the map becomes idle, after any outstanding gestures or
     * animations have completed (or after the camera has been explicitly set).
     */
    public var idleAtPosition: Observable<GMSCameraPosition> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:idleAt:)))
            .map { x in try castOrThrow(GMSCameraPosition.self, x[1]) }
    }
    
    public var idleAtCoordinate: Observable<CLLocationCoordinate2D> {
        return idleAtPosition.map { $0.target }.distinctUntilChanged()
    }

//    - (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position;
    
    /**
     * Called after a tap gesture at a particular coordinate, but only if a marker
     * was not tapped.  This is called before deselecting any currently selected
     * marker (the implicit action for tapping on the map).
     */
//    - (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate;
    
    /**
     * Called after a long-press gesture at a particular coordinate.
     *
     * @param mapView The map view that was tapped.
     * @param coordinate The location that was tapped.
     */
    public var longPressCoordinate: Observable<CLLocationCoordinate2D> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didLongPressAt:)))
            .map { x in try castOrThrow(CLLocationCoordinate2D.self, x[1]) }
    }
//    - (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;
    
    /**
     * Called after a marker has been tapped.
     *
     * @param mapView The map view that was tapped.
     * @param marker The marker that was tapped.
     * @return YES if this delegate handled the tap event, which prevents the map
     *         from performing its default selection behavior, and NO if the map
     *         should continue with its default selection behavior.
     */
//    - (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker;
    
    /**
     * Called after a marker's info window has been tapped.
     */
    public var tapInfoWindow: Observable<GMSMarker> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTapInfoWindowOf:)))
            .map { x in try castOrThrow(GMSMarker.self, x[1]) }
    }
//    - (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker;
    
    /**
     * Called after a marker's info window has been long pressed.
     */
    public var longPressInfoWindow: Observable<GMSMarker> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didLongPressInfoWindowOf:)))
            .map { x in try castOrThrow(GMSMarker.self, x[1]) }
    }
//    - (void)mapView:(GMSMapView *)mapView didLongPressInfoWindowOfMarker:(GMSMarker *)marker;
    
    /**
     * Called after an overlay has been tapped.
     * This method is not called for taps on markers.
     *
     * @param mapView The map view that was tapped.
     * @param overlay The overlay that was tapped.
     */
    public var tapOverlay: Observable<GMSOverlay> {
        return delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTap:)))
    }
//    - (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay;
    
    /**
     *  Called after a POI has been tapped.
     *
     * @param mapView The map view that was tapped.
     * @param placeID The placeID of the POI that was tapped.
     * @param name The name of the POI that was tapped.
     * @param location The location of the POI that was tapped.
     */
//    - (void)mapView:(GMSMapView *)mapView
//    didTapPOIWithPlaceID:(NSString *)placeID
//    name:(NSString *)name
//    location:(CLLocationCoordinate2D)location;
    
    /**
     * Called when a marker is about to become selected, and provides an optional
     * custom info window to use for that marker if this method returns a UIView.
     * If you change this view after this method is called, those changes will not
     * necessarily be reflected in the rendered version.
     *
     * The returned UIView must not have bounds greater than 500 points on either
     * dimension.  As there is only one info window shown at any time, the returned
     * view may be reused between other info windows.
     *
     * Removing the marker from the map or changing the map's selected marker during
     * this call results in undefined behavior.
     *
     * @return The custom info window for the specified marker, or nil for default
     */
//    - (UIView *GMS_NULLABLE_PTR)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker;
    
    /**
     * Called when mapView:markerInfoWindow: returns nil. If this method returns a
     * view, it will be placed within the default info window frame. If this method
     * returns nil, then the default rendering will be used instead.
     *
     * @param mapView The map view that was pressed.
     * @param marker The marker that was pressed.
     * @return The custom view to display as contents in the info window, or nil to
     * use the default content rendering instead
     */
    
//    - (UIView *GMS_NULLABLE_PTR)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker;
    
    /**
     * Called when the marker's info window is closed.
     */
//    - (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker;
    
    /**
     * Called when dragging has been initiated on a marker.
     */
//    - (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker;
    
    /**
     * Called after dragging of a marker ended.
     */
//    - (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker;
    
    /**
     * Called while a marker is dragged.
     */
//    - (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker;
    
    /**
     * Called when the My Location button is tapped.
     *
     * @return YES if the listener has consumed the event (i.e., the default behavior should not occur),
     *         NO otherwise (i.e., the default behavior should occur). The default behavior is for the
     *         camera to move such that it is centered on the user location.
     */
//    - (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView;
    
    /**
     * Called when tiles have just been requested or labels have just started rendering.
     */
//    - (void)mapViewDidStartTileRendering:(GMSMapView *)mapView;
    
    /**
     * Called when all tiles have been loaded (or failed permanently) and labels have been rendered.
     */
//    - (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView;
    
    /**
     * Called when map is stable (tiles loaded, labels rendered, camera idle) and overlay objects have
     * been rendered.
     */
//    - (void)mapViewSnapshotReady:(GMSMapView *)mapView;

    
    
    
    
    
    
    
    
    
    
    
    
}
 
 */

extension GMSMapView {
    
    public var rx_delegate: DelegateProxy {
        return RxGMSMapViewDelegateProxy.proxyForObject(self)
    }
    
    public var rx_selectedMarker: Observable<GMSMarker?> {
        return self.rx.observe(GMSMarker.self, "selectedMarker").shareReplay(1)
    }
    
    
    public var rx_zoom: Observable<Float> {
        return self.rx.observe(Float.self, "camera.zoom")
            .filterNil()
            .shareReplay(1)
    }
    

    
    
    
    
    /**
    * Called before the camera on the map changes, either due to a gesture,
    * animation (e.g., by a user tapping on the "My Location" button) or by being
    * updated explicitly via the camera or a zero-length animation on layer.
    *
    * @param gesture If YES, this is occuring due to a user gesture.
    */
//    - (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture;
    public var rx_mapWillMove: Observable<Bool> {
        
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:willMove:)))
            .map { x in
                return try castOrThrow(Bool.self, x[1])
            }
    }
    
    /**
    * Called repeatedly during any animations or gestures on the map (or once, if
    * the camera is explicitly set). This may not be called for all intermediate
    * camera positions. It is always called for the final position of an animation
    * or gesture.
    */
//    - (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position;
    
    public var rx_mapChangedPostion: Observable<GMSCameraPosition> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didChange:)))
            .map { x in
                return try castOrThrow(GMSCameraPosition.self, x[1])
            }
    }
    
    public var rx_mapChangedCoordinate: Observable<CLLocationCoordinate2D> {
        return rx_mapChangedPostion
            .map { $0.target }
            .distinctUntilChanged()
    }
    
    /**
    * Called when the map becomes idle, after any outstanding gestures or
    * animations have completed (or after the camera has been explicitly set).
    */
//    - (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position;
    public var rx_mapIdleAtPostion: Observable<GMSCameraPosition> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:idleAt:)))
            .map { x in
                return try castOrThrow(GMSCameraPosition.self, x[1])
            }
    }
    
    public var rx_mapIdleAtCoordinate: Observable<CLLocationCoordinate2D> {
        return rx_mapIdleAtPostion
            .map { $0.target }
            .distinctUntilChanged()
    }
    
    /**
    * Called after a tap gesture at a particular coordinate, but only if a marker
    * was not tapped.  This is called before deselecting any currently selected
    * marker (the implicit action for tapping on the map).
    */
//    - (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate;
    
//    public var rx_tappedAtCoordinate: Observable<CLLocationCoordinate2D> {
//        return rx_delegate.observe(#selector(GMSMapViewDelegate.mapView(_:didTapAtCoordinate:)))
//            .map { x in
//                return try castOrThrow(CLLocationCoordinate2D.self, x[1])
//            }
//    }
    
    /**
    * Called after a long-press gesture at a particular coordinate.
    *
    * @param mapView The map view that was pressed.
    * @param coordinate The location that was pressed.
    */
//    - (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate;
    public var rx_longPressedAtCoordinate: Observable<CLLocationCoordinate2D> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didLongPressAt:)))
            .map { x in
                return try castOrThrow(CLLocationCoordinate2D.self, x[1])
        }
    }
    
    /**
    * Called after a marker's info window has been tapped.
    */
//    - (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker;
    public var rx_tappedMarkerInfoWindow: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTapInfoWindowOf:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
            }
    }
    
    /**
    * Called after a marker's info window has been long pressed.
    */
//    - (void)mapView:(GMSMapView *)mapView didLongPressInfoWindowOfMarker:(GMSMarker *)marker;
    public var rx_longPressedMarkerInfoWindow: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didLongPressInfoWindowOf:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
            }
    }
    
    /**
    * Called after an overlay has been tapped.
    * This method is not called for taps on markers.
    *
    * @param mapView The map view that was pressed.
    * @param overlay The overlay that was pressed.
    */
//    - (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay;
    public var rx_tappedOverlay: Observable<GMSOverlay> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTap:)))
            .map { x in
                return try castOrThrow(GMSOverlay.self, x[1])
            }
    }
    
    /**
    * Called when the marker's info window is closed.
    */
//    - (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker;
    public var rx_closedMarkerInfoIndow: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didCloseInfoWindowOf:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
            }
    }
    
    /**
    * Called when dragging has been initiated on a marker.
    */
//    - (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker;
    public var rx_beginDraggingMarker: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didBeginDragging:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
        }
    }
    
    /**
    * Called after dragging of a marker ended.
    */
//    - (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker;
    public var rx_endDraggingMarker: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didEndDragging:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
        }
    }
    
    /**
    * Called while a marker is dragged.
    */
//    - (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker;
    public var rx_draggingMarker: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didDrag:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
        }
    }
    
    /**
    * Called when tiles have just been requested or labels have just started rendering.
    */
//    - (void)mapViewDidStartTileRendering:(GMSMapView *)mapView;
    public var rx_startTileRendering: Observable<Void> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapViewDidStartTileRendering(_:)))
            .map { _ in }
    }
    
    
    /**
    * Called when all tiles have been loaded (or failed permanently) and labels have been rendered.
    */
//    - (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView;
    public var rx_finishTileRendering: Observable<Void> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapViewDidFinishTileRendering(_:)))
            .map { _ in }
    }
    
    public var rx_snapshotReady: Observable<Void> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapViewSnapshotReady(_:)))
            .map { _ in }
    }
    
    /**
    * Called after a marker has been tapped.
    *
    * @param mapView The map view that was pressed.
    * @param marker The marker that was pressed.
    * @return YES if this delegate handled the tap event, which prevents the map
    *         from performing its default selection behavior, and NO if the map
    *         should continue with its default selection behavior.
    */
//    - (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker;
    
    public var rx_tappedMarker: Observable<GMSMarker> {
        return rx_delegate.methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTap:)))
            .map { x in
                return try castOrThrow(GMSMarker.self, x[1])
            }
    }
}

/*
@protocol GMSMapViewDelegate<NSObject>

@optional








/**
* Called after a marker has been tapped.
*
* @param mapView The map view that was pressed.
* @param marker The marker that was pressed.
* @return YES if this delegate handled the tap event, which prevents the map
*         from performing its default selection behavior, and NO if the map
*         should continue with its default selection behavior.
*/
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker;

/**
* Called when the My Location button is tapped.
*
* @return YES if the listener has consumed the event (i.e., the default behavior should not occur),
*         NO otherwise (i.e., the default behavior should occur). The default behavior is for the
*         camera to move such that it is centered on the user location.
*/
- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView;


/**
* Called when a marker is about to become selected, and provides an optional
* custom info window to use for that marker if this method returns a UIView.
* If you change this view after this method is called, those changes will not
* necessarily be reflected in the rendered version.
*
* The returned UIView must not have bounds greater than 500 points on either
* dimension.  As there is only one info window shown at any time, the returned
* view may be reused between other info windows.
*
* Removing the marker from the map or changing the map's selected marker during
* this call results in undefined behavior.
*
* @return The custom info window for the specified marker, or nil for default
*/
- (UIView *GMS_NULLABLE_PTR)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker;

/**
* Called when mapView:markerInfoWindow: returns nil. If this method returns a
* view, it will be placed within the default info window frame. If this method
* returns nil, then the default rendering will be used instead.
*
* @param mapView The map view that was pressed.
* @param marker The marker that was pressed.
* @return The custom view to display as contents in the info window, or nil to
* use the default content rendering instead
*/

- (UIView *GMS_NULLABLE_PTR)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker;



@end
*/


fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

fileprivate func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
