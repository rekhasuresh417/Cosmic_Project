import SwiftUI

struct HealthMetricsView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some View {
        NavigationView {
            VStack {
                if let healthData = healthKitManager.healthData {
                    HealthMetricCard(title: "Steps", value: String(format: "%.0f", healthData.steps))
                    HealthMetricCard(title: "Distance", value: String(format: "%.2f km", healthData.distance))
                        .padding()
                    Text("Heart Rate")
                    LineChart(data: healthData.heartRate)
                        .frame(height: 300)
                        .padding()
                } else if let errorMessage = healthKitManager.errorMessage {
                    Text("Error: \(errorMessage)").foregroundColor(.red)
                } else {
                    Text("Loading data...").onAppear {
                        healthKitManager.requestAuthorization()
                    }
                }
            }
            .navigationTitle("Health Metrics")
            .padding()
        }
    }
}

struct HealthMetricCard: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .frame(width: 120, height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
        .scaleEffect(1.1)
        .animation(.spring(), value: UUID()) // Add animation
    }
}

struct LineChart: View {
    var data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard let firstPoint = data.first else { return }
                
                let width = geometry.size.width
                let height = geometry.size.height
                let maxY = data.max() ?? 1
                let minY = data.min() ?? 0
                let yScale = height / (maxY - minY)
                let xScale = width / CGFloat(data.count - 1)
                
                path.move(to: CGPoint(x: 0, y: height - CGFloat(firstPoint - minY) * yScale))
                for index in data.indices {
                    let x = CGFloat(index) * xScale
                    let y = height - CGFloat(data[index] - minY) * yScale
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}
