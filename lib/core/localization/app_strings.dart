/// App-wide string translations for English and Arabic.
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _translations = {
    // ─── General ─────────────────────────────────────────────
    'appTitle': {'en': 'Smart Care 360', 'ar': 'سمارت كير 360'},
    'home': {'en': 'Home', 'ar': 'الرئيسية'},
    'doctors': {'en': 'Doctors', 'ar': 'الأطباء'},
    'diagnosis': {'en': 'Diagnosis', 'ar': 'التشخيص'},
    'chat': {'en': 'Chat', 'ar': 'المحادثة'},
    'dashboard': {'en': 'Dashboard', 'ar': 'لوحة التحكم'},
    'booking': {'en': 'Booking', 'ar': 'الحجز'},
    'settings': {'en': 'Settings', 'ar': 'الإعدادات'},
    'language': {'en': 'العربية', 'ar': 'English'},
    'darkMode': {'en': 'Dark Mode', 'ar': 'الوضع الداكن'},
    'lightMode': {'en': 'Light Mode', 'ar': 'الوضع الفاتح'},

    // ─── Auth ────────────────────────────────────────────────
    'signIn': {'en': 'Sign In', 'ar': 'تسجيل الدخول'},
    'signUp': {'en': 'Create Account', 'ar': 'إنشاء حساب'},
    'signOut': {'en': 'Sign Out', 'ar': 'تسجيل الخروج'},
    'welcomeBack': {'en': 'Welcome Back', 'ar': 'مرحباً بعودتك'},
    'loginSubtitle': {
      'en': 'Sign in to access your secure medical dashboard',
      'ar': 'سجّل دخولك للوصول إلى لوحة التحكم الطبية الآمنة',
    },
    'registerTitle': {'en': 'Create Account', 'ar': 'إنشاء حساب'},
    'registerSubtitle': {
      'en': 'Join our community of over 50,000+ healthy users',
      'ar': 'انضم إلى مجتمعنا الذي يضم أكثر من 50,000 مستخدم صحي',
    },
    'email': {'en': 'Email Address', 'ar': 'البريد الإلكتروني'},
    'password': {'en': 'Password', 'ar': 'كلمة المرور'},
    'fullName': {'en': 'Full Name', 'ar': 'الاسم الكامل'},
    'phone': {'en': 'Phone', 'ar': 'الهاتف'},
    'age': {'en': 'Age', 'ar': 'العمر'},
    'gender': {'en': 'Gender', 'ar': 'الجنس'},
    'male': {'en': 'Male', 'ar': 'ذكر'},
    'female': {'en': 'Female', 'ar': 'أنثى'},
    'registerAs': {'en': 'Register As', 'ar': 'التسجيل كـ'},
    'patient': {'en': 'Patient', 'ar': 'مريض'},
    'doctor': {'en': 'Doctor', 'ar': 'طبيب'},
    'admin': {'en': 'Admin', 'ar': 'مدير'},
    'forgotPassword': {'en': 'Forgot Password?', 'ar': 'نسيت كلمة المرور؟'},
    'alreadyHaveAccount': {
      'en': 'Already have an account?',
      'ar': 'لديك حساب بالفعل؟',
    },
    'dontHaveAccount': {'en': "Don't have an account?", 'ar': 'ليس لديك حساب؟'},
    'backToHome': {'en': 'Back to Homepage', 'ar': 'العودة للصفحة الرئيسية'},
    'username': {'en': 'Username', 'ar': 'اسم المستخدم'},
    'rememberMe': {'en': 'Remember Me', 'ar': 'تذكرني'},

    // ─── Auth Visual Panel ───────────────────────────────────
    'secureEncryption': {'en': 'Secure Encryption', 'ar': 'تشفير آمن'},
    'aiHealthAnalysis': {
      'en': 'AI Health Analysis',
      'ar': 'تحليل صحي بالذكاء الاصطناعي',
    },
    'verifiedSpecialists': {
      'en': 'Verified Specialists',
      'ar': 'أطباء موثوقون',
    },
    'loginVisualTitle': {
      'en': 'Your Health, Our Priority',
      'ar': 'صحتك، أولويتنا',
    },
    'loginVisualSubtitle': {
      'en':
          'Access your secure medical dashboard with AI-powered diagnostics and expert consultations.',
      'ar':
          'ادخل إلى لوحة التحكم الطبية الآمنة مع التشخيص بالذكاء الاصطناعي والاستشارات المتخصصة.',
    },
    'registerVisualTitle': {
      'en': 'Join the Future of Health',
      'ar': 'انضم لمستقبل الصحة',
    },
    'registerVisualSubtitle': {
      'en':
          'Create your secure medical account today and get access to instant AI diagnostics and expert consultations.',
      'ar':
          'أنشئ حسابك الطبي الآمن اليوم واحصل على تشخيص فوري بالذكاء الاصطناعي واستشارات الخبراء.',
    },

    // ─── Home Page ───────────────────────────────────────────
    'heroTitle': {'en': 'Smart Medical Diagnosis with AI', 'ar': 'تشخيص طبي ذكي بالذكاء الاصطناعي'},
    'heroSubtitle': {
      'en': 'Your Integrated Platform for Smart Medical Care',
      'ar': 'منصتك المتكاملة للرعاية الطبية الذكية',
    },
    'heroDescription': {
      'en':
          'Upload your scans, get instant AI-powered preliminary diagnoses and connect with the best specialists — all in one place.',
      'ar':
          'ارفع صورك الطبية واحصل على تشخيص أولي فوري بالذكاء الاصطناعي وتواصل مع أفضل الأخصائيين — كل ذلك في مكان واحد.',
    },
    'startDiagnosis': {
      'en': 'Start Diagnosis',
      'ar': 'ابدأ التشخيص',
    },
    'findDoctor': {'en': 'Find a Doctor', 'ar': 'ابحث عن طبيب'},
    'everythingYouNeed': {'en': 'Everything You Need, In One Place', 'ar': 'كل ما تحتاجه في مكان واحد'},
    'everythingYouNeedDesc': {
      'en': 'From AI diagnosis to specialist booking — our platform covers your full healthcare journey.',
      'ar': 'من التشخيص بالذكاء الاصطناعي إلى حجز المواعيد مع الأخصائيين — منصتنا تغطي رحلتك الصحية بالكامل.',
    },
    'tryNow': {'en': 'Try Now', 'ar': 'جرب الآن'},
    'browse': {'en': 'Browse', 'ar': 'تصفح'},
    'chatNow': {'en': 'Chat Now', 'ar': 'دردش الآن'},
    'bookNow': {'en': 'Book Now', 'ar': 'احجز الآن'},
    'learnMore': {'en': 'Learn More', 'ar': 'اعرف المزيد'},
    'myDashboard': {'en': 'My Dashboard', 'ar': 'لوحة التحكم'},
    'howOurSystemWorks': {'en': 'How Our System Works', 'ar': 'كيف يعمل نظامنا'},
    'howOurSystemWorksDesc': {
      'en': 'Three simple steps to get your preliminary medical analysis in seconds.',
      'ar': 'ثلاث خطوات بسيطة للحصول على تحليل طبي أولي في ثوانٍ.',
    },
    'uploadYourScan': {'en': 'Upload Your Scan', 'ar': 'ارفع صورتك الطبية'},
    'uploadYourScanDesc': {
      'en': 'Upload your X-ray image or PDF medical report to our secure platform.',
      'ar': 'ارفع صورة الأشعة السينية أو التقرير الطبي PDF إلى منصتنا الآمنة.',
    },
    'aiAnalysis': {'en': 'AI Analysis', 'ar': 'التحليل بالذكاء الاصطناعي'},
    'aiAnalysisDesc': {
      'en': 'Our deep learning models scan and detect anomalies or conditions within seconds.',
      'ar': 'تقوم نماذج التعلم العميق لدينا بمسح واكتشاف الشذوذ أو الحالات في ثوانٍ.',
    },
    'getResultsBook': {'en': 'Get Results & Book', 'ar': 'احصل على النتائج واحجز'},
    'getResultsBookDesc': {
      'en': 'Receive a detailed report with confidence scores and book the right specialist instantly.',
      'ar': 'احصل على تقرير مفصل مع درجات الثقة واحجز الأخصائي المناسب فوراً.',
    },
    'comprehensiveMedicalServices': {'en': 'Comprehensive Medical Services', 'ar': 'خدمات طبية شاملة'},
    'readyToTakeControl': {'en': 'Ready to take control of your health?', 'ar': 'مستعد للسيطرة على صحتك؟'},
    'startFreeAnalysis': {'en': 'Start your free AI diagnosis today. No registration required for the first scan.', 'ar': 'ابدأ تشخيصك المجاني بالذكاء الاصطناعي اليوم. لا يتطلب التسجيل للمسح الأول.'},
    'startFreeAnalysisBtn': {'en': 'Start Free Analysis', 'ar': 'ابدأ التحليل المجاني'},
    'findSpecialist': {'en': 'Find a Specialist', 'ar': 'ابحث عن أخصائي'},
    'platformFeatures': {'en': 'Platform Features', 'ar': 'مميزات المنصة'},
    'featuresSubtitle': {
      'en': 'Everything you need for modern healthcare management',
      'ar': 'كل ما تحتاجه لإدارة الرعاية الصحية الحديثة',
    },
    'howItWorks': {'en': 'How It Works', 'ar': 'كيف يعمل'},
    'howItWorksSubtitle': {
      'en': 'Get started in minutes with our streamlined process',
      'ar': 'ابدأ في دقائق مع عمليتنا المبسطة',
    },
    'services': {'en': 'Our Medical Services', 'ar': 'خدماتنا الطبية'},
    'servicesSubtitle': {
      'en': 'Comprehensive healthcare powered by cutting-edge technology',
      'ar': 'رعاية صحية شاملة مدعومة بأحدث التقنيات',
    },
    'ctaTitle': {
      'en': 'Ready to Transform Your Healthcare?',
      'ar': 'مستعد لتحويل رعايتك الصحية؟',
    },
    'ctaSubtitle': {
      'en': 'Join thousands of users who trust Smart Care 360',
      'ar': 'انضم لآلاف المستخدمين الذين يثقون بسمارت كير 360',
    },
    'getStarted': {'en': 'Get Started Now', 'ar': 'ابدأ الآن'},

    // ─── Feature Cards ───────────────────────────────────────
    'aiDiagnosis': {'en': 'AI Diagnosis', 'ar': 'تشخيص بالذكاء الاصطناعي'},
    'aiDiagnosisDesc': {
      'en':
          'Upload X-rays or reports for instant AI-powered preliminary analysis of various conditions.',
      'ar':
          'ارفع الأشعة أو التقارير للحصول على تحليل أولي فوري بالذكاء الاصطناعي لمختلف الحالات.',
    },
    'expertDoctors': {'en': 'Expert Doctors', 'ar': 'أطباء خبراء'},
    'expertDoctorsDesc': {
      'en':
          'Connect with verified specialists based on your AI diagnosis results and book appointments instantly.',
      'ar':
          'تواصل مع أخصائيين موثوقين بناءً على نتائج تشخيص الذكاء الاصطناعي واحجز مواعيد فوراً.',
    },
    'smartChat': {'en': 'Smart Chat', 'ar': 'محادثة ذكية'},
    'smartChatDesc': {
      'en':
          'Chat with your doctor or ask our AI medical assistant for guidance anytime, anywhere.',
      'ar':
          'دردش مع طبيبك أو اسأل مساعدنا الطبي الذكي للحصول على إرشادات في أي وقت ومن أي مكان.',
    },
    'easyBooking': {'en': 'Easy Booking', 'ar': 'حجز سهل'},
    'easyBookingDesc': {
      'en':
          'Book, reschedule or cancel appointments with top specialists in just a few clicks.',
      'ar':
          'احجز أو أعد جدولة أو ألغِ المواعيد مع أفضل الأخصائيين في بضع نقرات فقط.',
    },
    'secureAndPrivate': {'en': 'Secure & Private', 'ar': 'آمن وخاص'},
    'secureAndPrivateDesc': {
      'en':
          'Your medical data is fully encrypted and protected. We follow strict medical privacy standards.',
      'ar':
          'بياناتك الطبية مشفرة بالكامل ومحمية. نحن نتبع معايير صارمة لخصوصية البيانات الطبية.',
    },
    'healthTracking': {'en': 'Health Tracking', 'ar': 'تتبع الصحة'},
    'healthTrackingDesc': {
      'en':
          'Monitor your diagnosis history, appointments, and health trends from your personal dashboard.',
      'ar':
          'راقب سجل تشخيصاتك ومواعيدك واتجاهات صحتك من لوحة التحكم الشخصية.',
    },

    // ─── Doctors Page ────────────────────────────────────────
    'findYourDoctor': {'en': 'Find Your Doctor', 'ar': 'ابحث عن طبيبك'},
    'doctorsSubtitle': {
      'en':
          'Connect with verified healthcare specialists from our extensive medical network.',
      'ar': 'تواصل مع أطباء متخصصين موثوقين من شبكتنا الطبية الواسعة.',
    },
    'searchDoctors': {
      'en': 'Search doctors by name...',
      'ar': 'ابحث عن طبيب بالاسم...',
    },
    'allSpecialties': {'en': 'All Specialties', 'ar': 'جميع التخصصات'},
    'yearsExp': {'en': 'Years Exp.', 'ar': 'سنوات الخبرة'},
    'specialty': {'en': 'Specialty', 'ar': 'التخصص'},
    'clinicAddress': {'en': 'Clinic Address', 'ar': 'عنوان العيادة'},

    // ─── Diagnosis Page ──────────────────────────────────────
    'aiMedicalDiagnosis': {
      'en': 'AI Medical Diagnosis',
      'ar': 'التشخيص الطبي بالذكاء الاصطناعي',
    },
    'diagnosisSubtitle': {
      'en':
          'Upload your medical scans for instant AI-powered analysis with detailed reports.',
      'ar':
          'ارفع فحوصاتك الطبية للتحليل الفوري بالذكاء الاصطناعي مع تقارير مفصلة.',
    },
    'selectScanType': {'en': 'Select Scan Type', 'ar': 'اختر نوع الفحص'},
    'boneFracture': {'en': 'Bone Fracture', 'ar': 'كسر عظام'},
    'boneFractureDesc': {
      'en': 'X-ray bone fracture detection',
      'ar': 'كشف كسور العظام بالأشعة',
    },
    'chestXRay': {'en': 'Chest X-Ray', 'ar': 'أشعة الصدر'},
    'chestXRayDesc': {
      'en': 'Pneumonia detection from chest X-rays',
      'ar': 'كشف الالتهاب الرئوي من أشعة الصدر',
    },
    'brainMRI': {'en': 'Brain MRI', 'ar': 'أشعة الدماغ'},
    'brainMRIDesc': {
      'en': 'Brain tumor classification',
      'ar': 'تصنيف أورام الدماغ',
    },
    'uploadScan': {'en': 'Upload Scan Image', 'ar': 'ارفع صورة الفحص'},
    'analyzing': {'en': 'Analyzing your scan...', 'ar': 'جاري تحليل الفحص...'},
    'results': {'en': 'Results', 'ar': 'النتائج'},
    'confidence': {'en': 'Confidence', 'ar': 'نسبة الثقة'},
    'detectedCondition': {'en': 'Detected Condition', 'ar': 'الحالة المكتشفة'},
    'recommendations': {'en': 'Recommendations', 'ar': 'التوصيات'},
    'newScan': {'en': 'New Scan', 'ar': 'فحص جديد'},

    // ─── Booking Page ────────────────────────────────────────
    'scheduleConsultation': {
      'en': 'Schedule a Consultation',
      'ar': 'حجز استشارة',
    },
    'bookingSubtitle': {
      'en':
          'Follow our simple multi-step process to book your visit with our specialists.',
      'ar': 'اتبع خطواتنا البسيطة لحجز زيارتك مع المتخصصين.',
    },
    'selectDoctor': {'en': 'Select Doctor', 'ar': 'اختر الطبيب'},
    'selectDate': {'en': 'Select Date', 'ar': 'اختر التاريخ'},
    'selectTime': {'en': 'Select Time Slot', 'ar': 'اختر الوقت'},
    'patientDetails': {'en': 'Patient Details', 'ar': 'بيانات المريض'},
    'patientName': {'en': 'Patient Name', 'ar': 'اسم المريض'},
    'patientPhone': {'en': 'Patient Phone', 'ar': 'هاتف المريض'},
    'medicalNotes': {'en': 'Medical Notes', 'ar': 'ملاحظات طبية'},
    'confirmation': {'en': 'Confirmation', 'ar': 'التأكيد'},
    'confirmBooking': {'en': 'Confirm Booking', 'ar': 'تأكيد الحجز'},
    'bookingSuccess': {
      'en': 'Appointment Booked Successfully!',
      'ar': 'تم حجز الموعد بنجاح!',
    },
    'next': {'en': 'Next', 'ar': 'التالي'},
    'previous': {'en': 'Previous', 'ar': 'السابق'},

    // ─── Chat Page ───────────────────────────────────────────
    'aiAssistant': {'en': 'AI Assistant', 'ar': 'مساعد الذكاء الاصطناعي'},
    'typeMessage': {'en': 'Type a message...', 'ar': 'اكتب رسالة...'},
    'contacts': {'en': 'Contacts', 'ar': 'جهات الاتصال'},
    'noMessages': {'en': 'No messages yet', 'ar': 'لا توجد رسائل بعد'},

    // ─── Dashboard ───────────────────────────────────────────
    'controlCenter': {'en': 'Control Center', 'ar': 'مركز التحكم'},
    'patientDashboard': {'en': 'Patient Dashboard', 'ar': 'لوحة تحكم المريض'},
    'doctorDashboard': {'en': 'Doctor Dashboard', 'ar': 'لوحة تحكم الطبيب'},
    'dashboardSubtitle': {
      'en':
          'Track your health journey with scan histories, upcoming consultations, and personalized insights.',
      'ar':
          'تابع رحلتك الصحية مع سجل الفحوصات والاستشارات القادمة والرؤى المخصصة.',
    },
    'doctorDashboardSubtitle': {
      'en': 'Manage your appointments and patient consultations',
      'ar': 'إدارة مواعيدك واستشارات المرضى',
    },
    'welcomeBackUser': {'en': 'Welcome back', 'ar': 'مرحباً بعودتك'},
    'aiScans': {'en': 'AI Scans', 'ar': 'فحوصات AI'},
    'appointments': {'en': 'Appointments', 'ar': 'المواعيد'},
    'upcoming': {'en': 'Upcoming', 'ar': 'القادمة'},
    'upcomingAppointments': {
      'en': 'Upcoming Appointments',
      'ar': 'المواعيد القادمة',
    },
    'noAppointments': {'en': 'No Appointments', 'ar': 'لا توجد مواعيد'},
    'noAppointmentsDesc': {
      'en': 'Book a consultation with a specialist from the Doctors page.',
      'ar': 'احجز استشارة مع متخصص من صفحة الأطباء.',
    },
    'recentScans': {'en': 'Recent Scan History', 'ar': 'سجل الفحوصات الأخيرة'},
    'noScans': {'en': 'No Scans Yet', 'ar': 'لا توجد فحوصات بعد'},
    'noScansDesc': {
      'en': 'Upload your first medical scan for AI analysis.',
      'ar': 'ارفع أول فحص طبي للتحليل بالذكاء الاصطناعي.',
    },
    'signInRequired': {
      'en': 'Please sign in to view your dashboard',
      'ar': 'يرجى تسجيل الدخول لعرض لوحة التحكم',
    },

    // ─── Footer ──────────────────────────────────────────────
    'footerTagline': {
      'en':
          'Advanced AI-powered healthcare platform for smart diagnosis and consultation.',
      'ar':
          'منصة رعاية صحية متقدمة مدعومة بالذكاء الاصطناعي للتشخيص والاستشارة الذكية.',
    },
    'quickLinks': {'en': 'Quick Links', 'ar': 'روابط سريعة'},
    'ourServices': {'en': 'Our Services', 'ar': 'خدماتنا'},
    'allRightsReserved': {
      'en': 'All rights reserved.',
      'ar': 'جميع الحقوق محفوظة.',
    },

    // ─── Booking Page (extended) ────────────────────────────────
    'appointmentBooking': {'en': 'Appointment Booking', 'ar': 'حجز موعد'},
    'chooseSpecialist': {
      'en': 'Choose Specialist & Schedule',
      'ar': 'اختر الطبيب والموعد',
    },
    'consultationDate': {'en': 'Consultation Date', 'ar': 'تاريخ الاستشارة'},
    'changeDate': {'en': 'Change Date', 'ar': 'تغيير التاريخ'},
    'availableSlots': {'en': 'Available Slots', 'ar': 'المواعيد المتاحة'},
    'continue_': {'en': 'Continue', 'ar': 'متابعة'},
    'personalInfo': {'en': 'Personal Information', 'ar': 'المعلومات الشخصية'},
    'patientFullName': {'en': 'Patient Full Name', 'ar': 'الاسم الكامل للمريض'},
    'contactPhone': {'en': 'Contact Phone', 'ar': 'هاتف التواصل'},
    'reasonForVisit': {
      'en': 'Reason for Visit / Medical Notes',
      'ar': 'سبب الزيارة / ملاحظات طبية',
    },
    'describeSymptoms': {
      'en': 'Briefly describe your symptoms...',
      'ar': 'صف أعراضك باختصار...',
    },
    'back': {'en': 'Back', 'ar': 'رجوع'},
    'summary': {'en': 'Summary', 'ar': 'ملخص'},
    'confirmAppointment': {'en': 'Confirm Appointment', 'ar': 'تأكيد الموعد'},
    'specialist': {'en': 'SPECIALIST', 'ar': 'الطبيب'},
    'schedule': {'en': 'SCHEDULE', 'ar': 'الموعد'},
    'patientDetailsLabel': {'en': 'PATIENT DETAILS', 'ar': 'بيانات المريض'},
    'name': {'en': 'Name', 'ar': 'الاسم'},
    'finalizeBooking': {'en': 'Finalize Booking', 'ar': 'إتمام الحجز'},
    'appointmentConfirmed': {
      'en': 'Appointment Confirmed!',
      'ar': 'تم تأكيد الموعد!',
    },
    'appointmentConfirmedDesc': {
      'en':
          'Your appointment has been successfully scheduled. You can view your upcoming appointments in your dashboard.',
      'ar': 'تم جدولة موعدك بنجاح. يمكنك عرض مواعيدك القادمة في لوحة التحكم.',
    },
    'viewDashboard': {'en': 'View Dashboard', 'ar': 'عرض لوحة التحكم'},
    'returnHome': {'en': 'Return to Homepage', 'ar': 'العودة للصفحة الرئيسية'},
    'pleaseSelectDoctor': {
      'en': 'Please select a doctor',
      'ar': 'يرجى اختيار طبيب',
    },
    'pleaseSelectSlot': {
      'en': 'Please select a time slot',
      'ar': 'يرجى اختيار وقت',
    },
    'chooseSpecialistHint': {
      'en': 'Choose a specialist...',
      'ar': 'اختر طبيباً...',
    },
    'stepSelect': {'en': 'Select', 'ar': 'اختيار'},
    'stepDetails': {'en': 'Details', 'ar': 'تفاصيل'},
    'stepConfirm': {'en': 'Confirm', 'ar': 'تأكيد'},

    // ─── Dashboard (extended) ────────────────────────────────────
    'newScanAction': {'en': 'New Scan', 'ar': 'فحص جديد'},
    'findDoctorAction': {'en': 'Find Doctor', 'ar': 'ابحث عن طبيب'},
    'aiChatAction': {'en': 'AI Chat', 'ar': 'محادثة AI'},

    // ─── Forgot Password ────────────────────────────────────────
    'resetPassword': {'en': 'Reset Password', 'ar': 'إعادة تعيين كلمة المرور'},
    'resetPasswordDesc': {
      'en': 'Enter your email address to receive a password reset link.',
      'ar': 'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور.',
    },
    'sendResetCode': {'en': 'Send Reset Code', 'ar': 'إرسال رمز التحقق'},
    'verifyOtp': {'en': 'Verify OTP', 'ar': 'التحقق من الرمز'},
    'verifyOtpDesc': {
      'en': 'Please enter the code sent to your email to verify your identity.',
      'ar': 'يرجى إدخال الرمز المرسل إلى بريدك الإلكتروني للتحقق من هويتك.',
    },
    'demoResetCode': {
      'en': 'Your demo reset code is: ',
      'ar': 'رمز التحقق التجريبي: ',
    },
    'verificationCode': {
      'en': '6-Digit Verification Code',
      'ar': 'رمز التحقق المكون من 6 أرقام',
    },
    'verifyCode': {'en': 'Verify Code', 'ar': 'تحقق من الرمز'},
    'newPassword': {'en': 'New Password', 'ar': 'كلمة المرور الجديدة'},
    'newPasswordDesc': {
      'en': 'Create a new, strong password to secure your account.',
      'ar': 'أنشئ كلمة مرور جديدة وقوية لتأمين حسابك.',
    },
    'confirmPassword': {'en': 'Confirm Password', 'ar': 'تأكيد كلمة المرور'},
    'passwordsNoMatch': {
      'en': 'Passwords do not match',
      'ar': 'كلمتا المرور غير متطابقتين',
    },
    'passwordResetSuccess': {
      'en': 'Password reset successfully! Please sign in.',
      'ar': 'تم إعادة تعيين كلمة المرور بنجاح! يرجى تسجيل الدخول.',
    },
    'rememberedPassword': {
      'en': 'Remembered your password? ',
      'ar': 'تذكرت كلمة المرور؟ ',
    },
    'forgotVisualTitle': {
      'en': 'Advanced Medical Intelligence',
      'ar': 'ذكاء طبي متقدم',
    },
    'forgotVisualSubtitle': {
      'en':
          'Empowering healthcare with state-of-the-art AI diagnostics and seamless patient-doctor connectivity.',
      'ar':
          'تمكين الرعاية الصحية بتشخيصات الذكاء الاصطناعي المتطورة والتواصل السلس بين المرضى والأطباء.',
    },
    'otpSentSuccess': {
      'en': 'OTP sent successfully to',
      'ar': 'تم إرسال رمز التحقق بنجاح إلى',
    },

    // Extra additions for complete page translations
    'smartAiMedicalPlatform': {
      'en': 'Smart AI Medical Platform',
      'ar': 'منصة الذكاء الاصطناعي الطبية الذكية',
    },
    'smartHealthcarePlatform': {
      'en': 'Smart Healthcare Platform',
      'ar': 'منصة الرعاية الصحية الذكية',
    },
    'featuresTitle': {
      'en': 'Everything You Need, In One Place',
      'ar': 'كل ما تحتاجه، في مكان واحد',
    },
    'featuresDescription': {
      'en':
          'From instant scan analysis to specialist booking — our platform covers your full healthcare journey.',
      'ar':
          'من التحليل الفوري للفحوصات إلى حجز المتخصصين — تغطي منصتنا رحلتك الصحية الكاملة.',
    },
    'scanAnalysis': {'en': 'Scan Analysis', 'ar': 'تحليل الفحوصات'},
    'scanAnalysisDesc': {
      'en':
          'Upload X-rays, ECGs or reports for instant preliminary analysis of various medical conditions.',
      'ar':
          'ارفع الأشعة السينية أو رسم القلب أو التقارير للتحليل الأولي الفوري لمختلف الحالات الطبية.',
    },
    'simpleProcess': {'en': 'Simple Process', 'ar': 'عملية بسيطة'},
    'howItWorksTitle': {'en': 'How Our System Works', 'ar': 'كيف يعمل نظامنا'},
    'processSubtitle': {
      'en':
          'Three simple steps to get your preliminary medical analysis in seconds.',
      'ar': 'ثلاث خطوات بسيطة للحصول على تحليلك الطبي الأولي في ثوانٍ.',
    },
    'step1Title': {'en': 'Upload Your Scan', 'ar': 'ارفع فحصك'},
    'step1Desc': {
      'en':
          'Upload your X-ray, ECG image, or PDF medical report to our secure platform.',
      'ar':
          'ارفع الأشعة السينية، أو صورة رسم القلب، أو تقريرك الطبي بصيغة PDF إلى منصتنا الآمنة.',
    },
    'step2Title': {'en': 'Smart Analysis', 'ar': 'تحليل ذكي'},
    'step2Desc': {
      'en':
          'Our analysis models scan and detect anomalies or conditions within seconds.',
      'ar':
          'تقوم نماذج التحليل لدينا بفحص وتحديد الحالات الشاذة أو المشاكل خلال ثوانٍ.',
    },
    'step3Title': {'en': 'Get Results & Book', 'ar': 'احصل على النتائج واحجز'},
    'step3Desc': {
      'en':
          'Receive a detailed report with confidence scores and book the right specialist instantly.',
      'ar': 'احصل على تقرير مفصل مع نسب الثقة واحجز مع المتخصص المناسب فوراً.',
    },
    'analysisTime': {'en': 'Analysis Time', 'ar': 'وقت التحليل'},
    'whatWeDetect': {'en': 'What We Detect', 'ar': 'ما نكتشفه'},
    'servicesTitle': {
      'en': 'Comprehensive Medical Services',
      'ar': 'خدمات طبية شاملة',
    },
    'boneFractureService': {
      'en': 'Bone Fracture Detection',
      'ar': 'كشف كسور العظام',
    },
    'heartDiseaseService': {
      'en': 'Heart Disease Analysis',
      'ar': 'تحليل أمراض القلب',
    },
    'brainTumorService': {
      'en': 'Brain Tumor Detection',
      'ar': 'كشف أورام الدماغ',
    },
    'reportAnalysisService': {
      'en': 'Report Analysis (PDF)',
      'ar': 'تحليل التقارير (PDF)',
    },
    'lungConditionService': {
      'en': 'Lung Condition Screening',
      'ar': 'فحص حالة الرئتين',
    },
    'ctaTitleHome': {
      'en': 'Ready to take control of your health?',
      'ar': 'هل أنت مستعد للتحكم في صحتك؟',
    },
    'ctaSubtitleHome': {
      'en':
          'Start your free analysis today. No registration required for the first scan.',
      'ar': 'ابدأ تحليلك المجاني اليوم. لا يلزم التسجيل للفحص الأول.',
    },
    'footerDesc': {
      'en':
          'Smart Care 360 is an advanced healthcare platform leveraging clinical technology to provide instant medical insights and connect patients with top specialists.',
      'ar':
          'سمارت كير 360 هي منصة رعاية صحية متقدمة تستخدم التكنولوجيا السريرية لتقديم رؤى طبية فورية وتوصيل المرضى بأفضل المتخصصين.',
    },
    'copyright': {
      'en': '© 2026 Smart Care 360. All rights reserved.',
      'ar': '© ٢٠٢٦ سمارت كير ٣٦٠. جميع الحقوق محفوظة.',
    },
    'selectConversationToStart': {
      'en': 'Select a conversation to start chatting',
      'ar': 'اختر محادثة لبدء الدردشة',
    },
    'aiIntelligentSummary': {
      'en': 'AI Intelligent Summary',
      'ar': 'ملخص ذكي بالذكاء الاصطناعي',
    },
    'aiSummary': {'en': 'AI Summary', 'ar': 'ملخص بالذكاء الاصطناعي'},
    'signInToRunDiagnosis': {
      'en': 'Please sign in to run an AI diagnosis',
      'ar': 'يرجى تسجيل الدخول لإجراء تشخيص بالذكاء الاصطناعي',
    },
    'selectExaminationType': {
      'en': 'Select Examination Type',
      'ar': 'اختر نوع الفحص',
    },
    'aiModelsTrainedHint': {
      'en':
          'Our AI models are specifically trained for these types of medical data.',
      'ar':
          'نماذج الذكاء الاصطناعي لدينا مدربة خصيصاً لهذه الأنواع من البيانات الطبية.',
    },
    'analyzeWithAi': {
      'en': 'Analyze with AI',
      'ar': 'تحليل بواسطة الذكاء الاصطناعي',
    },
    'detectingAnomaliesHint': {
      'en': 'Detecting anomalies and patterns using our neural networks.',
      'ar': 'جاري الكشف عن الحالات الشاذة والأنماط باستخدام شبكاتنا العصبية.',
    },
    'analysisResults': {'en': 'Analysis Results', 'ar': 'نتائج التحليل'},
    'aiDisclaimer': {
      'en':
          'Notice: This diagnosis is generated by an AI model as a preliminary check. It should NOT be considered a final medical diagnosis. Always consult a qualified physician.',
      'ar':
          'تنبيه: هذا التشخيص تم إنشاؤه بواسطة نموذج ذكاء اصطناعي كفحص أولي. لا ينبغي اعتباره تشخيصاً طبياً نهائياً. استشر دائماً طبيباً مؤهلاً.',
    },
    'signInToAccessSection': {
      'en': 'Please sign in to access this section',
      'ar': 'يرجى تسجيل الدخول للوصول إلى هذا القسم',
    },
    'online': {'en': 'Online', 'ar': 'متصل'},
    'offline': {'en': 'Offline', 'ar': 'غير متصل'},
    'typing': {'en': 'Typing...', 'ar': 'يكتب...'},

    // ─── Common / Shared ─────────────────────────────────────
    'retry': {'en': 'Retry', 'ar': 'إعادة المحاولة'},
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
    'save': {'en': 'Save', 'ar': 'حفظ'},
    'ok': {'en': 'OK', 'ar': 'حسناً'},
    'loading': {'en': 'Loading...', 'ar': 'جاري التحميل...'},
    'error': {'en': 'An error occurred', 'ar': 'حدث خطأ'},
    'noData': {'en': 'No data available', 'ar': 'لا توجد بيانات'},
    'success': {'en': 'Success', 'ar': 'نجاح'},

    // ─── Registration extras ─────────────────────────────────
    'welcomeUser': {'en': 'Welcome', 'ar': 'مرحباً'},
    'nationalIdCard': {'en': 'National ID Card', 'ar': 'بطاقة الهوية الوطنية'},
    'uploadNationalId': {
      'en': 'Upload National ID (PDF/Image)',
      'ar': 'ارفع بطاقة الهوية (PDF/صورة)',
    },
    'pleaseUploadId': {
      'en': 'Please upload your National ID Card',
      'ar': 'يرجى رفع بطاقة الهوية الوطنية',
    },
  };

  /// Get a translated string by key and locale code.
  static String get(String key, String locale) {
    return _translations[key]?[locale] ?? _translations[key]?['en'] ?? key;
  }
}
