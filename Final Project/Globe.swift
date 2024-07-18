import SwiftUI
import SceneKit
struct Location {
  var name: String
  var latitude: Double
  var longitude: Double
}
class GlobeModel: ObservableObject {
  @Published var selectedPin: String? // Track the currently selected pin
}
struct GlobeView: UIViewRepresentable {
  @ObservedObject var model: GlobeModel
  var sceneView = SCNView() // Keep a reference to sceneView
  func makeUIView(context: Context) -> SCNView {
    let scene = SCNScene()
    sceneView.scene = scene
    sceneView.allowsCameraControl = true
    sceneView.backgroundColor = UIColor.black
    // Add tap gesture
    let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
    sceneView.addGestureRecognizer(tapGesture)
    // Add globe and pins
    addGlobeAndPins(to: scene)
    return sceneView
  }
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  class Coordinator: NSObject {
    var parent: GlobeView
    init(parent: GlobeView) {
      self.parent = parent
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
      let location = gesture.location(in: parent.sceneView)
      let hitResults = parent.sceneView.hitTest(location, options: nil)
      if let result = hitResults.first, let nodeName = result.node.name {
        parent.togglePinSelection(for: nodeName)
      }
    }
  }
  func addGlobeAndPins(to scene: SCNScene) {
    let globe = SCNSphere(radius: 1.0)
    let material = SCNMaterial()
    material.diffuse.contents = UIImage(named: "worldmap") // Your globe texture
    globe.materials = [material]
    let globeNode = SCNNode(geometry: globe)
    scene.rootNode.addChildNode(globeNode)
    // Define locations with names
    let locations = [
      Location(name: "Afghanistan", latitude: 33.9391, longitude: 24.7100),
      Location(name: "Mexico", latitude: 23.6345, longitude: -167.5528),
      Location(name: "China", latitude: 35.8617, longitude: -10.1954),
      Location(name: "Colorado", latitude: 39.5501, longitude: -160.7821),
      Location(name: "Texas", latitude: 31.9686, longitude: -170.9018),
      Location(name: "New York", latitude: 40.7128, longitude: -190.0060),
      Location(name: "California", latitude: 38.7783, longitude: -150.4179),
      Location(name: "Argentina", latitude: -38.4161, longitude: -203.6167),
      Location(name: "Iran", latitude: 32.4279, longitude: 33.6880),
      Location(name: "Russia", latitude: 60, longitude: 0),
      Location(name: "Australia", latitude: -25.2744, longitude: -40.7751)
    ]
    for location in locations {
      let pinNode = addPin(latitude: location.latitude, longitude: location.longitude, name: location.name)
      scene.rootNode.addChildNode(pinNode)
    }
  }
  func addPin(latitude: Double, longitude: Double, name: String) -> SCNNode {
    let lat = Float(latitude * .pi / 180)
    let lon = Float(longitude * .pi / 180)
    let radius: Float = 1.0
    let x = radius * cos(lat) * cos(lon)
    let y = radius * sin(lat)
    let z = radius * cos(lat) * sin(lon)
    guard let pinImage = UIImage(named: "download") else {
      fatalError("Image not found")
    }
    let pinGeometry = SCNPlane(width: 0.1, height: 0.1)
    let pinMaterial = SCNMaterial()
    pinMaterial.diffuse.contents = pinImage
    pinMaterial.isDoubleSided = true
    pinGeometry.materials = [pinMaterial]
    let pinNode = SCNNode(geometry: pinGeometry)
    pinNode.position = SCNVector3(x, y, z)
    pinNode.name = name
    pinNode.look(at: SCNVector3(0, 0, 0))
    return pinNode
  }
  func togglePinSelection(for name: String) {
    if model.selectedPin == name {
      model.selectedPin = nil
    } else {
      model.selectedPin = name
    }
  }
  func updateUIView(_ uiView: SCNView, context: Context) {}
}
struct TooltipView: View {
  var locationName: String
  var body: some View {
    Text(locationName)
      .padding(8)
      .background(Color.white)
      .cornerRadius(5)
      .shadow(radius: 5)
      .offset(x: 0, y: -50)
  }
}
struct Globe: View {
  @StateObject private var model = GlobeModel()
  @State private var isTextVisible = true
  @State private var opacity: Double = 1.0
  var body: some View {
    ZStack {
      GlobeView(model: model)
        .edgesIgnoringSafeArea(.all)
      if let locationName = model.selectedPin {
        TooltipView(locationName: locationName)
          .position(x: 200, y: 100)
      }
      if isTextVisible {
        Text("Click on each point to view")
          .font(.headline)
          .foregroundColor(.white)
          .opacity(opacity)
          .onAppear {
            withAnimation(.easeIn(duration: 2)) {
              opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation(.easeOut(duration: 2)) {
                opacity = 0.0
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isTextVisible = false // Hide text after fading out
              }
            }
          }
          .padding()
      }
    }
  }
}

#Preview {
    Globe()
}
