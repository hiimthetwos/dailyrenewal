import Foundation

// MARK: - Bible Version System

enum BibleVersion: String, CaseIterable, Identifiable {
    case kjv = "KJV"
    case esv = "ESV"
    case nasb95 = "NASB95"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .kjv: return "King James Version"
        case .esv: return "English Standard Version"
        case .nasb95: return "New American Standard Bible 1995"
        }
    }
}

struct ScriptureVerse: Identifiable, Hashable {
    let id: String          // e.g. "1COR10:13"
    let reference: String   // e.g. "1 Corinthians 10:13"
    let theme: ScriptureTheme

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: ScriptureVerse, rhs: ScriptureVerse) -> Bool { lhs.id == rhs.id }
}

struct Scripture: Identifiable, Hashable {
    let verse: ScriptureVerse
    let text: String
    let version: BibleVersion
    
    var id: String { verse.id }
    var reference: String { verse.reference }
    var theme: ScriptureTheme { verse.theme }

    func hash(into hasher: inout Hasher) { 
        hasher.combine(verse.id)
        hasher.combine(version)
    }
    static func == (lhs: Scripture, rhs: Scripture) -> Bool { 
        lhs.verse.id == rhs.verse.id && lhs.version == rhs.version 
    }
}

enum ScriptureTheme: String, CaseIterable, Identifiable {
    case resistingTemptation       = "Resisting Temptation"
    case graceAndForgiveness       = "Grace & Forgiveness"
    case strengthAndEndurance      = "Strength & Endurance"
    case renewalAndTransformation  = "Renewal & Transformation"
    case identityInChrist          = "Identity in Christ"
    case prayerAndSurrender        = "Prayer & Surrender"
    case fellowshipAndAccountability = "Fellowship & Accountability"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .resistingTemptation:        return "shield.lefthalf.filled"
        case .graceAndForgiveness:        return "heart.fill"
        case .strengthAndEndurance:       return "mountain.2.fill"
        case .renewalAndTransformation:   return "arrow.triangle.2.circlepath"
        case .identityInChrist:           return "person.fill.checkmark"
        case .prayerAndSurrender:         return "hands.sparkles.fill"
        case .fellowshipAndAccountability: return "person.2.fill"
        }
    }
}

enum ScriptureLibrary {
    static let allVerses: [ScriptureVerse] =
        resistingTemptationVerses +
        graceAndForgivenessVerses +
        strengthAndEnduranceVerses +
        renewalAndTransformationVerses +
        identityInChristVerses +
        prayerAndSurrenderVerses +
        fellowshipAndAccountabilityVerses

    static func verse(for key: String) -> ScriptureVerse? {
        allVerses.first { $0.id == key }
    }
    
    static func scripture(for key: String, version: BibleVersion = .kjv) -> Scripture? {
        guard let verse = verse(for: key) else { return nil }
        
        let text: String
        switch version {
        case .kjv:
            text = KJVTexts.text(for: key) ?? ""
        case .esv:
            text = ESVTexts.text(for: key) ?? ""
        case .nasb95:
            text = NASB95Texts.text(for: key) ?? ""
        }
        
        return Scripture(verse: verse, text: text, version: version)
    }

    /// Deterministic daily rotation — same verse all day, no persistence needed.
    static func dailyVerse(version: BibleVersion = .kjv) -> Scripture? {
        let epoch = Date(timeIntervalSince1970: 0)
        let day = Calendar.current.dateComponents([.day], from: epoch, to: .now).day ?? 0
        let verse = allVerses[day % allVerses.count]
        return scripture(for: verse.id, version: version)
    }

    static func verses(for theme: ScriptureTheme) -> [ScriptureVerse] {
        allVerses.filter { $0.theme == theme }
    }
    
    static func scriptures(for theme: ScriptureTheme, version: BibleVersion = .kjv) -> [Scripture] {
        verses(for: theme).compactMap { scripture(for: $0.id, version: version) }
    }

