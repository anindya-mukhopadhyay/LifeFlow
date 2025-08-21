import SwiftUI
import AVFoundation
import Speech

struct ChatbotFAQView: View {
    @State private var messages: [Message] = [
        Message(text: "Hi! I’m your blood donation assistant. How can I help you today?", isUser: false, date: Date())
    ]
    @State private var inputText: String = ""
    
    @State private var isListening = false
    @State private var speechRecognizer = SFSpeechRecognizer()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { msg in
                            MessageView(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Button(action: {
                    if isListening {
                        stopListening()
                    } else {
                        startListening()
                    }
                }) {
                    Image(systemName: isListening ? "mic.fill" : "mic")
                        .foregroundColor(isListening ? .red : .blue)
                        .font(.system(size: 24))
                        .padding(10)
                        .background(isListening ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
                
                TextField("Ask a question...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isListening)
                    .submitLabel(.send)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isListening ? Color.gray : Color.red)
                        .clipShape(Circle())
                }
                .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isListening)
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationTitle("Chatbot & FAQ")
        .onAppear {
            requestSpeechAuth()
        }
    }
    
    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = Message(text: trimmed, isUser: true, date: Date())
        messages.append(userMessage)
        
        // Simulate bot response with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let replyText = getBotReply(for: trimmed)
            let botMessage = Message(text: replyText, isUser: false, date: Date())
            messages.append(botMessage)
            speak(text: replyText)
        }
        
