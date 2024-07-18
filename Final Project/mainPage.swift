import SwiftUI
struct mainPage: View {
  var body: some View {
    NavigationStack{
      ZStack {
        Color(red: 50/255, green: 65/255, blue: 67/255)
          .ignoresSafeArea()
      VStack{
        Image("mission")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
        NavigationLink(destination: Globe()) {
          Text("Abuse across the globe...")
            .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(red: 73/255, green: 95/255, blue: 85/255))
        NavigationLink(destination: Calc()) {
          Text("Reduce your imprint!")
            .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(red: 73/255, green: 95/255, blue: 85/255))
        .padding()
          NavigationLink(destination: Sustainability()) {
            Text("sustainability")
              .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
          }
          .buttonStyle(.borderedProminent)
          .tint(Color(red: 73/255, green: 95/255, blue: 85/255))
        }
      }
    }
  }
}
#Preview {
  mainPage()
}

#Preview {
    mainPage()
}
