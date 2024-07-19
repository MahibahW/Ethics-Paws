import SwiftUI

struct mainPage: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 50/255, green: 65/255, blue: 67/255)
                    .ignoresSafeArea()
                
                VStack {
                    Image("title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 50)
                        .offset(y: 280)
                    
                    ZStack {
                        Image("mission")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 960.0, height: 520.0)
                            .padding(.bottom)
                        
                        VStack {
                            Text("Each year, countless animals worldwide suffer severe abuse, whether through neglect, cruelty, or exploitation. At EthicsPaws, we're dedicated to raising awareness about animal abuse and empowering individuals like you to make a difference. Together, we advocate for compassion and kindness towards all creatures, striving for a world where every animal is treated with dignity and care.")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                                .lineSpacing(7)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .cornerRadius(10)
                        .padding(.horizontal, 300)
                    }
                    .offset(y:75)
                    Text("Click below to delve into the issues animals face and understand how you can make a difference.")
                        .italic()
                        .lineSpacing(5)
                        .font(.system(size: 16))
                        .fontWeight(.heavy)
                        .foregroundColor(Color(red: 103/255, green: 146/255, blue: 105/255))
                        .padding(.horizontal, 300)
                        .background(Color(red: 50/255, green: 65/255, blue: 67/255))
                        .cornerRadius(10)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                    
                    NavigationLink(destination: Globe()) {
                        Text("Abuse Across the Globe")
                            .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
                            .padding(10)
                            .padding(.horizontal, 8)
                            .background(Color(red: 73/255, green: 95/255, blue: 85/255))
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove the default button styling
                    
                    NavigationLink(destination: Calc()) {
                        Text("Budget Calculator")
                            .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
                            .padding(10)
                            .padding(.horizontal, 31)
                            .background(Color(red: 73/255, green: 95/255, blue: 85/255))
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove the default button styling
                    
                    NavigationLink(destination: Sustainability()) {
                        Text("Sustainability Checker")
                            .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
                            .padding(10)
                            .padding(.horizontal, 15)
                            .background(Color(red: 73/255, green: 95/255, blue: 85/255))
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove the default button styling
                }
                .offset(y: -180) // Move the entire VStack up to bring buttons into visible area
            }
            .navigationBarHidden(true) // Hide navigation bar if not needed
        }
    }
}

struct mainPage_Previews: PreviewProvider {
    static var previews: some View {
        mainPage()
    }
}
