import SwiftUI

struct AnimatedHealthIndicator: View {
    let category: BMICategory
    let bmi: Double
    @State private var animationValue = 0.0
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                // Animated progress circle
                Circle()
                    .trim(from: 0, to: animationValue)
                    .stroke(
                        category.gradient,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                // Animated center content
                VStack(spacing: 4) {
                    Image(systemName: category.icon)
                        .font(.title)
                        .foregroundStyle(category.color)
                        .keyframeAnimator(initialValue: AnimationValues()) { content, value in
                            content
                                .scaleEffect(value.scale)
                                .rotationEffect(.degrees(value.rotation))
                                .opacity(value.opacity)
                        } keyframes: { _ in
                            KeyframeTrack(\.scale) {
                                SpringKeyframe(1.3, duration: 0.3)
                                SpringKeyframe(1.0, duration: 0.2)
                            }
                            KeyframeTrack(\.rotation) {
                                LinearKeyframe(0, duration: 0.1)
                                SpringKeyframe(360, duration: 0.4)
                            }
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(0, duration: 0.1)
                                LinearKeyframe(1, duration: 0.2)
                            }
                        }
                    
                    Text(String(format: "%.1f", bmi))
                        .font(.headline)
                        .fontWeight(.bold)
                        .contentTransition(.numericText())
                }
            }
            
            // Category label with pulse animation
            Text(category.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(category.color)
                .phaseAnimator([false, true]) { content, phase in
                    content
                        .scaleEffect(phase ? 1.05 : 1.0)
                        .opacity(phase ? 0.8 : 1.0)
                } animation: { phase in
                    .easeInOut(duration: 0.8).repeatCount(3)
                }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
                animationValue = normalizedProgress
            }
        }
    }
    
    private var normalizedProgress: Double {
        min(max(bmi / 40, 0), 1)
    }
}

struct AnimationValues {
    var scale = 0.8
    var rotation = 0.0
    var opacity = 0.0
}

struct FloatingParticlesView: View {
    let category: BMICategory
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(category.color.opacity(0.6))
                    .frame(width: particle.size, height: particle.size)
                    .offset(x: particle.x, y: particle.y)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            generateParticles()
            animateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<20).map { _ in
            Particle(
                id: UUID(),
                x: Double.random(in: -100...100),
                y: Double.random(in: -100...100),
                size: Double.random(in: 4...12),
                opacity: Double.random(in: 0.3...0.8),
                scale: Double.random(in: 0.5...1.0)
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(
            .easeInOut(duration: 3.0)
            .repeatForever(autoreverses: true)
        ) {
            for index in particles.indices {
                particles[index].x += Double.random(in: -50...50)
                particles[index].y += Double.random(in: -50...50)
                particles[index].opacity *= 0.5
                particles[index].scale *= 1.2
            }
        }
    }
}

struct Particle: Identifiable {
    let id: UUID
    var x: Double
    var y: Double
    let size: Double
    var opacity: Double
    var scale: Double
}

struct PulsingHealthRing: View {
    let category: BMICategory
    let progress: Double
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Outer pulse ring
            Circle()
                .stroke(category.color.opacity(0.3), lineWidth: 2)
                .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                .opacity(pulseAnimation ? 0 : 0.8)
                .animation(
                    .easeOut(duration: 1.5)
                    .repeatForever(autoreverses: false),
                    value: pulseAnimation
                )
            
            // Main progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    category.gradient,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.2, dampingFraction: 0.8), value: progress)
            
            // Inner glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [category.color.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .scaleEffect(0.8)
        }
        .onAppear {
            pulseAnimation = true
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        AnimatedHealthIndicator(category: .normal, bmi: 22.5)
        
        PulsingHealthRing(category: .overweight, progress: 0.75)
            .frame(width: 100, height: 100)
    }
    .padding()
}