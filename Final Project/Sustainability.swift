import SwiftUI
struct MeatConsumption: Identifiable {
  let id = UUID()
  var type: String
  var kilograms: String = ""
}
struct Sustainability: View {
  @State private var meatConsumptions: [MeatConsumption] = []
  @State private var carbonEmission: Double?
  let meatTypes = ["Beef", "Mutton", "Farm prawn", "Pork chops", "Poultry", "Salmon", "Wild Caught", "Vegan Beef", "Tofu"]
  let emissionFactors = ["Beef": 60.0, "Mutton": 24.0, "Farm prawn": 12.0, "Pork chops": 7.0, "Poultry": 6.0, "Salmon": 5.0, "Wild Caught": 3.0, "Vegan Beef": 3.5, "Tofu": 2.0] // kg CO2e per kg of meat
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          Text("Sustainability Checker")
            .font(.largeTitle)
            .padding()
          Text("Enter the type of meat you consume and the amount in a week")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(Color.black)
            .multilineTextAlignment(.center)
          ForEach(meatConsumptions) { meat in
            HStack {
              Picker("Select Meat Type", selection: Binding(
                get: { meat.type },
                set: { newValue in
                  if let index = meatConsumptions.firstIndex(where: { $0.id == meat.id }) {
                    meatConsumptions[index].type = newValue
                  }
                }
              )) {
                ForEach(meatTypes, id: \.self) { type in
                  Text(type).tag(type)
                }
              }
              .pickerStyle(MenuPickerStyle())
              .frame(width: 150)
              TextField("Kilograms", text: Binding(
                get: { meat.kilograms },
                set: { newValue in
                  if let index = meatConsumptions.firstIndex(where: { $0.id == meat.id }) {
                    meatConsumptions[index].kilograms = newValue
                  }
                }
              ))
              .keyboardType(.decimalPad)
              .padding()
              .background(Color.gray.opacity(0.2))
              .cornerRadius(10)
            }
          }
          Button(action: {
            meatConsumptions.append(MeatConsumption(type: meatTypes[0]))
          }) {
            Text("Add Meat Type")
              .foregroundColor(.white)
              .padding()
              .background(Color.green)
              .cornerRadius(10)
          }
          Button(action: calculateCarbonEmission) {
            Text("Calculate Carbon Emission")
              .foregroundColor(.white)
              .padding()
              .background(Color.blue)
              .cornerRadius(10)
          }
          if let emission = carbonEmission {
            Text("Carbon Emission: \(emission, specifier: "%.2f") kg CO2e per week")
              .font(.title2)
              .padding()
          }
          Spacer()
        }
        .padding()
      }
    }
  }
  private func calculateCarbonEmission() {
    carbonEmission = meatConsumptions.reduce(0.0) { total, meat in
      guard let kg = Double(meat.kilograms), let emissionFactor = emissionFactors[meat.type] else {
        return total
      }
      return total + (kg * emissionFactor)
    }
  }
}
#Preview {
  Sustainability()
}