    // MARK: – Resisting Temptation (6)
    static let resistingTemptationVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "1COR10:13", reference: "1 Corinthians 10:13", theme: .resistingTemptation),
        ScriptureVerse(id: "JAM1:14-15", reference: "James 1:14–15", theme: .resistingTemptation),
        ScriptureVerse(id: "1PET5:8-9", reference: "1 Peter 5:8–9", theme: .resistingTemptation),
        ScriptureVerse(id: "HEB4:15-16", reference: "Hebrews 4:15–16", theme: .resistingTemptation),
        ScriptureVerse(id: "GAL5:16", reference: "Galatians 5:16", theme: .resistingTemptation),
        ScriptureVerse(id: "JOB31:1", reference: "Job 31:1", theme: .resistingTemptation),
    ]

    // MARK: – Grace & Forgiveness (7)
    static let graceAndForgivenessVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "1JN1:9", reference: "1 John 1:9", theme: .graceAndForgiveness),
        ScriptureVerse(id: "LAM3:22-23", reference: "Lamentations 3:22–23", theme: .graceAndForgiveness),
        ScriptureVerse(id: "PS51:10", reference: "Psalm 51:10", theme: .graceAndForgiveness),
        ScriptureVerse(id: "ROM5:8", reference: "Romans 5:8", theme: .graceAndForgiveness),
        ScriptureVerse(id: "EPH1:7", reference: "Ephesians 1:7", theme: .graceAndForgiveness),
        ScriptureVerse(id: "MIC7:18-19", reference: "Micah 7:18–19", theme: .graceAndForgiveness),
        ScriptureVerse(id: "PS103:12", reference: "Psalm 103:12", theme: .graceAndForgiveness),
    ]

    // MARK: – Strength & Endurance (6)
    static let strengthAndEnduranceVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "PHP4:13", reference: "Philippians 4:13", theme: .strengthAndEndurance),
        ScriptureVerse(id: "ISA40:31", reference: "Isaiah 40:31", theme: .strengthAndEndurance),
        ScriptureVerse(id: "PSA46:1", reference: "Psalm 46:1", theme: .strengthAndEndurance),
        ScriptureVerse(id: "2COR12:9", reference: "2 Corinthians 12:9", theme: .strengthAndEndurance),
        ScriptureVerse(id: "NEH8:10", reference: "Nehemiah 8:10", theme: .strengthAndEndurance),
        ScriptureVerse(id: "HEB12:1", reference: "Hebrews 12:1", theme: .strengthAndEndurance),
    ]

    // MARK: – Renewal & Transformation (6)
    static let renewalAndTransformationVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "ROM12:2", reference: "Romans 12:2", theme: .renewalAndTransformation),
        ScriptureVerse(id: "2COR5:17", reference: "2 Corinthians 5:17", theme: .renewalAndTransformation),
        ScriptureVerse(id: "ISA43:18-19", reference: "Isaiah 43:18–19", theme: .renewalAndTransformation),
        ScriptureVerse(id: "EZK36:26", reference: "Ezekiel 36:26", theme: .renewalAndTransformation),
        ScriptureVerse(id: "COL3:10", reference: "Colossians 3:10", theme: .renewalAndTransformation),
        ScriptureVerse(id: "TITUS3:5", reference: "Titus 3:5", theme: .renewalAndTransformation),
    ]

    // MARK: – Identity in Christ (5)
    static let identityInChristVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "GAL2:20", reference: "Galatians 2:20", theme: .identityInChrist),
        ScriptureVerse(id: "1COR6:19-20", reference: "1 Corinthians 6:19–20", theme: .identityInChrist),
        ScriptureVerse(id: "ROM8:1", reference: "Romans 8:1", theme: .identityInChrist),
        ScriptureVerse(id: "EPH2:10", reference: "Ephesians 2:10", theme: .identityInChrist),
        ScriptureVerse(id: "1PET2:9", reference: "1 Peter 2:9", theme: .identityInChrist),
    ]

    // MARK: – Prayer & Surrender (5)
    static let prayerAndSurrenderVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "PHP4:6-7", reference: "Philippians 4:6–7", theme: .prayerAndSurrender),
        ScriptureVerse(id: "MAT11:28-30", reference: "Matthew 11:28–30", theme: .prayerAndSurrender),
        ScriptureVerse(id: "1PET5:7", reference: "1 Peter 5:7", theme: .prayerAndSurrender),
        ScriptureVerse(id: "PS34:17-18", reference: "Psalm 34:17–18", theme: .prayerAndSurrender),
        ScriptureVerse(id: "ROM8:26", reference: "Romans 8:26", theme: .prayerAndSurrender),
    ]

    // MARK: – Fellowship & Accountability (5)
    static let fellowshipAndAccountabilityVerses: [ScriptureVerse] = [
        ScriptureVerse(id: "GAL6:1-2", reference: "Galatians 6:1–2", theme: .fellowshipAndAccountability),
        ScriptureVerse(id: "HEB10:24-25", reference: "Hebrews 10:24–25", theme: .fellowshipAndAccountability),
        ScriptureVerse(id: "PRO27:17", reference: "Proverbs 27:17", theme: .fellowshipAndAccountability),
        ScriptureVerse(id: "JAM5:16", reference: "James 5:16", theme: .fellowshipAndAccountability),
        ScriptureVerse(id: "ECL4:9-10", reference: "Ecclesiastes 4:9–10", theme: .fellowshipAndAccountability),
    ]
}

