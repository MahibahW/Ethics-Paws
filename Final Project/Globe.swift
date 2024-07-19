import SwiftUI
import SceneKit

struct Location {
    var name: String
    var additional: String
    var latitude: Double
    var longitude: Double
    var details: String // New property for additional details

    init(name: String, additional: String, latitude: Double, longitude: Double) {
        self.name = name
        self.additional = additional
        self.latitude = latitude
        self.longitude = longitude
        self.details = "" // Initialize details here if needed
    }
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

        let locations = [
            Location(name: "Afghanistan", additional: "Across Afghanistan, countless homeless cats and dogs endure daily hardships on the streets, scavenging for food amid the challenges of parasites, disease, and infection. Similarly, donkeys, horses, mules, and other working animals labor tirelessly under harsh conditions until their exhausted bodies give out. Many Afghans regard these animals as cherished family members, emphasizing the deep bond between humans and animals. Despite extensive rescue efforts, both human and animal, numerous lives have been tragically left behind. While some animals are forced into cruel activities like dogfights, songbird fights, and buzkashi, our capacity to save every animal is limited. However, you can still make a significant and lasting difference by supporting organizations such as Nowzad and Kabul Small Animal Rescue. These groups are dedicated to evacuating veterinarians, their families, and as many animals as possible to safety. For those animals unable to be rescued, they ensure a compassionate end through painless euthanasia, sparing them from further suffering.", latitude: 33.9391, longitude: 24.7100),
                   Location(name: "Mexico", additional:"According to World Animal Protection, similar to the United States, animal rights laws in Mexico vary by state. The organization summarizes, |\"Most states recognize animal sentience, with some explicitly acknowledging it for all animals such as in the Federal District and Michoacán. However, states like Colima exclude certain animals labeled as 'pests' from legal protections.\" This recognition of animals' capacity to feel pain and suffer, prevalent across many states, forms a solid foundation for animal welfare efforts. Enforcement in Mexico commonly relies on fines, which range widely, typically amounting to |\"1 to 500 times the daily minimum wage in the respective state or federal district.\" This variation underscores the decentralized nature of animal welfare legislation across Mexico.", latitude: 23.6345, longitude: -167.5528),
                 Location(name: "China", additional:"In China, animals endure widespread and severe mistreatment across various sectors. Bears are confined in tiny cages solely for bile extraction, a practice linked to traditional Chinese medicine. Dogs and cats face brutal slaughter for meat, highlighting the alarming prevalence of animal exploitation in the region. Compared to other continents, Asia lacks robust protections against animal cruelty, presenting challenges for organizations like Animals Asia that strive to improve conditions. One particularly egregious practice in China is bear bile farming, where bile is extracted from live bears, inflicting unimaginable suffering. Many mammals in Asian zoos suffer neglect and diseases, often exhibiting distressing behaviors due to confinement and inadequate medical care. Moreover, millions of dogs and cats lead precarious lives as abandoned pets or street strays, with a significant number ending up in the meat trade annually. To support efforts against such cruelty, consider donating to organizations dedicated to animal welfare in Asia, such as Animals Asia. Your contributions can help rescue animals from dire situations, provide them with necessary medical care, and advocate for stronger animal protection laws. By supporting these initiatives, you can make a meaningful impact in combating the extreme forms of animal abuse prevalent in zoos, safari parks, circuses, and tourist attractions across Asia.",latitude: 35.8617, longitude: -10.1954),
                 Location(name: "Colorado", additional:"In Colorado, the welfare of livestock is primarily overseen by the Colorado Department of Agriculture's Bureau of Animal Protection (CDA BAP). This agency handles investigations into complaints related to livestock, ensuring that farmers adhere to guidelines like those outlined in the |\"Beef Quality Assurance\" standards. These guidelines emphasize humane care practices such as providing adequate food, water, disease prevention, and maintaining safe facilities. However, enforcement specifics regarding these regulations remain unclear.When it comes to addressing animal cruelty, Colorado's laws classify severe violations as serious offenses, punishable by fines and potentially higher penalties for cases like animal fighting. While laws typically focus on farm animal abuse, they provide avenues for reporting to local law enforcement and animal advocacy groups for awareness and community action. For those passionate about animal welfare in Colorado, organizations like the Animal Welfare Association of Colorado offer opportunities for education, collaboration, and advocacy. By supporting these efforts, individuals can contribute to improving the lives and treatment of animals across the state.",latitude: 39.5501, longitude: -160.7821),
                 Location(name: "Texas", additional:"In Texas, laws concerning animal welfare are comprehensive, covering both civil and criminal aspects. Civil cases may result in fines or the removal of animals from offenders, while criminal cases can lead to imprisonment, community service, or probation. Under Texas Penal Code Sections 42.09 and 42.092, individuals are prohibited from intentionally, knowingly, or recklessly mistreating animals, whether livestock or non-livestock. |\"Loco’s Law,\" enacted through House Bill 653 and Senate Bill 1724 in 2001, upgraded animal cruelty to a felony offense. Violators face penalties of up to $10,000 in fines and two years of imprisonment, as per the SPCA of Texas. Depending on the severity of the offense, penalties can range from significant fines to imprisonment for up to 10 years, enforced by the Animal Cruelty division of the Montgomery County District Attorney's Office. Residents can support animal welfare legislation through the Texas Humane Legislation Network, which offers avenues for donations and membership, fostering local engagement in animal protection efforts. Sources: SPCA of Texas, Montgomery County District Attorney's Office.",latitude: 31.9686, longitude: -170.9018),
                 Location(name: "New York", additional:"In New York, animals are safeguarded by a robust framework of civil and criminal laws aimed at preventing cruelty and ensuring their welfare. The state's legal provisions are comprehensive, addressing both livestock and non-livestock animals under Section 353 of the Agriculture and Markets Law. Civil cases in New York can result in the forfeiture of animals or imposition of fines upon perpetrators, while criminal cases under Article 26 of the Agriculture and Markets Law can lead to incarceration, community service, or probation for offenders. New York's commitment to animal welfare was bolstered by the passage of |\"Buster's Law\" in 1999, which enhanced penalties for aggravated cruelty to animals, a felony offense. This legislation, named after a cat named Buster who was brutally tortured, marked a significant step in combating animal abuse in the state. Organizations like the ASPCA (American Society for the Prevention of Cruelty to Animals) and local shelters play crucial roles in enforcing animal welfare laws, providing rescue and rehabilitation services, and advocating for stronger protections. Through education, advocacy, and rescue efforts, these organizations strive to create a more compassionate environment for animals across New York State. To support animal welfare initiatives in New York, consider donating to organizations like the ASPCA or local animal shelters. Your contribution can help protect animals from cruelty, provide them with necessary care, and promote humane treatment practices throughout the state.",latitude: 40.7128, longitude: -190.0060),
                 Location(name: "California", additional:"In California, animals are protected by a robust legal framework designed to prevent cruelty and ensure their well-being. The state's laws, particularly under the California Penal Code and the California Food and Agriculture Code, address various aspects of animal welfare and define offenses related to mistreatment. Civil laws in California allow for the removal of animals from abusive situations and impose fines or other penalties on offenders. Criminal laws, including provisions under Penal Code Section 597, can result in misdemeanor or felony charges, depending on the severity of the abuse. California has been at the forefront of animal protection efforts, with landmark legislation such as the California Animal Cruelty Prevention Act (Proposition 2), which regulates the confinement of farm animals. The state also prohibits activities like dogfighting and cockfighting under Penal Code Section 597b. Local animal control agencies, humane societies, and organizations like the Humane Society of the United States (HSUS) and the SPCA (Society for the Prevention of Cruelty to Animals) of California play vital roles in enforcing these laws. They rescue animals from abusive situations, provide veterinary care, and work to educate the public about responsible pet ownership and humane treatment. Supporting animal welfare in California can be done through donations to organizations like the HSUS, local SPCAs, or shelters that provide direct care and advocacy. By contributing to these efforts, you help ensure that animals in California receive the protection and care they deserve.",latitude: 38.7783, longitude: -150.4179),
                 Location(name: "Argentina", additional:"In Argentina, the conservation of wildlife is a critical endeavor amidst diverse ecosystems that support a wide array of species. From the vast grasslands of the Pampas to the Andean mountains and the expansive wetlands of the Iberá Marshes, Argentina is home to iconic wildlife such as the jaguar, Andean condor, and capybara. However, these species face significant threats, including habitat loss, illegal wildlife trade, and human-wildlife conflict. The jaguar, South America's largest feline, is particularly vulnerable due to deforestation and fragmentation of its habitat. Conservation efforts are crucial to protect these species and their habitats. Organizations like the Conservation Land Trust (CLT) and Fundación Vida Silvestre Argentina (FVSA) play pivotal roles in wildlife conservation across Argentina. CLT focuses on creating protected areas and restoring habitats to conserve biodiversity, while FVSA works on sustainable development and raising awareness about the importance of wildlife conservation. One of the notable conservation successes in Argentina is the reintroduction of species like the giant anteater and the pampas deer to their natural habitats through collaborative efforts between conservationists and local communities. These initiatives aim to restore balance to ecosystems and mitigate human impacts on wildlife. To support wildlife conservation in Argentina, consider donating to organizations like CLT and FVSA, which work tirelessly to protect endangered species and promote sustainable practices. Your contribution can help safeguard Argentina's rich biodiversity and ensure a future where wildlife thrives in harmony with local communities.",latitude: -38.4161, longitude: -203.6167),
                 Location(name: "Iran", additional:"In Iran, animals face significant challenges stemming from habitat degradation, the illegal wildlife trade, and varying levels of enforcement of animal welfare laws. The Persian leopard and Asiatic cheetah, both native species, are particularly at risk due to habitat loss and poaching. Livestock also contend with issues such as overcrowding and inadequate veterinary care in some regions. Despite efforts to protect animals, including legal frameworks, enforcement can be inconsistent, leaving many animals vulnerable to mistreatment and neglect.To support wildlife conservation and animal welfare in Iran, consider donating to organizations like the Persian Wildlife Heritage Foundation, which focuses on preserving Persian wildlife and protecting endangered species like the Asiatic cheetah. Additionally, Pardisan Wildlife Park serves as a sanctuary for native wildlife while promoting environmental education and research. Another worthy cause is the Vafa Animal Shelter, which rescues and provides medical care to stray and injured animals across the country. Your donations can make a meaningful impact in safeguarding Iran's wildlife and improving the lives of animals in need.",latitude: 32.4279, longitude: 33.6880),
                 Location(name: "Russia", additional:"In Russia, the conservation and protection of wildlife face significant challenges amidst vast landscapes and diverse ecosystems. The country is home to iconic species such as the Siberian tiger, Amur leopard, and polar bear, each facing threats from habitat loss, poaching, and climate change. Wildlife conservation efforts are often hindered by economic pressures, political complexities, and varying enforcement of environmental laws across different regions. One of the most pressing issues is illegal wildlife trade, which affects species like the critically endangered Amur tiger hunted for their pelts and bones. Conservation organizations in Russia, such as WWF Russia and the Amur Tiger Center, work diligently to protect these species through habitat preservation, anti-poaching patrols, and community engagement programs. The vastness of Russia's wilderness presents both challenges and opportunities for conservation. Efforts to establish protected areas and promote sustainable land use practices are critical to safeguarding biodiversity. Organizations like WWF Russia focus on habitat conservation and restoration, conducting scientific research to inform conservation strategies. To support wildlife conservation in Russia, consider donating to organizations like WWF Russia, which leads conservation initiatives across the country, protecting endangered species and their habitats. The Amur Tiger Center specifically focuses on the conservation of the Amur tiger and its habitat in the Russian Far East, aiming to ensure a future for this iconic species. Your support can help these organizations continue their efforts to preserve Russia's rich wildlife heritage for future generations.",latitude: 60, longitude: 0),
                 Location(name: "Australia", additional:"In Australia, animals face a variety of challenges and mistreatment. Issues such as habitat destruction and climate change affect native wildlife, while concerns over livestock welfare and intensive farming practices are also significant. Australia's unique biodiversity is under pressure, with species like koalas threatened by habitat loss and bushfires. Despite having animal welfare laws, enforcement and protection can vary, potentially leaving animals vulnerable to neglect or exploitation. Conservation groups and animal welfare organizations play a crucial role in addressing these issues and advocating for better protections nationwide.In Australia, animals face diverse challenges ranging from habitat loss and climate change to issues associated with human-wildlife conflict and the impact of invasive species. Iconic species like the koala, kangaroo, and platypus are under threat due to habitat destruction caused by urbanization, agriculture, and wildfires exacerbated by climate change. Wildlife rescue centers across the country work tirelessly to rehabilitate injured and orphaned animals, such as kangaroos and koalas affected by bushfires or vehicle collisions.Despite strong wildlife protection laws, enforcement and funding for conservation efforts can vary, impacting the effectiveness of conservation initiatives. The country's vast marine and terrestrial ecosystems support a rich diversity of species, but many are vulnerable to extinction without sustained conservation efforts. Community-based organizations like WIRES (Wildlife Information, Rescue and Education Service) and Wildlife Victoria play crucial roles in rescuing and rehabilitating injured wildlife, conducting research, and promoting public awareness of conservation issues.To support wildlife conservation efforts in Australia, consider donating to organizations like WIRES, which operates Australia's largest wildlife rescue organization, providing rescue and care for tens of thousands of animals every year. Wildlife Victoria also offers rescue and rehabilitation services statewide, responding to thousands of calls for assistance annually. These organizations rely on public support to continue their vital work in protecting Australia's unique wildlife and ecosystems.",latitude: -25.2744, longitude: -40.7751)
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
        
        guard let pinImage = UIImage(named: "pin") else {
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
    var location: Location

    var body: some View {
        ScrollView {
            VStack {
                Text(location.name)
                    .font(.system(size: 20))
                    .padding(.top, 15)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                    .cornerRadius(10)
                Text(location.additional)
                    .font(.body)
                    .padding()
                    .foregroundColor(Color(red: 236/255, green: 226/255, blue: 208/255))
                    .multilineTextAlignment(.center)
                Text(location.details) // Display details
                    .font(.body)
                    .padding()
            }
            
            .background(Color(red: 50/255, green: 65/255, blue: 67/255))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.top, 300)
            .padding(.horizontal, 100)
            
        }
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
            
            if let selectedPin = model.selectedPin {
                if let location = getLocation(for: selectedPin) {
                    TooltipView(location: location)
                        .position(x: 200, y: 100)
                } else {
                    // Handle the case where location is nil, perhaps show an error or fallback UI
                    Text("Location not found")
                        .foregroundColor(.red)
                        .position(x: 200, y: 100)
                }
            }
        

            
            
            if isTextVisible {
                Text("Click on each point to view")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            opacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeOut(duration: 1)) {
                                opacity = 0.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isTextVisible = false // Hide text after fading out
                            }
                        }
                    }
                    .padding()
            }
        }
    }
    
    func getLocation(for name: String) -> Location? {
        // Replace this with your actual data lookup logic based on name
        switch name {
        case "nothing":
            return Location(name: "nothing", additional: "w", latitude: 0, longitude: 0)
        case "Afghanistan":
        return Location(name: "Afghanistan:", additional: "Across Afghanistan, countless homeless cats and dogs endure daily hardships on the streets, scavenging for food amid the challenges of parasites, disease, and infection. Similarly, donkeys, horses, mules, and other working animals labor tirelessly under harsh conditions until their exhausted bodies give out. Many Afghans regard these animals as cherished family members, emphasizing the deep bond between humans and animals. Despite extensive rescue efforts, both human and animal, numerous lives have been tragically left behind. While some animals are forced into cruel activities like dogfights, songbird fights, and buzkashi, our capacity to save every animal is limited. However, you can still make a significant and lasting difference by supporting organizations such as Nowzad and Kabul Small Animal Rescue. These groups are dedicated to evacuating veterinarians, their families, and as many animals as possible to safety. For those animals unable to be rescued, they ensure a compassionate end through painless euthanasia, sparing them from further suffering.", latitude: 33.9391, longitude: 24.7100)
        case "Mexico":
        return Location(name: "Mexico", additional:"According to World Animal Protection, similar to the United States, animal rights laws in Mexico vary by state. The organization summarizes, |\"Most states recognize animal sentience, with some explicitly acknowledging it for all animals such as in the Federal District and Michoacán. However, states like Colima exclude certain animals labeled as 'pests' from legal protections.\" This recognition of animals' capacity to feel pain and suffer, prevalent across many states, forms a solid foundation for animal welfare efforts. Enforcement in Mexico commonly relies on fines, which range widely, typically amounting to |\"1 to 500 times the daily minimum wage in the respective state or federal district.\" This variation underscores the decentralized nature of animal welfare legislation across Mexico.", latitude: 23.6345, longitude: -167.5528)
        case "China":
          return Location(name: "China", additional:"In China, animals endure widespread and severe mistreatment across various sectors. Bears are confined in tiny cages solely for bile extraction, a practice linked to traditional Chinese medicine. Dogs and cats face brutal slaughter for meat, highlighting the alarming prevalence of animal exploitation in the region. Compared to other continents, Asia lacks robust protections against animal cruelty, presenting challenges for organizations like Animals Asia that strive to improve conditions. One particularly egregious practice in China is bear bile farming, where bile is extracted from live bears, inflicting unimaginable suffering. Many mammals in Asian zoos suffer neglect and diseases, often exhibiting distressing behaviors due to confinement and inadequate medical care. Moreover, millions of dogs and cats lead precarious lives as abandoned pets or street strays, with a significant number ending up in the meat trade annually. To support efforts against such cruelty, consider donating to organizations dedicated to animal welfare in Asia, such as Animals Asia. Your contributions can help rescue animals from dire situations, provide them with necessary medical care, and advocate for stronger animal protection laws. By supporting these initiatives, you can make a meaningful impact in combating the extreme forms of animal abuse prevalent in zoos, safari parks, circuses, and tourist attractions across Asia.",latitude: 35.8617, longitude: -10.1954)
        case "Colorado":
          return Location(name: "Colorado", additional:"In Colorado, the welfare of livestock is primarily overseen by the Colorado Department of Agriculture's Bureau of Animal Protection (CDA BAP). This agency handles investigations into complaints related to livestock, ensuring that farmers adhere to guidelines like those outlined in the |\"Beef Quality Assurance\" standards. These guidelines emphasize humane care practices such as providing adequate food, water, disease prevention, and maintaining safe facilities. However, enforcement specifics regarding these regulations remain unclear.When it comes to addressing animal cruelty, Colorado's laws classify severe violations as serious offenses, punishable by fines and potentially higher penalties for cases like animal fighting. While laws typically focus on farm animal abuse, they provide avenues for reporting to local law enforcement and animal advocacy groups for awareness and community action. For those passionate about animal welfare in Colorado, organizations like the Animal Welfare Association of Colorado offer opportunities for education, collaboration, and advocacy. By supporting these efforts, individuals can contribute to improving the lives and treatment of animals across the state.",latitude: 39.5501, longitude: -160.7821)
        case "Texas":
          return Location(name: "Texas", additional:"In Texas, laws concerning animal welfare are comprehensive, covering both civil and criminal aspects. Civil cases may result in fines or the removal of animals from offenders, while criminal cases can lead to imprisonment, community service, or probation. Under Texas Penal Code Sections 42.09 and 42.092, individuals are prohibited from intentionally, knowingly, or recklessly mistreating animals, whether livestock or non-livestock. |\"Loco’s Law,\" enacted through House Bill 653 and Senate Bill 1724 in 2001, upgraded animal cruelty to a felony offense. Violators face penalties of up to $10,000 in fines and two years of imprisonment, as per the SPCA of Texas. Depending on the severity of the offense, penalties can range from significant fines to imprisonment for up to 10 years, enforced by the Animal Cruelty division of the Montgomery County District Attorney's Office. Residents can support animal welfare legislation through the Texas Humane Legislation Network, which offers avenues for donations and membership, fostering local engagement in animal protection efforts. Sources: SPCA of Texas, Montgomery County District Attorney's Office.",latitude: 31.9686, longitude: -170.9018)
        case "New York":
          return Location(name: "New York", additional:"In New York, animals are safeguarded by a robust framework of civil and criminal laws aimed at preventing cruelty and ensuring their welfare. The state's legal provisions are comprehensive, addressing both livestock and non-livestock animals under Section 353 of the Agriculture and Markets Law. Civil cases in New York can result in the forfeiture of animals or imposition of fines upon perpetrators, while criminal cases under Article 26 of the Agriculture and Markets Law can lead to incarceration, community service, or probation for offenders. New York's commitment to animal welfare was bolstered by the passage of |\"Buster's Law\" in 1999, which enhanced penalties for aggravated cruelty to animals, a felony offense. This legislation, named after a cat named Buster who was brutally tortured, marked a significant step in combating animal abuse in the state. Organizations like the ASPCA (American Society for the Prevention of Cruelty to Animals) and local shelters play crucial roles in enforcing animal welfare laws, providing rescue and rehabilitation services, and advocating for stronger protections. Through education, advocacy, and rescue efforts, these organizations strive to create a more compassionate environment for animals across New York State. To support animal welfare initiatives in New York, consider donating to organizations like the ASPCA or local animal shelters. Your contribution can help protect animals from cruelty, provide them with necessary care, and promote humane treatment practices throughout the state.",latitude: 40.7128, longitude: -190.0060)
        case "California":
          return Location(name: "California", additional:"In California, animals are protected by a robust legal framework designed to prevent cruelty and ensure their well-being. The state's laws, particularly under the California Penal Code and the California Food and Agriculture Code, address various aspects of animal welfare and define offenses related to mistreatment. Civil laws in California allow for the removal of animals from abusive situations and impose fines or other penalties on offenders. Criminal laws, including provisions under Penal Code Section 597, can result in misdemeanor or felony charges, depending on the severity of the abuse. California has been at the forefront of animal protection efforts, with landmark legislation such as the California Animal Cruelty Prevention Act (Proposition 2), which regulates the confinement of farm animals. The state also prohibits activities like dogfighting and cockfighting under Penal Code Section 597b. Local animal control agencies, humane societies, and organizations like the Humane Society of the United States (HSUS) and the SPCA (Society for the Prevention of Cruelty to Animals) of California play vital roles in enforcing these laws. They rescue animals from abusive situations, provide veterinary care, and work to educate the public about responsible pet ownership and humane treatment. Supporting animal welfare in California can be done through donations to organizations like the HSUS, local SPCAs, or shelters that provide direct care and advocacy. By contributing to these efforts, you help ensure that animals in California receive the protection and care they deserve.",latitude: 38.7783, longitude: -150.4179)
        case "Argentina":
          return Location(name: "Argentina", additional:"In Argentina, the conservation of wildlife is a critical endeavor amidst diverse ecosystems that support a wide array of species. From the vast grasslands of the Pampas to the Andean mountains and the expansive wetlands of the Iberá Marshes, Argentina is home to iconic wildlife such as the jaguar, Andean condor, and capybara. However, these species face significant threats, including habitat loss, illegal wildlife trade, and human-wildlife conflict. The jaguar, South America's largest feline, is particularly vulnerable due to deforestation and fragmentation of its habitat. Conservation efforts are crucial to protect these species and their habitats. Organizations like the Conservation Land Trust (CLT) and Fundación Vida Silvestre Argentina (FVSA) play pivotal roles in wildlife conservation across Argentina. CLT focuses on creating protected areas and restoring habitats to conserve biodiversity, while FVSA works on sustainable development and raising awareness about the importance of wildlife conservation. One of the notable conservation successes in Argentina is the reintroduction of species like the giant anteater and the pampas deer to their natural habitats through collaborative efforts between conservationists and local communities. These initiatives aim to restore balance to ecosystems and mitigate human impacts on wildlife. To support wildlife conservation in Argentina, consider donating to organizations like CLT and FVSA, which work tirelessly to protect endangered species and promote sustainable practices. Your contribution can help safeguard Argentina's rich biodiversity and ensure a future where wildlife thrives in harmony with local communities.",latitude: -38.4161, longitude: -203.6167)
        case "Iran":
          return Location(name: "Iran", additional:"In Iran, animals face significant challenges stemming from habitat degradation, the illegal wildlife trade, and varying levels of enforcement of animal welfare laws. The Persian leopard and Asiatic cheetah, both native species, are particularly at risk due to habitat loss and poaching. Livestock also contend with issues such as overcrowding and inadequate veterinary care in some regions. Despite efforts to protect animals, including legal frameworks, enforcement can be inconsistent, leaving many animals vulnerable to mistreatment and neglect.To support wildlife conservation and animal welfare in Iran, consider donating to organizations like the Persian Wildlife Heritage Foundation, which focuses on preserving Persian wildlife and protecting endangered species like the Asiatic cheetah. Additionally, Pardisan Wildlife Park serves as a sanctuary for native wildlife while promoting environmental education and research. Another worthy cause is the Vafa Animal Shelter, which rescues and provides medical care to stray and injured animals across the country. Your donations can make a meaningful impact in safeguarding Iran's wildlife and improving the lives of animals in need.",latitude: 32.4279, longitude: 33.6880)
        case "Russia":
            return Location(name: "Russia", additional: "In Russia, the conservation and protection of wildlife face significant challenges amidst vast landscapes and diverse ecosystems. The country is home to iconic species such as the Siberian tiger, Amur leopard, and polar bear, each facing threats from habitat loss, poaching, and climate change. Wildlife conservation efforts are often hindered by economic pressures, political complexities, and varying enforcement of environmental laws across different regions. One of the most pressing issues is illegal wildlife trade, which affects species like the critically endangered Amur tiger hunted for their pelts and bones. Conservation organizations in Russia, such as WWF Russia and the Amur Tiger Center, work diligently to protect these species through habitat preservation, anti-poaching patrols, and community engagement programs. The vastness of Russia's wilderness presents both challenges and opportunities for conservation. Efforts to establish protected areas and promote sustainable land use practices are critical to safeguarding biodiversity. Organizations like WWF Russia focus on habitat conservation and restoration, conducting scientific research to inform conservation strategies. To support wildlife conservation in Russia, consider donating to organizations like WWF Russia, which leads conservation initiatives across the country, protecting endangered species and their habitats. The Amur Tiger Center specifically focuses on the conservation of the Amur tiger and its habitat in the Russian Far East, aiming to ensure a future for this iconic species. Your support can help these organizations continue their efforts to preserve Russia's rich wildlife heritage for future generations.", latitude: 60, longitude: 0)
        case "Australia":
            return Location(name: "Australia", additional: "In Australia, animals face a variety of challenges and mistreatment. Issues such as habitat destruction and climate change affect native wildlife, while concerns over livestock welfare and intensive farming practices are also significant. Australia's unique biodiversity is under pressure, with species like koalas threatened by habitat loss and bushfires. Despite having animal welfare laws, enforcement and protection can vary, potentially leaving animals vulnerable to neglect or exploitation. Conservation groups and animal welfare organizations play a crucial role in addressing these issues and advocating for better protections nationwide.In Australia, animals face diverse challenges ranging from habitat loss and climate change to issues associated with human-wildlife conflict and the impact of invasive species. Iconic species like the koala, kangaroo, and platypus are under threat due to habitat destruction caused by urbanization, agriculture, and wildfires exacerbated by climate change. Wildlife rescue centers across the country work tirelessly to rehabilitate injured and orphaned animals, such as kangaroos and koalas affected by bushfires or vehicle collisions.Despite strong wildlife protection laws, enforcement and funding for conservation efforts can vary, impacting the effectiveness of conservation initiatives. The country's vast marine and terrestrial ecosystems support a rich diversity of species, but many are vulnerable to extinction without sustained conservation efforts. Community-based organizations like WIRES (Wildlife Information, Rescue and Education Service) and Wildlife Victoria play crucial roles in rescuing and rehabilitating injured wildlife, conducting research, and promoting public awareness of conservation issues.To support wildlife conservation efforts in Australia, consider donating to organizations like WIRES, which operates Australia's largest wildlife rescue organization, providing rescue and care for tens of thousands of animals every year. Wildlife Victoria also offers rescue and rehabilitation services statewide, responding to thousands of calls for assistance annually. These organizations rely on public support to continue their vital work in protecting Australia's unique wildlife and ecosystems.", latitude: -25.2744, longitude: 133.7751)
        default:
            return nil // Handle cases where name doesn't match any location
        }
    }
}

struct Globe_Previews: PreviewProvider {
    static var previews: some View {
        Globe()
    }
}
