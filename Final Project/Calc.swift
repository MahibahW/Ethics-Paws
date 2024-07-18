//
//  Calc.swift
//  Final Project
//
//  Created by Scholar on 7/18/24.
//

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
    ZStack {
      backgroundColor.edgesIgnoringSafeArea(.all)
      VStack {
        Image("Intro1")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding()
        ForEach($proteins) { $protein in
          HStack {
            Text(protein.name)
              .foregroundColor(textColor)
            Spacer()
            TextField("Quantity", text: binding(for: protein.name))
              .keyboardType(.numberPad)
              .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
          }
        }
        Button("Calculate Cost") {
          calculateTotalCost()
        }
        .foregroundColor(Color(red: 73/255, green: 95/255, blue: 85/255))
        .padding()
        .background(Color(red: 176/255, green: 197/255, blue: 133/255))
        .cornerRadius(8)
        Text("Total Cost: $\(totalCost, specifier: "%.2f")")
          .fontWeight(.bold)
          .foregroundColor(Color(red: 111/255, green: 159/255, blue: 116/255))
      }
      .padding()
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
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Calc()
  }
}
#Preview {
  Calc()
}