// MARK: - Bible Text Models

enum KJVTexts {
    static func text(for id: String) -> String? {
        texts[id]
    }
    
    private static let texts: [String: String] = [
        // Resisting Temptation
        "1COR10:13": "There hath no temptation taken you but such as is common to man: but God is faithful, who will not suffer you to be tempted above that ye are able; but will with the temptation also make a way to escape, that ye may be able to bear it.",
        "JAM1:14-15": "But every man is tempted, when he is drawn away of his own lust, and enticed. Then when lust hath conceived, it bringeth forth sin: and sin, when it is finished, bringeth forth death.",
        "1PET5:8-9": "Be sober, be vigilant; because your adversary the devil, as a roaring lion, walketh about, seeking whom he may devour: Whom resist stedfast in the faith, knowing that the same afflictions are accomplished in your brethren that are in the world.",
        "HEB4:15-16": "For we have not an high priest which cannot be touched with the feeling of our infirmities; but was in all points tempted like as we are, yet without sin. Let us therefore come boldly unto the throne of grace, that we may obtain mercy, and find grace to help in time of need.",
        "GAL5:16": "This I say then, Walk in the Spirit, and ye shall not fulfil the lust of the flesh.",
        "JOB31:1": "I made a covenant with mine eyes; why then should I think upon a maid?",
        
        // Grace & Forgiveness
        "1JN1:9": "If we confess our sins, he is faithful and just to forgive us our sins, and to cleanse us from all unrighteousness.",
        "LAM3:22-23": "It is of the LORD's mercies that we are not consumed, because his compassions fail not. They are new every morning: great is thy faithfulness.",
        "PS51:10": "Create in me a clean heart, O God; and renew a right spirit within me.",
        "ROM5:8": "But God commendeth his love toward us, in that, while we were yet sinners, Christ died for us.",
        "EPH1:7": "In whom we have redemption through his blood, the forgiveness of sins, according to the riches of his grace.",
        "MIC7:18-19": "Who is a God like unto thee, that pardoneth iniquity, and passeth by the transgression of the remnant of his heritage? he retaineth not his anger for ever, because he delighteth in mercy. He will turn again, he will have compassion upon us; he will subdue our iniquities; and thou wilt cast all their sins into the depths of the sea.",
        "PS103:12": "As far as the east is from the west, so far hath he removed our transgressions from us.",
        
        // Strength & Endurance
        "PHP4:13": "I can do all things through Christ which strengtheneth me.",
        "ISA40:31": "But they that wait upon the LORD shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint.",
        "PSA46:1": "God is our refuge and strength, a very present help in trouble.",
        "2COR12:9": "And he said unto me, My grace is sufficient for thee: for my strength is made perfect in weakness. Most gladly therefore will I rather glory in my infirmities, that the power of Christ may rest upon me.",
        "NEH8:10": "Then he said unto them, Go your way, eat the fat, and drink the sweet, and send portions unto them for whom nothing is prepared: for this day is holy unto our LORD: neither be ye sorry; for the joy of the LORD is your strength.",
        "HEB12:1": "Wherefore seeing we also are compassed about with so great a cloud of witnesses, let us lay aside every weight, and the sin which doth so easily beset us, and let us run with patience the race that is set before us.",
        
        // Renewal & Transformation
        "ROM12:2": "And be not conformed to this world: but be ye transformed by the renewing of your mind, that ye may prove what is that good, and acceptable, and perfect, will of God.",
        "2COR5:17": "Therefore if any man be in Christ, he is a new creature: old things are passed away; behold, all things are become new.",
        "ISA43:18-19": "Remember ye not the former things, neither consider the things of old. Behold, I will do a new thing; now it shall spring forth; shall ye not know it? I will even make a way in the wilderness, and rivers in the desert.",
        "EZK36:26": "A new heart also will I give you, and a new spirit will I put within you: and I will take away the stony heart out of your flesh, and I will give you an heart of flesh.",
        "COL3:10": "And have put on the new man, which is renewed in knowledge after the image of him that created him.",
        "TITUS3:5": "Not by works of righteousness which we have done, but according to his mercy he saved us, by the washing of regeneration, and renewing of the Holy Ghost.",
        
        // Identity in Christ
        "GAL2:20": "I am crucified with Christ: nevertheless I live; yet not I, but Christ liveth in me: and the life which I now live in the flesh I live by the faith of the Son of God, who loved me, and gave himself for me.",
        "1COR6:19-20": "What? know ye not that your body is the temple of the Holy Ghost which is in you, which ye have of God, and ye are not your own? For ye are bought with a price: therefore glorify God in your body, and in your spirit, which are God's.",
        "ROM8:1": "There is therefore now no condemnation to them which are in Christ Jesus, who walk not after the flesh, but after the Spirit.",
        "EPH2:10": "For we are his workmanship, created in Christ Jesus unto good works, which God hath before ordained that we should walk in them.",
        "1PET2:9": "But ye are a chosen generation, a royal priesthood, an holy nation, a peculiar people; that ye should shew forth the praises of him who hath called you out of darkness into his marvellous light.",
        
        // Prayer & Surrender
        "PHP4:6-7": "Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God. And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.",
        "MAT11:28-30": "Come unto me, all ye that labour and are heavy laden, and I will give you rest. Take my yoke upon you, and learn of me; for I am meek and lowly in heart: and ye shall find rest unto your souls. For my yoke is easy, and my burden is light.",
        "1PET5:7": "Casting all your care upon him; for he careth for you.",
        "PS34:17-18": "The righteous cry, and the LORD heareth, and delivereth them out of all their troubles. The LORD is nigh unto them that are of a broken heart; and saveth such as be of a contrite spirit.",
        "ROM8:26": "Likewise the Spirit also helpeth our infirmities: for we know not what we should pray for as we ought: but the Spirit itself maketh intercession for us with groanings which cannot be uttered.",
        
        // Fellowship & Accountability
        "GAL6:1-2": "Brethren, if a man be overtaken in a fault, ye which are spiritual, restore such an one in the spirit of meekness; considering thyself, lest thou also be tempted. Bear ye one another's burdens, and so fulfil the law of Christ.",
        "HEB10:24-25": "And let us consider one another to provoke unto love and to good works: Not forsaking the assembling of ourselves together, as the manner of some is; but exhorting one another: and so much the more, as ye see the day approaching.",
        "PRO27:17": "Iron sharpeneth iron; so a man sharpeneth the countenance of his friend.",
        "JAM5:16": "Confess your faults one to another, and pray one for another, that ye may be healed. The effectual fervent prayer of a righteous man availeth much.",
        "ECL4:9-10": "Two are better than one; because they have a good reward for their labour. For if they fall, the one will lift up his fellow: but woe to him that is alone when he falleth; for he hath not another to help him up."
    ]
}

