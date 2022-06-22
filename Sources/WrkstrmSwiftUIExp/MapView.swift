#if canImport(SwiftUI)
import SwiftUI
#if canImport(MapKit)
import MapKit

#if os(iOS)
@available(iOS 13.0, *)
public struct MapView: UIViewRepresentable {

  public var coordinate: CLLocationCoordinate2D

  public init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }

  public func makeUIView(context _: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }

  public func updateUIView(_ view: MKMapView, context _: Context) {
    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    view.setRegion(region, animated: true)
    view.isZoomEnabled = false
    view.isScrollEnabled = false
  }
}
#else  // platform(iOS)

@available(macOS 10.15, *)
public struct MapView: NSViewRepresentable {

  public var coordinate: CLLocationCoordinate2D

  public init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }

  public func makeNSView(context _: NSViewRepresentableContext<MapView>) -> MKMapView {
    MKMapView(frame: .zero)
  }

  public func updateNSView(_ view: MKMapView, context _: NSViewRepresentableContext<MapView>) {
    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    view.setRegion(region, animated: true)
    view.isZoomEnabled = false
    view.isScrollEnabled = false
  }
}
#endif  // platform(iOS)
#endif  // canImport(MapKit)
#endif  // canImport(SwiftUI)
