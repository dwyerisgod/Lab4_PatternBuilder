import SwiftUI

// Класс здания
class Building {
    var type: String?
    var floors: Int?
    var color: String?

    init(type: String) {
        self.type = type
    }
}

// Протокол для строителей зданий
protocol BuildingBuilder {
    func setFloors(_ number: Int) -> Self
    func setColor(_ color: String) -> Self
    func build() -> Building
}

// Конкретный строитель зданий
class ConcreteBuildingBuilder: BuildingBuilder {
    private var building: Building

    init(type: String) {
        self.building = Building(type: type)
    }

    func setFloors(_ number: Int) -> Self {
        building.floors = number
        return self
    }

    func setColor(_ color: String) -> Self {
        building.color = color
        return self
    }

    func build() -> Building {
        return self.building
    }
}

// Директор управляет последовательностью строительных шагов
class Director {
    private var builder: BuildingBuilder?

    func updateBuilder(_ builder: BuildingBuilder) {
        self.builder = builder
    }

    func buildBasicBuilding() {
        builder?.setFloors(1).setColor("White")
    }

    func buildCustomBuilding() {
        builder?.setFloors(3).setColor("Blue")
    }
}

struct ContentView: View {
    @State private var selectedBuildingType = "Residential"
    @State private var floors = ""
    @State private var color = ""

    @State private var result: Building?

    var body: some View {
        VStack {
            Picker("Select Building Type", selection: $selectedBuildingType) {
                Text("Residential").tag("Residential")
                Text("Commercial").tag("Commercial")
            }
            .pickerStyle(.segmented)
            .padding()

            TextField("Enter Number of Floors", text: $floors)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Enter Building Color", text: $color)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Build") {
                buildBuilding()
            }
            .padding()

            if let result = result {
                Text("Built \(result.type ?? "") building with \(result.floors ?? 0) floors and color \(result.color ?? "")")
                    .padding()
            }
        }
        .padding()
    }

    private func buildBuilding() {
        let builder = ConcreteBuildingBuilder(type: selectedBuildingType)
        let director = Director()

        director.updateBuilder(builder)

        if let numberOfFloors = Int(floors) {
            builder.setFloors(numberOfFloors).setColor(color)
        }

        result = builder.build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
