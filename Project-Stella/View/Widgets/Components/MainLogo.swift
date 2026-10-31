//
//  MainLogo.swift
//  Project-Stella
//
//  Created by Mac-LAB on 9/8/26.
//

import SwiftUI

struct MainLogo: View {
    var body: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 166, height: 166)
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}
