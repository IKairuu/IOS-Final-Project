//
//  SectionDivider.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/1/26.
//

import SwiftUI

struct SectionDivider: View {
    var body: some View {
        Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .overlay(Color.black)
            .padding(.bottom, 20)
    }
}
