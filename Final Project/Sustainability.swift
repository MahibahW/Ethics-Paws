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
                    
                    Image("Sustainability")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .padding(.top, 80)
                      .padding(.bottom, 50)
                        
                    
                    Text("The consumption of meat from unethical sources not only harms animals but also significantly impacts the environment. In fact, 19.6% of global CO2 emissions stem from livestock alone. Gain perspective on this issue with our sustainability checker.")
                        .font(.system(size: 20))
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                        .lineSpacing(10)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                        .background(Color(red: 50/255, green: 65/255, blue: 67/255))
                        .cornerRadius(10)
                    Text("Click the button to select from various meat types and specify quantities in kilograms. You can add more types using the pick list. Finally, hit |\"Calculate\" to determine your weekly CO2 emissions from meat consumption.")
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
                    ForEach(meatConsumptions.indices, id: \.self) { index in
                        meatConsumptionInput(index: index)
                    }
                    
                    Button(action: {
                        meatConsumptions.append(MeatConsumption(type: meatTypes[0]))
                    }) {
                        Text("Add Meat Type")
                            .foregroundColor(Color(red: 73/255, green: 95/255, blue: 85/255))
                            .padding(10)
                            .padding(.horizontal, 35)
                            .background(Color(red: 176/255, green: 197/255, blue: 133/255))
                            .cornerRadius(10)
                    }
                    
                    Button(action: calculateCarbonEmission) {
                        Text("Calculate Carbon Emission")
                            .foregroundColor(Color(red: 73/255, green: 95/255, blue: 85/255))
                            .padding(10)
                            .padding(.horizontal, 15)
                            .background(Color(red: 176/255, green: 197/255, blue: 133/255))
                            .cornerRadius(10)
                                             
                    }
                    
                    if let emission = carbonEmission {
                        Text("Carbon Emission: \(emission, specifier: "%.2f") kg CO2e per week")
                            .foregroundColor(Color(red: 176/255, green: 197/255, blue: 133/255))
                            .buttonStyle(.borderedProminent)
                            .tint(Color(red: 73/255, green: 95/255, blue: 85/255))
                            .font(.title2)
                            .padding()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(red: 50/255, green: 65/255, blue: 67/255)) // Set background color
            .edgesIgnoringSafeArea(.all) // Ignore safe area to fill the entire screen
        }
    }
    
    private func meatConsumptionInput(index: Int) -> some View {
        let meat = meatConsumptions[index]
        return VStack(alignment: .leading) {
            Picker("Select Meat Type", selection: Binding(
                get: { meat.type },
                set: { newValue in
                    if let index = meatConsumptions.firstIndex(where: { $0.id == meat.id }) {
                        meatConsumptions[index].type = newValue
                    }
                }
            )) {
                ForEach(meatTypes, id: \.self) { type in
                    Text(type)
                        .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                        .tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2)) // Default background color
                    .frame(height: 40)
                    .cornerRadius(5)
                
                if meat.kilograms.isEmpty {
                    Text("Kilograms")
                        .foregroundColor(Color(red: 180/255, green: 182/255, blue: 184/255)) // Placeholder text color #b4b6b8
                        .padding(.horizontal)
                        .opacity(0.5) // Adjust opacity if needed
                }
                
                TextField("", text: Binding(
                    get: { meat.kilograms },
                    set: { newValue in
                        if let index = meatConsumptions.firstIndex(where: { $0.id == meat.id }) {
                            meatConsumptions[index].kilograms = newValue
                        }
                    }
                ))
                .foregroundColor(Color.white) // Text color when typing
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .keyboardType(.decimalPad)
            }
            .padding(.vertical, 8)
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

struct Sustainability_Previews: PreviewProvider {
    static var previews: some View {
        Sustainability()
    }
}


