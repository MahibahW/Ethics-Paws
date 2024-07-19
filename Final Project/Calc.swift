import SwiftUI

struct Protein: Identifiable {
    let id = UUID()
    var name: String
    let pricePerKg: Double
}

struct Calc: View {
    @State private var proteins: [Protein] = [
        Protein(name: "Beef (kg)", pricePerKg: 26.46),
        Protein(name: "Mutton (kg)", pricePerKg: 18),
        Protein(name: "Farmed Prawns (kg)", pricePerKg: 23),
        Protein(name: "Pork Chops (kg)", pricePerKg: 14),
        Protein(name: "Poultry (kg)", pricePerKg: 15),
        Protein(name: "Farmed Fish (kg)", pricePerKg: 22),
        Protein(name: "Wild Caught Fish (kg)", pricePerKg: 18),
        Protein(name: "Vegan Meat (kg)", pricePerKg: 10),
        Protein(name: "Tofu (kg)", pricePerKg: 9),
    ]
    @State private var quantities: [String: String] = [:]
    @State private var totalCost: Double = 0.0
    let backgroundColor = Color(red: 50/255, green: 65/255, blue: 67/255)
    let textColor = Color(red: 236/255, green: 226/255, blue: 208/255)
    
    var body: some View {
        NavigationView{
                ZStack {
                    Color(red: 50/255, green: 65/255, blue: 67/255).edgesIgnoringSafeArea(.all)
                    ScrollView {
                    backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("Intro1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        
                        VStack {
                            Text("One impactful way to combat animal abuse is to reduce meat consumption. While eliminating meat entirely may not be feasible for everyone, choosing to avoid factory-farmed products and opting instead for free-range or wild-caught options can make a significant difference. We understand that this choice can come at a cost, so we've developed a calculator to help you plan your weekly budget for protein per kilogram.")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                                .lineSpacing(10)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 4)
                                .background(Color(red: 50/255, green: 65/255, blue: 67/255))
                                .cornerRadius(10)
                        }
                        
                        Text("To calculate your weekly protein budget, select the protein options and enter the quantities you plan to consume (e.g., 3). Click calculate to get your total instantly!")
                            .italic()
                            .lineSpacing(5)
                            .font(.system(size: 16))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 103/255, green: 146/255, blue: 105/255))
                            .padding(.vertical)
                            .padding(.horizontal, 9)
                            .background(Color(red: 50/255, green: 65/255, blue: 67/255))
                            .cornerRadius(10)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom)
                        
                        ForEach($proteins) { $protein in
                            HStack {
                                Text(protein.name)
                                    .foregroundColor(textColor)
                                Spacer()
                                TextField("Quantity", text: binding(for: protein.name))
                                    .keyboardType(.numberPad)
                                    .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                            }
                            .padding(.horizontal)
                        }
                        
                        Button("Calculate Cost") {
                            calculateTotalCost()
                        }
                        .foregroundColor(Color(red: 73/255, green: 95/255, blue: 85/255))
                        .padding(10)
                        .padding(.horizontal, 25)
                        .background(Color(red: 176/255, green: 197/255, blue: 133/255))
                        .cornerRadius(10)
                        .padding(.top)
                        
                        Text("Total Cost: $\(totalCost, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 111/255, green: 159/255, blue: 116/255))
                            .padding(.bottom)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            // Set navigation bar appearance to transparent
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            // Ensure back button is visible with no title
            appearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward"), transitionMaskImage: UIImage(systemName: "arrow.backward"))
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func binding(for key: String) -> Binding<String> {
        return Binding(
            get: { self.quantities[key, default: ""] },
            set: { self.quantities[key] = $0 }
        )
    }
    
    func calculateTotalCost() {
        totalCost = 0.0
        for protein in proteins {
            if let quantityString = quantities[protein.name],
               let quantity = Int(quantityString) {
                totalCost += protein.pricePerKg * Double(quantity)
            }
        }
    }
}

struct Calc_Previews: PreviewProvider {
    static var previews: some View {
        Calc()
    }
}

