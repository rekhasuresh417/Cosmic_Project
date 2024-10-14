//
//  HealthKitManager.swift
//  Cosmic_Task
//
//  Created by Splpt 161 on 14/10/24.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var healthData: HealthData?
    @Published var errorMessage: String?

    struct HealthData {
        var steps: Double
        var distance: Double // in kilometers
        var heartRate: [Double]
    }
    
    func requestAuthorization() {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
              let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }

        let dataTypes = Set([stepsType, distanceType, heartRateType])
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) in
            if success {
                self.fetchHealthData()
            } else {
                self.errorMessage = error?.localizedDescription
            }
        }
    }
    
    private func fetchHealthData() {
        let group = DispatchGroup()
        
        var steps: Double = 0
        var distance: Double = 0
        var heartRates: [Double] = []
        
        group.enter()
        fetchSteps { fetchedSteps in
            steps = fetchedSteps
            group.leave()
        }
        
        group.enter()
        fetchDistance { fetchedDistance in
            distance = fetchedDistance
            group.leave()
        }
        
        group.enter()
        fetchHeartRate { fetchedHeartRates in
            heartRates = fetchedHeartRates
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.healthData = HealthData(steps: steps, distance: distance, heartRate: heartRates)
        }
    }

    private func fetchSteps(completion: @escaping (Double) -> Void) {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let query = HKSampleQuery(sampleType: stepsType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                print("Error fetching steps: \(error.localizedDescription)")
                completion(0)
                return
            }
            let steps = results?.compactMap { ($0 as? HKQuantitySample)?.quantity.doubleValue(for: HKUnit.count()) }.reduce(0, +) ?? 0
            completion(steps)
        }
        healthStore.execute(query)
    }
    
    private func fetchDistance(completion: @escaping (Double) -> Void) {
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let query = HKSampleQuery(sampleType: distanceType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                print("Error fetching distance: \(error.localizedDescription)")
                completion(0)
                return
            }
            let distance = results?.compactMap { ($0 as? HKQuantitySample)?.quantity.doubleValue(for: HKUnit.meter()) }.reduce(0, +) ?? 0
            completion(distance / 1000) // Convert to kilometers
        }
        healthStore.execute(query)
    }
    
    private func fetchHeartRate(completion: @escaping ([Double]) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                print("Error fetching heart rate: \(error.localizedDescription)")
                completion([])
                return
            }
            let heartRates = results?.compactMap { ($0 as? HKQuantitySample)?.quantity.doubleValue(for: HKUnit(from: "count/min")) } ?? []
            completion(heartRates)
        }
        healthStore.execute(query)
    }
}