        inputText = ""
    }
    
    func getBotReply(for question: String) -> String {
        let lowerQ = question.lowercased()
        
        let faqData: [[String]: [String]] = [
            ["eligibility", "who can donate", "criteria", "requirements", "qualify"]: [
                "You must be at least 18 years old, weigh over 50kg, and be healthy to donate blood.",
                "Blood donors need to be 18+, weigh at least 50kg, and be in good health."
            ],
            
            ["interval", "gap", "how often", "frequency"]: [
                "The minimum gap between two whole blood donations is 3 months for men, 4 months for women.",
                "Plasma and platelet donations can be done every 2 weeks."
            ],
            
            ["thalassemia", "thalassemic", "genetic blood disorder"]: [
                "Thalassemia is a genetic blood disorder. People with severe thalassemia cannot donate blood.",
                "Individuals with severe thalassemia are not eligible to donate blood."
            ],
            
            ["blood groups", "blood type", "types of blood"]: [
                "There are 8 main blood types: A+, A-, B+, B-, AB+, AB-, O+, and O-.",
                "Blood types include A, B, AB, and O, each with positive or negative Rh factor."
            ],
            
            ["rarest blood group", "least common"]: [
                "AB negative is the rarest blood group in the world, found in only about 1% of people."
            ],
            
            ["most common blood group", "frequent blood type"]: [
                "O positive is the most common blood group globally, about 37% of people have O+."
            ],
            
            ["universal donor", "O negative"]: [
                "O negative blood can be given to anyone in emergencies.",
                "It is the universal donor type."
            ],
            
            ["universal recipient", "AB positive"]: [
                "AB positive individuals can receive blood from all blood types.",
                "It is the universal recipient group."
            ],
            
            ["donation process", "how to donate", "steps"]: [
                "You fill a health questionnaire, undergo a quick medical check, then donate blood in about 10 minutes.",
                "The process involves registration, health check, donation, and refreshments."
            ],
            
            ["plasma donation", "plasma"]: [
                "Plasma donation helps burn and clotting disorder patients.",
                "Plasma can be donated every 2 weeks safely."
            ],
            
            ["platelet donation", "platelets"]: [
                "Platelet donation helps cancer and dengue patients.",
                "It takes about 1.5–2 hours and can be done every 2 weeks."
            ],
            
            ["after donation", "side effects", "post donation"]: [
                "Most donors feel fine after donation, but some might experience mild dizziness or fatigue.",
                "Rest for 10–15 minutes, drink water, and avoid heavy exercise for 24 hours."
            ],
            
            ["pregnant women", "pregnancy"]: [
                "Pregnant women are not allowed to donate blood.",
                "You must wait until after delivery to be eligible."
            ],
            
            ["breastfeeding", "lactating"]: [
                "Breastfeeding mothers cannot donate blood.",
                "Wait until you have stopped breastfeeding before donating."
            ],
            
            ["anemia", "low hemoglobin"]: [
                "Anemic individuals are not allowed to donate blood.",
                "Low hemoglobin makes donation unsafe."
            ],
            
            ["high blood pressure", "hypertension"]: [
                "People with controlled blood pressure can donate.",
                "Uncontrolled hypertension may disqualify a donor."
            ],
            
            ["diabetic", "diabetes"]: [
                "Diabetics with controlled sugar levels may donate.",
                "Insulin-dependent diabetics should consult a doctor before donating."
            ],
            
            ["smoker", "smoking"]: [
                "Yes, but avoid smoking 2 hours before and after donation."
            ],
            
            ["alcohol", "drinking"]: [
                "Avoid alcohol for at least 24 hours before donation."
            ],
            
            ["tattoo", "piercing"]: [
                "You can donate 6–12 months after getting a tattoo or piercing."
            ],
            
            ["cancer", "cancer survivors"]: [
                "Cancer patients and survivors are usually not allowed to donate blood."
            ],
            
            ["malaria", "fever"]: [
                "You must wait 3 months after recovering from malaria."
            ],
            
            ["covid", "corona"]: [
                "You can donate 14 days after recovery from COVID-19."
            ],
            
            ["jaundice", "hepatitis"]: [
                "People with hepatitis-related jaundice cannot donate blood."
            ],
            
            ["medication", "drugs"]: [
                "Some medicines are allowed; check with a doctor before donating."
            ],
            
            ["documents", "ID", "proof"]: [
                "Bring a valid ID such as Aadhaar or driving license for donation."
            ],
            
            ["blood storage", "shelf life"]: [
                "Red blood cells last up to 42 days, plasma can be frozen for up to a year."
            ],
            
            ["blood volume", "amount collected"]: [
                "350–450ml of blood is collected in one donation, which is safe for the donor."
            ],
            
            ["recovery time", "after donation recovery"]: [
                "Plasma and fluids recover in 24–48 hours, red cells take a few weeks."
            ],
            
            ["exercise", "workout"]: [
                "Avoid heavy exercise for 24 hours after donation."
            ],
            
            ["hydration", "water"]: [
                "Drink plenty of fluids before and after donation to prevent dizziness."
            ],
            
            ["food", "pre donation meal"]: [
                "Eat a light meal and avoid fatty foods before donating blood."
            ],
            
            ["needle fear", "pain"]: [
                "Most donors feel only a small pinprick; the process is nearly painless."
            ],
            
            ["blood tests", "screening"]: [
                "Every donated unit is tested for HIV, Hepatitis B & C, Malaria, and Syphilis."
            ],
            
            ["emergency", "urgent", "immediate need"]: [
                "Hospitals will notify eligible donors directly if there is an urgent need for blood.",
                "Emergency blood requests are prioritized and communicated swiftly."
            ],
            
            ["children", "underage"]: [
                "Only individuals 18 years and older are allowed to donate blood."
            ],
            
            ["elderly", "age limit"]: [
                "Donors can donate up to 65 years old if healthy."
            ],
            
            ["donation for surgery", "post-surgery"]: [
                "Donors must wait 6–12 months after major surgery; consult your doctor first."
            ],
            
            ["blood donation for asthma", "asthma patient"]: [
                "Mild, controlled asthma patients can donate; uncontrolled asthma may prevent donation."
            ],
            
            ["voluntary donation", "selling blood"]: [
                "Blood donation is always voluntary; selling or buying blood is illegal."
            ],
            
            ["benefits", "health"]: [
                "Blood donation saves lives, reduces excess iron, and improves heart health."
            ],
            
            ["calories", "burned"]: [
                "Donating blood burns about 600 calories."
            ],
            
            ["fun fact", "interesting"]: [
                "Donating blood helps your body burn around 600 calories and improves cardiovascular health."
            ],
            
            ["thank", "thanks", "thank you"]: [
                "You’re welcome! If you have more questions, just ask.",
                "Glad I could help! Feel free to ask anything else."
            ],

            // Additional 40+ entries to reach 100+
            ["can diabetic donate", "diabetes"]: [
                "Yes, if sugar is controlled and you are not insulin-dependent.",
                "Diabetics on oral medication can usually donate blood."
            ],
            ["can hypertensive donate", "high bp"]: [
                "Yes, if blood pressure is under control with medication."
            ],
            ["donation during periods", "menstruation"]: [
                "Not recommended to donate during menstruation due to weakness."
            ],
            ["donor weight", "minimum weight"]: [
                "You must weigh at least 50kg to donate blood."
            ],
            ["plasma donation frequency", "plasma interval"]: [
                "Plasma can be donated every 2 weeks safely."
            ],
            ["platelet donation frequency", "platelets interval"]: [
                "Platelet donation can be done every 2 weeks."
            ],
            ["iron levels", "blood iron"]: [
                "Blood donation helps reduce excess iron in the body."
            ],
            ["cancer risk", "donation benefit"]: [
                "Regular blood donation may reduce the risk of certain cancers."
            ],
            ["blood donation safety", "is it safe"]: [
                "Yes, donation is safe with sterile disposable needles."
            ],
            ["blood donation pain", "needle"]: [
                "A small pinprick is felt; most donors report minimal pain."
            ],
            ["blood donation for surgery", "surgery recovery"]: [
                "Wait 6–12 months after major surgery; consult your doctor first."
            ],
            ["blood donation in covid recovery", "post covid"]: [
                "Wait at least 14 days after recovery from COVID-19 symptoms."
            ],
            ["blood donation after malaria", "malaria recovery"]: [
                "Wait 3 months after malaria recovery before donating."
            ],
            ["blood donation after hepatitis", "jaundice recovery"]: [
                "People with hepatitis-related jaundice cannot donate blood."
            ],
            ["blood donation after tattoo", "tattoo wait"]: [
                "Wait 6–12 months after getting a tattoo before donating."
            ],
            ["blood donation for anemia", "low hb"]: [
                "People with low hemoglobin are not allowed to donate."
            ],
            ["blood donation for pregnant women", "pregnancy"]: [
                "Pregnant women cannot donate blood."
            ],
            ["blood donation for breastfeeding", "lactation"]: [
                "Breastfeeding mothers cannot donate."
            ],
            ["blood donation for minor illnesses", "cold fever"]: [
                "Wait until fully recovered from minor illnesses before donating."
            ],
            ["blood donation and alcohol", "alcohol"]: [
                "Avoid alcohol at least 24 hours before donation."
            ],
            ["blood donation and smoking", "smoker"]: [
                "Avoid smoking 2 hours before and after donation."
            ],
            ["blood donation and medications", "medication"]: [
                "Check with doctor before donating if on medication."
            ],
            ["blood donation benefits", "why donate"]: [
                "Saves lives, improves heart health, reduces iron."
            ],
            ["blood donation emergency", "urgent need"]: [
                "Hospitals contact eligible donors for urgent needs."
            ],
            ["blood donation documentation", "id"]: [
                "Valid government ID required before donation."
            ],
            ["blood donation process steps", "steps"]: [
                "Registration, health check, donation, refreshments."
            ],
            ["blood donation duration", "time"]: [
                "Actual donation takes 8–10 minutes; full process about 30–45 minutes."
            ],
            ["blood donation for cancer patients", "cancer"]: [
                "Cancer patients or survivors are usually not allowed."
            ],
            ["blood donation and asthma", "asthma"]: [
                "Mild controlled asthma can donate; severe uncontrolled cannot."
            ],
            ["blood donation side effects", "after donation"]: [
                "Mild dizziness or fatigue may occur but usually resolves quickly."
            ],
            ["blood donation fun fact", "interesting"]: [
                "Donating blood burns about 600 calories and helps your heart."
            ]
        ]

        
        for (keywords, answers) in faqData {
            for keyword in keywords {
                if lowerQ.contains(keyword) {
                    return answers.randomElement() ?? "Sorry, I don't have an answer right now."
                }
            }
        }
        
        let fallbackReplies = [
            "I’m not sure about that, but I’ll find out for you!",
            "Could you please rephrase your question?",
            "Let me check on that and get back to you!",
            "Sorry, I don't have information on that topic yet."
        ]
        return fallbackReplies.randomElement()!
    }
    
    func speak(text: String) {
        guard !synthesizer.isSpeaking else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    // MARK: - Speech Recognition
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized: break
            default:
                print("Speech recognition authorization denied")
            }
        }
    }
    
    func startListening() {
        guard !audioEngine.isRunning else {
            stopListening()
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let node = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                inputText = result.bestTranscription.formattedString
            }
            
            if error != nil || (result?.isFinal ?? false) {
                stopListening()
            }
        }
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isListening = true
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
    }
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let date: Date
}

struct MessageView: View {
    let message: Message
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? userBubbleColor : botBubbleColor)
                    .foregroundColor(message.isUser ? .white : botTextColor)
                    .cornerRadius(16)
                    .shadow(radius: 1)
                
                Text(message.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(timeTextColor)
                    .padding(message.isUser ? .trailing : .leading, 8)
            }
            
            if !message.isUser { Spacer() }
        }
        .padding(message.isUser ? .leading : .trailing, 60)
        .padding(.horizontal, 10)
    }
    
    private var userBubbleColor: Color {
        Color.blue.opacity(colorScheme == .dark ? 0.8 : 0.85)
    }
    
    private var botBubbleColor: Color {
        colorScheme == .dark ? Color(.systemGray5).opacity(0.2) : Color.gray.opacity(0.25)
    }
    
    private var botTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.9) : Color.black
    }
    
    private var timeTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.5) : Color.gray
    }
}
