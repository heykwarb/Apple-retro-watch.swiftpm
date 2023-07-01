import SwiftUI

struct ContentView: View {
    @ObservedObject var motion = MotionSensor()
    
    @State var date = Date()
    let dateFormatter = DateFormatter()
    let cal = Calendar.current
    
    @State var hour: Double = 0
    @State var minute: Double = 0
    @State var second: Double = 0
    
    @State var timer: Timer!
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .padding()
            GeometryReader{geo in
                let circleSize: CGFloat = geo.size.width/12
                VStack{
                    metalBadge(motion: motion)
                        .frame(width: circleSize, height: circleSize)
                    Spacer()
                    HStack{
                        metalBadge(motion: motion)
                            .frame(width: circleSize, height: circleSize)
                        Spacer()
                        metalBadge(motion: motion)
                            .frame(width: circleSize, height: circleSize)
                    }
                    Spacer()
                    metalBadge(motion: motion)
                        .frame(width: circleSize, height: circleSize)
                }
                .padding()
                .padding(circleSize/2)
                
                VStack{
                    HStack{
                        Spacer()
                        Image("Apple_Logo_rainbow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: circleSize*2, height: circleSize*2)
                            .offset(y: geo.size.height/8)
                        Spacer()
                    }
                }
                .padding()
                .padding(circleSize/2)
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        hourHand()
                            .frame(width: geo.size.width/4, height: geo.size.width/3)
                            .foregroundColor(.green)
                            .shadow(radius: 4)
                            .offset(y: -geo.size.width/4+geo.size.width/8)
                            .rotationEffect(Angle(degrees: Double(hour ?? 0)/12*360 + Double(minute ?? 0)/60/12*360))
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        minuteHand()
                            .frame(width: geo.size.width/16, height: geo.size.width/3)
                            .shadow(radius: 4)
                            .offset(y: -geo.size.width/6)
                            .rotationEffect(Angle(degrees: Double(minute ?? 0)/60*360))
                        Spacer()
                    }
                    Spacer()
                }
                
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        secondHand()
                            .frame(width: geo.size.width/2.8)
                            .shadow(radius: 4)
                            .rotationEffect(Angle(degrees: Double(second ?? 0)/60*360))
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.blue)
        .cornerRadius(150)
        .shadow(radius: 10)
        ///.offset(x: motion.attitudeRoll*25, y: motion.attitudePitch*25) //motion interaction
        .onAppear(){
            ///motion.start()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { Timer in
                ///print("timer")
                let comp = Calendar.current.dateComponents(
                    [Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second],
                    from: Date())
                withAnimation(){
                    hour = Double(comp.hour ?? 0)
                    minute = Double(comp.minute ?? 0)
                    second = Double(comp.second ?? 0)
                }
            }
        }
    }
}

struct metalBadge: View{
    @ObservedObject var motion: MotionSensor
    let offsetValue: CGFloat = 6
    var body: some View{
        ZStack{
            Circle()
                .foregroundColor(.gray.opacity(0.5))
            Circle()
                .foregroundColor(.white.opacity(0.5))
                .padding(offsetValue)
                .blur(radius: offsetValue/2)
                .offset(x: motion.attitudeRoll/CGFloat.pi*offsetValue, y: motion.attitudePitch/CGFloat.pi*offsetValue)
        }
    }
}

struct secondHand: View{
    var body: some View{
        ZStack{
            Wave(amplitude: 14, frequency: 10)
                .stroke(lineWidth: 3)
                .fill(Color.yellow)
                .offset(x: 55, y: 0)
                .rotationEffect(Angle(degrees: -90))
            Circle()
                .foregroundColor(.yellow)
                .padding(36)
        }
    }
}

struct minuteHand: View{
    var body: some View{
        Capsule()
            .foregroundColor(.red)
    }
}

struct hourHand: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
        
    }
}

struct Wave: Shape {
    var amplitude: Double
    var frequency: Double
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = -x / wavelength

            // calculate the sine of that position
            let sine = sin(relativeX)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = amplitude * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
}