enum ESVTexts {
    static func text(for id: String) -> String? {
        texts[id]
    }
    
    private static let texts: [String: String] = [
        // Resisting Temptation
        "1COR10:13": "No temptation has overtaken you that is not common to man. God is faithful, and he will not let you be tempted beyond your ability, but with the temptation he will also provide the way of escape, that you may be able to endure it.",
        "JAM1:14-15": "But each person is tempted when he is lured and enticed by his own desire. Then desire when it has conceived gives birth to sin, and sin when it is fully grown brings forth death.",
        "1PET5:8-9": "Be sober-minded; be watchful. Your adversary the devil prowls around like a roaring lion, seeking someone to devour. Resist him, firm in your faith, knowing that the same kinds of suffering are being experienced by your brotherhood throughout the world.",
        "HEB4:15-16": "For we do not have a high priest who is unable to sympathize with our weaknesses, but one who in every respect has been tempted as we are, yet without sin. Let us then with confidence draw near to the throne of grace, that we may receive mercy and find grace to help in time of need.",
        "GAL5:16": "But I say, walk by the Spirit, and you will not gratify the desires of the flesh.",
        "JOB31:1": "I have made a covenant with my eyes; how then could I gaze at a virgin?",
        
        // Grace & Forgiveness
        "1JN1:9": "If we confess our sins, he is faithful and just to forgive us our sins and to cleanse us from all unrighteousness.",
        "LAM3:22-23": "The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness.",
        "PS51:10": "Create in me a clean heart, O God, and renew a right spirit within me.",
        "ROM5:8": "But God shows his love for us in that while we were still sinners, Christ died for us.",
        "EPH1:7": "In him we have redemption through his blood, the forgiveness of our trespasses, according to the riches of his grace,",
        "MIC7:18-19": "Who is a God like you, pardoning iniquity and passing over transgression for the remnant of his inheritance? He does not retain his anger forever, because he delights in steadfast love. He will again have compassion on us; he will tread our iniquities underfoot. You will cast all our sins into the depths of the sea.",
        "PS103:12": "As far as the east is from the west, so far does he remove our transgressions from us.",
        
        // Strength & Endurance
        "PHP4:13": "I can do all things through him who strengthens me.",
        "ISA40:31": "But they who wait for the Lord shall renew their strength; they shall mount up with wings like eagles; they shall run and not be weary; they shall walk and not faint.",
        "PSA46:1": "God is our refuge and strength, a very present help in trouble.",
        "2COR12:9": "But he said to me, \"My grace is sufficient for you, for my power is made perfect in weakness.\" Therefore I will boast all the more gladly of my weaknesses, so that the power of Christ may rest upon me.",
        "NEH8:10": "Then he said to them, \"Go your way. Eat the fat and drink sweet wine and send portions to anyone who has nothing ready, for this day is holy to our Lord. And do not be grieved, for the joy of the Lord is your strength.\"",
        "HEB12:1": "Therefore, since we are surrounded by so great a cloud of witnesses, let us also lay aside every weight, and sin which clings so closely, and let us run with endurance the race that is set before us,",
        
        // Renewal & Transformation
        "ROM12:2": "Do not be conformed to this world, but be transformed by the renewal of your mind, that by testing you may discern what is the will of God, what is good and acceptable and perfect.",
        "2COR5:17": "Therefore, if anyone is in Christ, he is a new creation. The old has passed away; behold, the new has come.",
        "ISA43:18-19": "Remember not the former things, nor consider the things of old. Behold, I am doing a new thing; now it springs forth, do you not perceive it? I will make a way in the wilderness and rivers in the desert.",
        "EZK36:26": "And I will give you a new heart, and a new spirit I will put within you. And I will remove the heart of stone from your flesh and give you a heart of flesh.",
        "COL3:10": "And have put on the new self, which is being renewed in knowledge after the image of its creator.",
        "TITUS3:5": "He saved us, not because of works done by us in righteousness, but according to his own mercy, by the washing of regeneration and renewal of the Holy Spirit,",
        
        // Identity in Christ
        "GAL2:20": "I have been crucified with Christ. It is no longer I who live, but Christ who lives in me. And the life I now live in the flesh I live by faith in the Son of God, who loved me and gave himself for me.",
        "1COR6:19-20": "Or do you not know that your body is a temple of the Holy Spirit within you, whom you have from God? You are not your own, for you were bought with a price. So glorify God in your body.",
        "ROM8:1": "There is therefore now no condemnation for those who are in Christ Jesus.",
        "EPH2:10": "For we are his workmanship, created in Christ Jesus for good works, which God prepared beforehand, that we should walk in them.",
        "1PET2:9": "But you are a chosen race, a royal priesthood, a holy nation, a people for his own possession, that you may proclaim the excellencies of him who called you out of darkness into his marvelous light.",
        
        // Prayer & Surrender
        "PHP4:6-7": "Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all understanding, will guard your hearts and your minds in Christ Jesus.",
        "MAT11:28-30": "Come to me, all who labor and are heavy laden, and I will give you rest. Take my yoke upon you, and learn from me, for I am gentle and lowly in heart, and you will find rest for your souls. For my yoke is easy, and my burden is light.",
        "1PET5:7": "Casting all your anxieties on him, because he cares for you.",
        "PS34:17-18": "When the righteous cry for help, the Lord hears and delivers them out of all their troubles. The Lord is near to the brokenhearted and saves the crushed in spirit.",
        "ROM8:26": "Likewise the Spirit helps us in our weakness. For we do not know what to pray for as we ought, but the Spirit himself intercedes for us with groanings too deep for words.",
        
        // Fellowship & Accountability
        "GAL6:1-2": "Brothers, if anyone is caught in any transgression, you who are spiritual should restore him in a spirit of gentleness. Keep watch on yourself, lest you too be tempted. Bear one another's burdens, and so fulfill the law of Christ.",
        "HEB10:24-25": "And let us consider how to stir up one another to love and good works, not neglecting to meet together, as is the habit of some, but encouraging one another, and all the more as you see the Day drawing near.",
        "PRO27:17": "Iron sharpens iron, and one man sharpens another.",
        "JAM5:16": "Therefore, confess your sins to one another and pray for one another, that you may be healed. The prayer of a righteous person has great power as it is working.",
        "ECL4:9-10": "Two are better than one, because they have a good reward for their toil. For if they fall, one will lift up his fellow. But woe to him who is alone when he falls and has not another to lift him up!"
    ]
}

