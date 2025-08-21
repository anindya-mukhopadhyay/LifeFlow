import SwiftUI
import AVFoundation
import Speech

struct ChatbotFAQView: View {
    @State private var messages: [Message] = [
        Message(text: "Hi! I’m your blood donation assistant. How can I help you today?", isUser: false, date: Date())
    ]
    @State private var inputText: String = ""
    
    @State private var isListening = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
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
                    .onChange(of: messages.count) { _, _ in
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
                    isListening ? stopListening() : startListening()
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
        
        let faqData: [ [String] : [String] ] = [
            ["eligibility", "who can donate", "criteria", "requirements", "qualify"]: [
                "You must be at least 18 years old, weigh over 50kg, and be healthy to donate blood.",
                "Blood donors need to be 18+, weigh at least 50kg, and be in good health."
            ],// --- NEW 40 ADDITIONS ---
            
            // Greetings
            ["hi", "hello", "hey", "hlw", "namaste"]: [
                "Hello! How can I help you today?",
                "Hi there! Feel free to ask me about blood donation."
            ],

            // Goodbye
            ["bye", "goodbye", "see you", "take care"]: [
                "Goodbye! Stay healthy and consider donating blood again.",
                "See you later! Thanks for your interest in blood donation."
            ],

            // Age limit upper
            ["maximum age", "old age", "upper age limit"]: [
                "The maximum age for first-time donors is usually 60.",
                "Regular donors may be allowed up to 65 depending on health."
            ],

            // Repeat donors
            ["regular donor", "donate often", "donor again"]: [
                "Regular donors are encouraged as long as they meet criteria.",
                "You can donate multiple times with safe intervals."
            ],

            // First time donor
            ["first time", "new donor", "donating first"]: [
                "If it’s your first time, don’t worry, the process is simple and safe.",
                "First-time donors are guided by medical staff throughout."
            ],

            // Blood donation after tattoo
            ["tattoo", "tattoo donate", "piercing"]: [
                "You must wait at least 6 months after a tattoo or piercing.",
                "Tattoo or piercing requires a waiting period for safety."
            ],

            // Alcohol
            ["alcohol", "drink", "beer", "liquor"]: [
                "Do not drink alcohol 24 hours before donating.",
                "Alcohol in your system may disqualify you temporarily."
            ],

            // Smoking
            ["smoking", "cigarette", "smoke"]: [
                "Smoking is not an absolute ban, but avoid smoking before and after donation.",
                "It’s best to not smoke for at least 2 hours post-donation."
            ],

            // Pregnant women
            ["pregnant", "pregnancy", "expecting"]: [
                "Pregnant women should not donate blood.",
                "Donation is unsafe during pregnancy."
            ],

            // Breastfeeding
            ["breastfeeding", "lactating", "feeding mother"]: [
                "Women should wait until 6 months after delivery and stop breastfeeding.",
                "Breastfeeding mothers are advised not to donate."
            ],

            // Sleep
            ["sleep", "rest", "tired"]: [
                "Have at least 6 hours of sleep before donating.",
                "Being well-rested helps make donation safe."
            ],

            // Food before donation
            ["eat", "food", "diet before donation"]: [
                "Eat a healthy meal 2-3 hours before donating.",
                "Avoid oily or heavy foods before donation."
            ],

            // Water intake
            ["water", "drink water", "hydration"]: [
                "Drink plenty of water before and after donating.",
                "Hydration helps prevent dizziness."
            ],

            // After donation rest
            ["rest", "take rest", "sleep after donation"]: [
                "Rest for 10-15 minutes after donation before leaving.",
                "Don’t rush, relax a bit after donating."
            ],

            // Travel after donation
            ["travel", "long journey", "drive after donation"]: [
                "It’s safe to travel short distances after donation.",
                "Avoid long or exhausting journeys immediately after."
            ],

            // Fainting
            ["faint", "dizzy", "lightheaded"]: [
                "Some people may feel faint, but lying down helps.",
                "Dizziness is temporary and usually goes away quickly."
            ],

            // Blood pressure
            ["blood pressure", "bp", "high bp", "low bp"]: [
                "People with controlled blood pressure may donate.",
                "Very high or very low BP can disqualify donors temporarily."
            ],

            // Diabetes
            ["diabetes", "sugar", "blood sugar"]: [
                "Diabetics on insulin cannot donate blood.",
                "If controlled by diet or tablets, donation may be possible."
            ],

            // Cholesterol
            ["cholesterol", "lipids", "high cholesterol"]: [
                "High cholesterol is not a restriction if you are healthy.",
                "You may donate even with high cholesterol, if fit."
            ],

            // Allergy
            ["allergy", "asthma", "allergic"]: [
                "Mild allergies do not prevent donation.",
                "Severe asthma or allergy attacks may disqualify temporarily."
            ],

            // Period after delivery
            ["delivery", "postpartum", "childbirth"]: [
                "Wait at least 6 months after childbirth to donate.",
                "New mothers need recovery time before donating blood."
            ],

            // Platelet donation
            ["platelets", "donate platelets", "platelet donation"]: [
                "Platelet donation helps cancer and dengue patients.",
                "You can donate platelets every 2 weeks."
            ],

            // Plasma donation
            ["plasma", "donate plasma", "plasmapheresis"]: [
                "Plasma is separated from blood and can be donated frequently.",
                "Plasma donation supports patients with immunity problems."
            ],

            // Double red donation
            ["double red", "red cell donation", "two units red"]: [
                "Double red donation gives more red cells, less plasma.",
                "It requires special machines and longer recovery."
            ],

            // Pain during donation
            ["pain", "hurt", "does it hurt"]: [
                "The only pain is a small needle prick.",
                "Most donors say it feels like a mosquito bite."
            ],

            // Donation time
            ["time", "how long", "minutes"]: [
                "The donation itself takes 8-12 minutes.",
                "With registration and rest, the whole process is about 45 minutes."
            ],

            // Rare blood groups
            ["rare", "rare blood", "uncommon blood"]: [
                "AB negative is one of the rarest blood types.",
                "O negative is rare but highly in demand."
            ],

            // Blood for relatives
            ["relative", "family", "donate for father/mother"]: [
                "You can donate specifically for a family member.",
                "Replacement donation is common in hospitals."
            ],

            // Storage time
            ["storage", "how long blood stored", "expiry"]: [
                "Red cells last 35-42 days in storage.",
                "Platelets last only 5-7 days."
            ],

            // Free health check
            ["health check", "test before donation", "free test"]: [
                "Every donor gets a free health screening.",
                "Tests include blood pressure, hemoglobin, and infections."
            ],

            // Blood donation app
            ["app", "mobile app", "donation app"]: [
                "Many NGOs have apps to register and find camps.",
                "Apps help connect donors with recipients quickly."
            ],

            // Weight gain
            ["donation weight gain", "does donate make fat"]: [
                "Blood donation does not cause weight gain.",
                "It has no effect on body weight or fat."
            ],

            // Blood replacement
            ["replacement", "replace blood", "blood refill"]: [
                "Your body replaces donated blood within 48 hours.",
                "Red cells take about 2-3 months to fully regenerate."
            ],

            // Famous donors
            ["famous donors", "celebrities donate", "celebrities blood"]: [
                "Many celebrities encourage blood donation.",
                "Public figures inspire people to donate regularly."
            ],

            // Best time of day
            ["morning donate", "evening donate", "best time"]: [
                "Morning is considered the best time to donate.",
                "Donation can be done anytime, but mornings are preferred."
            ],

            // Donation and fitness
            ["gym", "workout", "exercise after donation"]: [
                "Avoid heavy exercise for 24 hours after donation.",
                "Light activities are fine, but no strenuous workouts."
            ],

            // Number of lives saved
            ["lives saved", "how many helped", "impact donation"]: [
                "One donation can save up to 3 lives.",
                "Each unit of blood is separated into components to help multiple patients."
            ],

            // Importance
            ["why donate", "importance", "benefits for others"]: [
                "Donating blood saves lives during emergencies.",
                "It helps patients of accidents, surgeries, and chronic illnesses."
            ],

            // Self-benefits
            ["benefits", "advantages", "good for health"]: [
                "Donation stimulates new blood cell production.",
                "Some studies suggest regular donation may improve heart health."
            ],

            ["interval", "gap", "how often", "frequency"]: [
                "The minimum gap between two blood donations is 3 months.",
                "You should wait at least 3 months between donations for your safety."
            ],
            ["thalassemia", "thalassemic", "genetic blood disorder"]: [
                "Thalassemia is a genetic blood disorder. People with severe thalassemia cannot donate blood.",
                "Individuals with severe thalassemia are not eligible to donate blood."
            ],
            ["thank", "thanks", "thank you"]: [
                "You’re welcome! If you have more questions, just ask.",
                "Glad I could help! Feel free to ask anything else."
            ],
            ["blood groups", "blood type", "types of blood"]: [
                "There are 8 main blood types: A+, A-, B+, B-, AB+, AB-, O+, and O-.",
                "Blood types include A, B, AB, and O, each with positive or negative Rh factor."
            ],
            ["donation process", "how to donate", "donation steps"]: [
                "You fill a health questionnaire, undergo a quick medical check, then donate blood in about 10 minutes.",
                "The process involves registration, health check, blood donation, and refreshments."
            ],
            ["side effects", "after donation", "post donation"]: [
                "Most donors feel fine after donation, but some might experience mild dizziness or fatigue.",
                "Common side effects can include slight weakness or bruising, but they usually go away quickly."
            ],
            ["emergency", "urgent", "immediate need"]: [
                "If there’s an urgent need for blood, hospitals will notify eligible donors directly.",
                "Emergency blood requests are prioritized and communicated swiftly."
            ],
        ]
        
        for (keywords, answers) in faqData {
            for keyword in keywords where lowerQ.contains(keyword) {
                return answers.randomElement() ?? "Sorry, I don't have an answer right now."
            }
        }
        
        return [
            "I’m not sure about that, but I’ll find out for you!",
            "Could you please rephrase your question?",
            "Let me check on that and get back to you!",
            "Sorry, I don't have information on that topic yet."
        ].randomElement()!
    }
    
    func speak(text: String) {
        guard !synthesizer.isSpeaking else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus != .authorized {
                print("Speech recognition authorization denied")
            }
        }
    }
    
    func startListening() {
        guard !audioEngine.isRunning else {
            stopListening()
            return
        }
        
        recognitionRequest?.endAudio()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                inputText = result.bestTranscription.formattedString
            }
            
            if error != nil || (result?.isFinal ?? false) {
                stopListening()
            }
        }
        
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
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
        recognitionRequest = nil
        recognitionTask = nil
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
