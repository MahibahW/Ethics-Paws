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
  @State private var quantities: [String: String] = [:] // Changed to store String values
  @State private var totalCost: Double = 0.0
  var body: some View {
    VStack {
      ForEach($proteins) { $protein in // Keep using $proteins
        HStack {
          Text(protein.name)
          Spacer()
          TextField("Quantity", text: binding(for: protein.name))
            .keyboardType(.numberPad)
        }
      }
      Button("Calculate Cost") {
        calculateTotalCost()
      }
      Text("Total Cost: $\(totalCost, specifier: "%.2f")")
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
