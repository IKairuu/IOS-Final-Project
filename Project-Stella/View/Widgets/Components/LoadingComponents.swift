import SwiftUI

struct TypingDots: View {
    var color: Color = .white
    var size: CGFloat = 8
    var body: some View {
        TimelineView(.animation) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            HStack(spacing: size * 0.6) {
                ForEach(0..<3, id: \.self) { index in
                    let wave = max(sin(time * 6 - Double(index) * 0.9), 0)
                    Circle()
                        .fill(color)
                        .frame(width: size, height: size)
                        .opacity(0.4 + 0.6 * wave)
                        .offset(y: -size * 0.5 * wave)
                }
            }
            .padding(.top, size * 0.5)
        }
    }
}

struct LoadingBubble: View {
    var body: some View {
        TypingDots()
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Design().mainTheme)
            .cornerRadius(10)
    }
}

struct StellaTypingBubble: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ChatAvatar(sender: .stella, initials: "")
            LoadingBubble()
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LoadingOverlay: View {
    let message: String
    var body: some View {
        ZStack {
            Color.black.opacity(0.65)
                .ignoresSafeArea()
            Text(message)
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(Design().secondaryColor)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        StellaTypingBubble()
        LoadingOverlay(message: "Logging you in...")
    }
    .padding(20)
    .background(Design().secondaryColor)
}
