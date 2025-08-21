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
            ],// --- NEW 90 ADDITIONS ---
            
            // Blood donation basics
            ["who can donate", "eligible donor", "donor criteria"]: [
                "Anyone healthy, aged 18–60, and above 50 kg is usually eligible.",
                "Eligibility depends on medical history, weight, age, and hemoglobin."
            ],

            ["who cannot donate", "disqualified donor", "not eligible"]: [
                "People with HIV, hepatitis, or severe illness cannot donate.",
                "Pregnant women, underweight persons, and drug users are disqualified."
            ],

            ["donate without ID", "id proof required"]: [
                "Yes, ID is required for record and safety purposes.",
                "Carry Aadhaar, voter card, or any government-approved ID."
            ],

            // Cultural & social
            ["religion donate", "is blood donation against religion"]: [
                "No major religion prohibits blood donation.",
                "Many religious leaders encourage donation as an act of charity."
            ],

            ["blood donation in india", "rules india"]: [
                "India follows NACO & WHO guidelines for donation.",
                "Minimum gap is 90 days (men) and 120 days (women)."
            ],

            ["world blood donor day", "blood donor day"]: [
                "It is celebrated on 14 June every year.",
                "World Blood Donor Day honors voluntary donors worldwide."
            ],

            // Special situations
            ["donate during covid", "covid donor", "after covid"]: [
                "Wait 28 days after recovery from COVID-19 before donating.",
                "COVID-19 patients must be fully recovered and symptom-free."
            ],

            ["covid vaccine donation", "after vaccine", "donate after vaccination"]: [
                "You can donate blood 14 days after COVID vaccination.",
                "Some vaccines may need a short waiting period."
            ],

            ["fever", "cold", "flu"]: [
                "You cannot donate during fever or flu.",
                "Wait at least 7 days after recovery."
            ],

            ["typhoid", "malaria", "jaundice"]: [
                "After malaria, wait 3 months post-recovery.",
                "After jaundice/hepatitis, permanent deferral in most cases."
            ],

            // Female donors
            ["periods", "menstruation", "donate during periods"]: [
                "Not recommended during heavy flow or weakness.",
                "Better to wait until the menstrual cycle ends."
            ],

            ["menopause", "older women donate"]: [
                "Women up to age 60 can donate if healthy.",
                "Post-menopause is not a restriction if medically fit."
            ],

            // Technical
            ["universal donor", "o negative donor"]: [
                "O negative is called the universal donor for red cells.",
                "O negative donors are very important in emergencies."
            ],

            ["universal recipient", "ab positive"]: [
                "AB positive is universal recipient for red cells.",
                "They can receive blood from any group."
            ],

            ["cross matching", "blood compatibility test"]: [
                "Cross matching ensures donor and recipient blood are safe together.",
                "It prevents transfusion reactions."
            ],

            ["hemoglobin requirement", "hb level"]: [
                "Minimum Hb is 12.5 g/dL for women and 13 g/dL for men.",
                "Low Hb disqualifies a donor temporarily."
            ],

            // Donation types
            ["apheresis", "what is apheresis", "apheresis donation"]: [
                "Apheresis separates platelets/plasma and returns rest of blood.",
                "It helps patients needing specific components."
            ],

            ["cord blood", "umbilical cord blood"]: [
                "Cord blood is rich in stem cells and stored in banks.",
                "It is used for treating blood cancers and disorders."
            ],

            ["stem cell donation", "bone marrow donation"]: [
                "Stem cells are collected from blood or marrow for transplants.",
                "This is different from regular blood donation."
            ],

            // After donation
            ["donate and play sports", "sports after donation"]: [
                "Avoid intense sports for 24 hours.",
                "Light activities like walking are fine."
            ],

            ["donate and swimming", "swim after donation"]: [
                "Swimming immediately is not advised.",
                "Wait a few hours to avoid dizziness."
            ],

            ["donate and driving", "can i drive"]: [
                "You may drive after donation if you feel fine.",
                "Wait 10–15 mins and have a snack before driving."
            ],

            // Myths & misconceptions
            ["donation causes weakness", "feel weak"]: [
                "Temporary tiredness is possible, but rest and fluids help.",
                "The body recovers quickly after donation."
            ],

            ["donation causes infertility", "affect fertility"]: [
                "No, donating blood has no effect on fertility.",
                "This is a myth without scientific basis."
            ],

            ["donation shortens life", "lose years"]: [
                "No, donation does not reduce lifespan.",
                "It is safe and often linked to health benefits."
            ],

            ["donation makes thin", "weight loss"]: [
                "Donation does not affect body fat.",
                "Weight remains the same after donation."
            ],

            // Safety & procedure
            ["is it safe", "safe to donate"]: [
                "Yes, blood donation is completely safe.",
                "All needles and equipment are new and sterile."
            ],

            ["risk of infection", "get disease from donating"]: [
                "No, there is zero risk of infection for donors.",
                "Strict hygiene standards are followed."
            ],

            ["needle size", "big needle"]: [
                "A small sterile needle is used, just a mild prick.",
                "The pain is minimal and lasts seconds."
            ],

            ["how much blood taken", "ml taken"]: [
                "About 350–450 ml is collected per donation.",
                "This is less than 10% of your total blood volume."
            ],

            // Blood demand
            ["who needs blood", "patients needing blood"]: [
                "Patients of accidents, surgeries, and anemia need blood.",
                "Cancer, thalassemia, and trauma patients often require it."
            ],

            ["blood shortage", "need donors"]: [
                "Hospitals often face shortage of rare groups.",
                "Voluntary donors help prevent shortages."
            ],

            ["blood camp", "where to donate"]: [
                "Blood donation camps are held by NGOs and hospitals.",
                "Check online or nearby hospitals for donation drives."
            ],

            // Student/young donors
            ["college donation", "student donor"]: [
                "Students above 18 can donate safely.",
                "Youth are encouraged to donate as voluntary donors."
            ],

            ["first year college", "donate as fresher"]: [
                "If 18 years old and above 50 kg, yes.",
                "Many colleges host first-time donor camps."
            ],

            // Advanced science
            ["artificial blood", "synthetic blood"]: [
                "Research is ongoing, but no complete substitute exists.",
                "Artificial blood is not yet widely available."
            ],

            ["blood transfusion reaction", "reaction risk"]: [
                "Reactions are rare but possible if mismatch occurs.",
                "Cross-matching minimizes risk."
            ],

            ["frozen blood", "cryopreservation"]: [
                "Some blood can be frozen for years.",
                "Rare groups are stored in frozen form."
            ],

            // Regional / cultural
            ["donate in summer", "hot weather donation"]: [
                "Yes, but drink extra water to avoid dehydration.",
                "Donation in summer is safe with hydration."
            ],

            ["donate in winter", "cold weather donation"]: [
                "Winter is also safe, no restriction.",
                "Keep yourself warm before and after donation."
            ],

            ["festival donation", "special camps"]: [
                "Many camps are organized during festivals.",
                "Donating in festive drives increases participation."
            ],

            // Medical
            ["blood cancer", "donate if cancer"]: [
                "People with active cancer cannot donate.",
                "Cancer survivors may donate if fully cured and cleared."
            ],

            ["heart patient", "heart disease donate"]: [
                "Heart patients are not allowed to donate.",
                "Donation may stress the cardiovascular system."
            ],

            ["thyroid patient", "thyroid problem"]: [
                "Controlled thyroid patients may donate.",
                "Check with your doctor if on heavy medication."
            ],
                // 1
                ["How many types of blood groups are there?"]: [
                    "There are 8 main blood groups: A+, A-, B+, B-, AB+, AB-, O+, and O-.",
                    "Blood groups are based on antigens A, B, AB, or O and Rh factor (positive or negative)."
                ],
                // 2
                ["Which blood group is the rarest?"]: [
                    "AB negative is the rarest blood group in the world.",
                    "Only about 1% of people have AB- blood."
                ],
                // 3
                ["Which blood group is the most common?"]: [
                    "O positive is the most common blood group.",
                    "About 37% of the population worldwide has O+."
                ],
                // 4
                ["Who can donate blood?"]: [
                    "Any healthy person aged 18–65 years, weighing at least 50kg, can donate blood.",
                    "Donors must be free from infections and in good health."
                ],
                // 5
                ["Who cannot donate blood?"]: [
                    "People with infections, chronic diseases, or low body weight cannot donate.",
                    "Pregnant women and HIV positive individuals cannot donate blood."
                ],
                // 6
                ["How much blood is taken in one donation?"]: [
                    "About 350–450ml of blood is collected in one donation.",
                    "This amount is safe and your body replenishes it quickly."
                ],
                // 7
                ["How often can a person donate blood?"]: [
                    "Men can donate every 3 months, women every 4 months.",
                    "A minimum gap of 12 weeks is recommended between donations."
                ],
                // 8
                ["Is blood donation painful?"]: [
                    "Only a small pinprick is felt when the needle is inserted.",
                    "Most donors say the process is almost painless."
                ],
                // 9
                ["Can I donate blood during my periods?"]: [
                    "It’s not recommended to donate during menstruation due to weakness.",
                    "Wait until your cycle ends before donating."
                ],
                // 10
                ["Can a diabetic person donate blood?"]: [
                    "Yes, if their sugar is controlled and they aren’t insulin-dependent.",
                    "Diabetics on oral medication can usually donate."
                ],
                // 11
                ["Can I donate if I have high blood pressure?"]: [
                    "Yes, if your blood pressure is under control with medication.",
                    "Controlled hypertension is not a barrier to donating."
                ],
                // 12
                ["Can smokers donate blood?"]: [
                    "Yes, but avoid smoking at least 2 hours before and after donation.",
                    "Smoking does not disqualify you, but breaks are necessary."
                ],
                // 13
                ["Can alcohol drinkers donate blood?"]: [
                    "No, you should avoid alcohol for at least 24 hours before donation.",
                    "Alcohol in your blood can make you ineligible temporarily."
                ],
                // 14
                ["What should I eat before donating blood?"]: [
                    "Eat a light meal and drink water before donation.",
                    "Avoid oily or fatty foods before donating blood."
                ],
                // 15
                ["What should I do after donating blood?"]: [
                    "Rest for 10–15 minutes and drink fluids.",
                    "Avoid heavy exercise for the next 24 hours."
                ],
                // 16
                ["How long does it take to donate blood?"]: [
                    "The actual donation takes 8–10 minutes.",
                    "Including rest, the full process takes about 30–45 minutes."
                ],
                // 17
                ["Is blood donation safe?"]: [
                    "Yes, it’s completely safe with sterile disposable needles.",
                    "There is no risk of infection from donating blood."
                ],
                // 18
                ["How often can plasma be donated?"]: [
                    "Plasma can be donated every 2 weeks.",
                    "Unlike whole blood, plasma regenerates faster."
                ],
                // 19
                ["What is the shelf life of donated blood?"]: [
                    "Red blood cells last up to 42 days in storage.",
                    "Plasma can be frozen and stored for up to one year."
                ],
                // 20
                ["Who can receive O negative blood?"]: [
                    "O negative is the universal donor for emergencies.",
                    "Anyone can receive O- blood when type is unknown."
                ],
                // 21
                ["Who can receive AB positive blood?"]: [
                    "AB+ is the universal recipient blood group.",
                    "People with AB+ can receive blood from all groups."
                ],
                // 22
                ["Can pregnant women donate blood?"]: [
                    "No, pregnant women are not allowed to donate.",
                    "Pregnancy disqualifies you from blood donation."
                ],
                // 23
                ["Can I donate if I have a tattoo?"]: [
                    "Yes, but only after 6–12 months of getting a tattoo.",
                    "Fresh tattoos increase infection risk, so waiting is necessary."
                ],
                // 24
                ["Can cancer survivors donate blood?"]: [
                    "Cancer patients and survivors are usually not allowed.",
                    "Active or past cancer disqualifies blood donation."
                ],
                // 25
                ["What are the benefits of blood donation?"]: [
                    "It saves lives and helps maintain your heart health.",
                    "Donating reduces excess iron and gives a free health check."
                ],
                // 26
                ["Can I donate blood if I am underweight?"]: [
                    "No, you must weigh at least 50kg to donate.",
                    "Low weight can cause health risks while donating."
                ],
                // 27
                ["What diseases prevent blood donation?"]: [
                    "HIV, hepatitis, cancer, and heart disease prevent donation.",
                    "Chronic illnesses make you ineligible to donate."
                ],
                // 28
                ["How soon after COVID-19 can I donate blood?"]: [
                    "You can donate 14 days after recovery from COVID-19.",
                    "Wait at least 2 weeks post-symptoms before donating."
                ],
                // 29
                ["Can I donate if I had malaria?"]: [
                    "You must wait 3 months after recovering from malaria.",
                    "Malaria history temporarily disqualifies donation."
                ],
                // 30
                ["How much time does the body take to recover after donation?"]: [
                    "Plasma and fluids recover in 24–48 hours.",
                    "Red cells may take a few weeks to fully recover."
                ],
                // 31
                ["What is platelet donation?"]: [
                    "Platelet donation helps cancer and dengue patients.",
                    "It takes about 1.5–2 hours and can be done every 2 weeks."
                ],
                // 32
                ["What is plasma donation?"]: [
                    "Plasma donation helps burn and clotting disorder patients.",
                    "Plasma can be donated every 2 weeks safely."
                ],
                // 33
                ["Can I donate if I have anemia?"]: [
                    "No, anemic people are not allowed to donate blood.",
                    "Low hemoglobin disqualifies blood donation."
                ],
                // 34
                ["Can I donate blood if I am on antibiotics?"]: [
                    "No, wait until the infection is gone and antibiotics are completed.",
                    "You can donate only when you are fully recovered."
                ],
                // 35
                ["How old do you have to be to donate blood?"]: [
                    "You must be at least 18 years old to donate.",
                    "Blood donation is allowed from 18 to 65 years."
                ],
                // 36
                ["Can vegetarians donate blood?"]: [
                    "Yes, vegetarians can donate blood if healthy.",
                    "Diet type doesn’t affect eligibility as long as hemoglobin is normal."
                ],
                // 37
                ["Can blood be sold?"]: [
                    "No, selling or buying blood is illegal.",
                    "Blood donation is always voluntary and unpaid."
                ],
                // 38
                ["Why is blood donation important?"]: [
                    "It saves lives in emergencies, surgeries, and illnesses.",
                    "Blood cannot be manufactured, so donations are essential."
                ],
                // 39
                ["What documents are required to donate blood?"]: [
                    "You need an ID proof like Aadhaar or driving license.",
                    "Basic identification is needed before donation."
                ],
                // 40
                ["How long should I rest after donating blood?"]: [
                    "Rest at least 10–15 minutes after donation.",
                    "Avoid strenuous work for the next 24 hours."
                ],
                // 41
                ["Can blood donation help the donor?"]: [
                    "Yes, it reduces iron overload and improves heart health.",
                    "It may lower cancer risk and keeps you healthy."
                ],
                // 42
                ["Can someone donate blood after surgery?"]: [
                    "Yes, but only after 6–12 months of recovery depending on surgery type.",
                    "Consult a doctor before donating post-surgery."
                ],
                // 43
                ["Can a person with asthma donate blood?"]: [
                    "Yes, if asthma is mild and under control.",
                    "Severe or uncontrolled asthma may prevent donation."
                ],
                // 44
                ["How many calories are burned by donating blood?"]: [
                    "Donating blood burns about 600 calories.",
                    "It’s like a mild workout for your body."
                ],
                // 45
                ["Can a breastfeeding mother donate blood?"]: [
                    "No, breastfeeding mothers are not allowed to donate.",
                    "Wait until you have stopped breastfeeding before donating."
                ],
                // 46
                ["What is universal donor blood group?"]: [
                    "O negative is the universal donor blood type.",
                    "It can be given to anyone in emergencies."
                ],
                // 47
                ["What is universal recipient blood group?"]: [
                    "AB positive is the universal recipient group.",
                    "AB+ people can receive blood from all groups."
                ],
                // 48
                ["Can I donate if I have jaundice history?"]: [
                    "No, people with hepatitis-related jaundice cannot donate.",
                    "Past jaundice due to hepatitis disqualifies you."
                ],
                // 49
                ["Can I donate if I am on medication?"]: [
                    "Some medicines are fine, but check with the doctor first.",
                    "Certain drugs may delay or prevent blood donation."
                ],
                // 50
                ["How is donated blood tested?"]: [
                    "Every unit is tested for HIV, Hepatitis B, Hepatitis C, Malaria, and Syphilis.",
                    "Blood is carefully screened to ensure safety before transfusion."
                ],

            ["epilepsy", "fits", "seizures"]: [
                "Epilepsy patients are usually deferred.",
                "Uncontrolled seizures prevent safe donation."
            ],

            // Fun facts & awareness
            ["fastest recovery", "recover quickly"]: [
                "Hydration and iron-rich foods speed recovery.",
                "Most donors feel normal within a day."
            ],

            ["blood bank meaning", "what is blood bank"]: [
                "A blood bank stores and supplies blood for patients.",
                "It also separates blood into components."
            ],

            ["iron after donation", "iron loss"]: [
                "Each donation removes about 200–250 mg of iron.",
                "Eat iron-rich food like spinach and meat afterwards."
            ],

            ["oldest donor", "world record donor age"]: [
                "Many countries report donors above 90 years old.",
                "Guinness records mention people with 100+ donations."
            ],

            ["largest blood camp", "world record blood donation"]: [
                "India has hosted camps with thousands of donors.",
                "World records include camps with 30,000+ units collected."
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
