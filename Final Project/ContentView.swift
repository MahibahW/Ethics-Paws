import SwiftUI
struct ContentView: View {
  var body: some View {
    NavigationStack{
      ZStack {
        Color(red: 50/255, green: 65/255, blue: 67/255)
          .ignoresSafeArea()
        VStack{
          Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
          NavigationLink(destination: mainPage()) {
            Text("Continue →")
              .foregroundColor(Color(red: 73/255, green: 95/255, blue: 85/255))
          }
          .buttonStyle(.borderedProminent)
          .tint(Color(red: 176/255, green: 197/255, blue: 133/255))
        }
      }
    }
  }
}
  #Preview {
    ContentView()
  }
