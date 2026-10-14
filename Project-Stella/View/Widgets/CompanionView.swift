//
//  CompanionView.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/10/26.
//

import SwiftUI
struct CompanionView: View {
    @State private var selected: Int = 0
    var body: some View {
        VStack(spacing: 15) {
            StellaPageSelector(selected: $selected)
            if selected == 0 {
                StellaAnalyzerPage()
            }
            else {
                StellaGeneratorPage()
            }
        }
        .padding(20)
    }
}