enum NASB95Texts {
    static func text(for id: String) -> String? {
        texts[id]
    }
    
    private static let texts: [String: String] = [
        // Resisting Temptation
        "1COR10:13": "No temptation has overtaken you but such as is common to man; and God is faithful, who will not allow you to be tempted beyond what you are able, but with the temptation will provide the way of escape also, so that you will be able to endure it.",
        "JAM1:14-15": "But each one is tempted when he is carried away and enticed by his own lust. Then when lust has conceived, it gives birth to sin; and when sin is accomplished, it brings forth death.",
        "1PET5:8-9": "Be of sober spirit, be on the alert. Your adversary, the devil, prowls around like a roaring lion, seeking someone to devour. But resist him, firm in your faith, knowing that the same experiences of suffering are being accomplished by your brethren who are in the world.",
        "HEB4:15-16": "For we do not have a high priest who cannot sympathize with our weaknesses, but One who has been tempted in all things as we are, yet without sin. Therefore let us draw near with confidence to the throne of grace, so that we may receive mercy and find grace to help in time of need.",
        "GAL5:16": "But I say, walk by the Spirit, and you will not carry out the desire of the flesh.",
        "JOB31:1": "I have made a covenant with my eyes; how then could I gaze at a virgin?",
        
        // Grace & Forgiveness
        "1JN1:9": "If we confess our sins, He is faithful and righteous to forgive us our sins and to cleanse us from all unrighteousness.",
        "LAM3:22-23": "The LORD'S lovingkindnesses indeed never cease, for His compassions never fail. They are new every morning; great is Your faithfulness.",
        "PS51:10": "Create in me a clean heart, O God, and renew a steadfast spirit within me.",
        "ROM5:8": "But God demonstrates His own love toward us, in that while we were yet sinners, Christ died for us.",
        "EPH1:7": "In Him we have redemption through His blood, the forgiveness of our trespasses, according to the riches of His grace",
        "MIC7:18-19": "Who is a God like You, who pardons iniquity and passes over the rebellious act of the remnant of His possession? He does not retain His anger forever, because He delights in unchanging love. He will again have compassion on us; He will tread our iniquities under foot. Yes, You will cast all their sins into the depths of the sea.",
        "PS103:12": "As far as the east is from the west, so far has He removed our transgressions from us.",
        
        // Strength & Endurance
        "PHP4:13": "I can do all things through Him who strengthens me.",
        "ISA40:31": "Yet those who wait for the LORD will gain new strength; they will mount up with wings like eagles, they will run and not get tired, they will walk and not become weary.",
        "PSA46:1": "God is our refuge and strength, a very present help in trouble.",
        "2COR12:9": "And He has said to me, \"My grace is sufficient for you, for power is perfected in weakness.\" Most gladly, therefore, I will rather boast about my weaknesses, so that the power of Christ may dwell in me.",
        "NEH8:10": "Then he said to them, \"Go, eat of the fat, drink of the sweet, and send portions to him who has nothing prepared; for this day is holy to our Lord. Do not be grieved, for the joy of the LORD is your strength.\"",
        "HEB12:1": "Therefore, since we have so great a cloud of witnesses surrounding us, let us also lay aside every encumbrance and the sin which so easily entangles us, and let us run with endurance the race that is set before us,",
        
        // Renewal & Transformation
        "ROM12:2": "And do not be conformed to this world, but be transformed by the renewing of your mind, so that you may prove what the will of God is, that which is good and acceptable and perfect.",
        "2COR5:17": "Therefore if anyone is in Christ, he is a new creature; the old things passed away; behold, new things have come.",
        "ISA43:18-19": "Do not call to mind the former things, or ponder things of the past. Behold, I will do something new, now it will spring forth; will you not be aware of it? I will even make a roadway in the wilderness, rivers in the desert.",
        "EZK36:26": "Moreover, I will give you a new heart and put a new spirit within you; and I will remove the heart of stone from your flesh and give you a heart of flesh.",
        "COL3:10": "And have put on the new self who is being renewed to a true knowledge according to the image of the One who created him—",
        "TITUS3:5": "He saved us, not on the basis of deeds which we have done in righteousness, but according to His mercy, by the washing of regeneration and renewing by the Holy Spirit,",
        
        // Identity in Christ
        "GAL2:20": "I have been crucified with Christ; and it is no longer I who live, but Christ lives in me; and the life which I now live in the flesh I live by faith in the Son of God, who loved me and gave Himself up for me.",
        "1COR6:19-20": "Or do you not know that your body is a temple of the Holy Spirit who is in you, whom you have from God, and that you are not your own? For you have been bought with a price: therefore glorify God in your body.",
        "ROM8:1": "Therefore there is now no condemnation for those who are in Christ Jesus.",
        "EPH2:10": "For we are His workmanship, created in Christ Jesus for good works, which God prepared beforehand so that we would walk in them.",
        "1PET2:9": "But you are a chosen race, a royal priesthood, a holy nation, a people for God's own possession, so that you may proclaim the excellencies of Him who has called you out of darkness into His marvelous light;",
        
        // Prayer & Surrender
        "PHP4:6-7": "Be anxious for nothing, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all comprehension, will guard your hearts and your minds in Christ Jesus.",
        "MAT11:28-30": "Come to Me, all who are weary and heavy-laden, and I will give you rest. Take My yoke upon you and learn from Me, for I am gentle and humble in heart, and you will find rest for your souls. For My yoke is easy and My burden is light.",
        "1PET5:7": "Casting all your anxiety on Him, because He cares for you.",
        "PS34:17-18": "The righteous cry, and the LORD hears and delivers them out of all their troubles. The LORD is near to the brokenhearted and saves those who are crushed in spirit.",
        "ROM8:26": "In the same way the Spirit also helps our weakness; for we do not know how to pray as we should, but the Spirit Himself intercedes for us with groanings too deep for words.",
        
        // Fellowship & Accountability
        "GAL6:1-2": "Brethren, even if anyone is caught in any trespass, you who are spiritual, restore such a one in a spirit of gentleness; each one looking to yourself, so that you too will not be tempted. Bear one another's burdens, and thereby fulfill the law of Christ.",
        "HEB10:24-25": "And let us consider how to stimulate one another to love and good deeds, not forsaking our own assembling together, as is the habit of some, but encouraging one another; and all the more as you see the day drawing near.",
        "PRO27:17": "Iron sharpens iron, so one man sharpens another.",
        "JAM5:16": "Therefore, confess your sins to one another, and pray for one another so that you may be healed. The effective prayer of a righteous man can accomplish much.",
        "ECL4:9-10": "Two are better than one because they have a good return for their labor. For if either of them falls, the one will lift up his companion. But woe to the one who falls when there is not another to lift him up."
    ]
}
