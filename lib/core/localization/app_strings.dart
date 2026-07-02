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
    'alreadyHaveAccount': {'en': 'Already have an account?', 'ar': 'لديك حساب بالفعل؟'},
    'dontHaveAccount': {'en': "Don't have an account?", 'ar': 'ليس لديك حساب؟'},
    'backToHome': {'en': 'Back to Homepage', 'ar': 'العودة للصفحة الرئيسية'},
    'username': {'en': 'Username', 'ar': 'اسم المستخدم'},
    'rememberMe': {'en': 'Remember Me', 'ar': 'تذكرني'},

    // ─── Auth Visual Panel ───────────────────────────────────
    'secureEncryption': {'en': 'Secure Encryption', 'ar': 'تشفير آمن'},
    'aiHealthAnalysis': {'en': 'AI Health Analysis', 'ar': 'تحليل صحي بالذكاء الاصطناعي'},
    'verifiedSpecialists': {'en': 'Verified Specialists', 'ar': 'أطباء موثوقون'},
    'loginVisualTitle': {
      'en': 'Your Health, Our Priority',
      'ar': 'صحتك، أولويتنا',
    },
    'loginVisualSubtitle': {
      'en': 'Access your secure medical dashboard with AI-powered diagnostics and expert consultations.',
      'ar': 'ادخل إلى لوحة التحكم الطبية الآمنة مع التشخيص بالذكاء الاصطناعي والاستشارات المتخصصة.',
    },
    'registerVisualTitle': {
      'en': 'Join the Future of Health',
      'ar': 'انضم لمستقبل الصحة',
    },
    'registerVisualSubtitle': {
      'en': 'Create your secure medical account today and get access to instant AI diagnostics and expert consultations.',
      'ar': 'أنشئ حسابك الطبي الآمن اليوم واحصل على تشخيص فوري بالذكاء الاصطناعي واستشارات الخبراء.',
    },

    // ─── Home Page ───────────────────────────────────────────
    'heroTitle': {'en': 'Smart Care 360', 'ar': 'سمارت كير 360'},
    'heroSubtitle': {
      'en': 'Your Integrated Platform for Smart Medical Care',
      'ar': 'منصتك المتكاملة للرعاية الطبية الذكية',
    },
    'heroDescription': {
      'en': 'Revolutionizing healthcare with AI-powered diagnostics, expert doctor consultations, and seamless appointment booking — all in one modern platform.',
      'ar': 'نحدث ثورة في الرعاية الصحية بالتشخيص بالذكاء الاصطناعي واستشارات الأطباء المتخصصين وحجز المواعيد بسهولة — كل ذلك في منصة واحدة حديثة.',
    },
    'startDiagnosis': {'en': 'Start AI Diagnosis', 'ar': 'ابدأ التشخيص بالذكاء الاصطناعي'},
    'findDoctor': {'en': 'Find a Doctor', 'ar': 'ابحث عن طبيب'},
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
    'ctaTitle': {'en': 'Ready to Transform Your Healthcare?', 'ar': 'مستعد لتحويل رعايتك الصحية؟'},
    'ctaSubtitle': {
      'en': 'Join thousands of users who trust Smart Care 360',
      'ar': 'انضم لآلاف المستخدمين الذين يثقون بسمارت كير 360',
    },
    'getStarted': {'en': 'Get Started Now', 'ar': 'ابدأ الآن'},
    'learnMore': {'en': 'Learn More', 'ar': 'اعرف المزيد'},

    // ─── Feature Cards ───────────────────────────────────────
    'aiDiagnostics': {'en': 'AI Diagnostics', 'ar': 'تشخيص بالذكاء الاصطناعي'},
    'aiDiagnosticsDesc': {
      'en': 'Upload X-rays and MRIs for instant AI analysis with detailed medical reports.',
      'ar': 'ارفع الأشعة السينية والرنين المغناطيسي للتحليل الفوري بالذكاء الاصطناعي مع تقارير طبية مفصلة.',
    },
    'smartBooking': {'en': 'Smart Booking', 'ar': 'حجز ذكي'},
    'smartBookingDesc': {
      'en': 'Schedule appointments with specialists through our intelligent booking system.',
      'ar': 'احجز مواعيد مع المتخصصين من خلال نظام الحجز الذكي.',
    },
    'liveChat': {'en': 'Live Chat', 'ar': 'محادثة مباشرة'},
    'liveChatDesc': {
      'en': 'Communicate with doctors and our AI assistant in real-time.',
      'ar': 'تواصل مع الأطباء ومساعد الذكاء الاصطناعي في الوقت الفعلي.',
    },
    'secureRecords': {'en': 'Secure Records', 'ar': 'سجلات آمنة'},
    'secureRecordsDesc': {
      'en': 'Your medical data is encrypted and securely stored in the cloud.',
      'ar': 'بياناتك الطبية مشفرة ومخزنة بأمان في السحابة.',
    },

    // ─── Doctors Page ────────────────────────────────────────
    'findYourDoctor': {'en': 'Find Your Doctor', 'ar': 'ابحث عن طبيبك'},
    'doctorsSubtitle': {
      'en': 'Connect with verified healthcare specialists from our extensive medical network.',
      'ar': 'تواصل مع أطباء متخصصين موثوقين من شبكتنا الطبية الواسعة.',
    },
    'searchDoctors': {'en': 'Search doctors by name...', 'ar': 'ابحث عن طبيب بالاسم...'},
    'allSpecialties': {'en': 'All Specialties', 'ar': 'جميع التخصصات'},
    'bookNow': {'en': 'Book Now', 'ar': 'احجز الآن'},
    'yearsExp': {'en': 'Years Exp.', 'ar': 'سنوات الخبرة'},
    'specialty': {'en': 'Specialty', 'ar': 'التخصص'},
    'clinicAddress': {'en': 'Clinic Address', 'ar': 'عنوان العيادة'},

    // ─── Diagnosis Page ──────────────────────────────────────
    'aiMedicalDiagnosis': {'en': 'AI Medical Diagnosis', 'ar': 'التشخيص الطبي بالذكاء الاصطناعي'},
    'diagnosisSubtitle': {
      'en': 'Upload your medical scans for instant AI-powered analysis with detailed reports.',
      'ar': 'ارفع فحوصاتك الطبية للتحليل الفوري بالذكاء الاصطناعي مع تقارير مفصلة.',
    },
    'selectScanType': {'en': 'Select Scan Type', 'ar': 'اختر نوع الفحص'},
    'boneFracture': {'en': 'Bone Fracture', 'ar': 'كسر عظام'},
    'boneFractureDesc': {'en': 'X-ray bone fracture detection', 'ar': 'كشف كسور العظام بالأشعة'},
    'chestXRay': {'en': 'Chest X-Ray', 'ar': 'أشعة الصدر'},
    'chestXRayDesc': {'en': 'Pneumonia detection from chest X-rays', 'ar': 'كشف الالتهاب الرئوي من أشعة الصدر'},
    'brainMRI': {'en': 'Brain MRI', 'ar': 'أشعة الدماغ'},
    'brainMRIDesc': {'en': 'Brain tumor classification', 'ar': 'تصنيف أورام الدماغ'},
    'uploadScan': {'en': 'Upload Scan Image', 'ar': 'ارفع صورة الفحص'},
    'analyzing': {'en': 'Analyzing your scan...', 'ar': 'جاري تحليل الفحص...'},
    'results': {'en': 'Results', 'ar': 'النتائج'},
    'confidence': {'en': 'Confidence', 'ar': 'نسبة الثقة'},
    'detectedCondition': {'en': 'Detected Condition', 'ar': 'الحالة المكتشفة'},
    'recommendations': {'en': 'Recommendations', 'ar': 'التوصيات'},
    'newScan': {'en': 'New Scan', 'ar': 'فحص جديد'},

    // ─── Booking Page ────────────────────────────────────────
    'scheduleConsultation': {'en': 'Schedule a Consultation', 'ar': 'حجز استشارة'},
    'bookingSubtitle': {
      'en': 'Follow our simple multi-step process to book your visit with our specialists.',
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
    'bookingSuccess': {'en': 'Appointment Booked Successfully!', 'ar': 'تم حجز الموعد بنجاح!'},
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
    'dashboardSubtitle': {
      'en': 'Track your health journey with scan histories, upcoming consultations, and personalized insights.',
      'ar': 'تابع رحلتك الصحية مع سجل الفحوصات والاستشارات القادمة والرؤى المخصصة.',
    },
    'welcomeBackUser': {'en': 'Welcome back', 'ar': 'مرحباً بعودتك'},
    'aiScans': {'en': 'AI Scans', 'ar': 'فحوصات AI'},
    'appointments': {'en': 'Appointments', 'ar': 'المواعيد'},
    'upcoming': {'en': 'Upcoming', 'ar': 'القادمة'},
    'upcomingAppointments': {'en': 'Upcoming Appointments', 'ar': 'المواعيد القادمة'},
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
      'en': 'Advanced AI-powered healthcare platform for smart diagnosis and consultation.',
      'ar': 'منصة رعاية صحية متقدمة مدعومة بالذكاء الاصطناعي للتشخيص والاستشارة الذكية.',
    },
    'quickLinks': {'en': 'Quick Links', 'ar': 'روابط سريعة'},
    'ourServices': {'en': 'Our Services', 'ar': 'خدماتنا'},
    'allRightsReserved': {'en': 'All rights reserved.', 'ar': 'جميع الحقوق محفوظة.'},

    // ─── Booking Page (extended) ────────────────────────────────
    'appointmentBooking': {'en': 'Appointment Booking', 'ar': 'حجز موعد'},
    'chooseSpecialist': {'en': 'Choose Specialist & Schedule', 'ar': 'اختر الطبيب والموعد'},
    'consultationDate': {'en': 'Consultation Date', 'ar': 'تاريخ الاستشارة'},
    'changeDate': {'en': 'Change Date', 'ar': 'تغيير التاريخ'},
    'availableSlots': {'en': 'Available Slots', 'ar': 'المواعيد المتاحة'},
    'continue_': {'en': 'Continue', 'ar': 'متابعة'},
    'personalInfo': {'en': 'Personal Information', 'ar': 'المعلومات الشخصية'},
    'patientFullName': {'en': 'Patient Full Name', 'ar': 'الاسم الكامل للمريض'},
    'contactPhone': {'en': 'Contact Phone', 'ar': 'هاتف التواصل'},
    'reasonForVisit': {'en': 'Reason for Visit / Medical Notes', 'ar': 'سبب الزيارة / ملاحظات طبية'},
    'describeSymptoms': {'en': 'Briefly describe your symptoms...', 'ar': 'صف أعراضك باختصار...'},
    'back': {'en': 'Back', 'ar': 'رجوع'},
    'summary': {'en': 'Summary', 'ar': 'ملخص'},
    'confirmAppointment': {'en': 'Confirm Appointment', 'ar': 'تأكيد الموعد'},
    'specialist': {'en': 'SPECIALIST', 'ar': 'الطبيب'},
    'schedule': {'en': 'SCHEDULE', 'ar': 'الموعد'},
    'patientDetailsLabel': {'en': 'PATIENT DETAILS', 'ar': 'بيانات المريض'},
    'name': {'en': 'Name', 'ar': 'الاسم'},
    'finalizeBooking': {'en': 'Finalize Booking', 'ar': 'إتمام الحجز'},
    'appointmentConfirmed': {'en': 'Appointment Confirmed!', 'ar': 'تم تأكيد الموعد!'},
    'appointmentConfirmedDesc': {
      'en': 'Your appointment has been successfully scheduled. You can view your upcoming appointments in your dashboard.',
      'ar': 'تم جدولة موعدك بنجاح. يمكنك عرض مواعيدك القادمة في لوحة التحكم.',
    },
    'viewDashboard': {'en': 'View Dashboard', 'ar': 'عرض لوحة التحكم'},
    'returnHome': {'en': 'Return to Homepage', 'ar': 'العودة للصفحة الرئيسية'},
    'pleaseSelectDoctor': {'en': 'Please select a doctor', 'ar': 'يرجى اختيار طبيب'},
    'pleaseSelectSlot': {'en': 'Please select a time slot', 'ar': 'يرجى اختيار وقت'},
    'chooseSpecialistHint': {'en': 'Choose a specialist...', 'ar': 'اختر طبيباً...'},
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
    'demoResetCode': {'en': 'Your demo reset code is: ', 'ar': 'رمز التحقق التجريبي: '},
    'verificationCode': {'en': '6-Digit Verification Code', 'ar': 'رمز التحقق المكون من 6 أرقام'},
    'verifyCode': {'en': 'Verify Code', 'ar': 'تحقق من الرمز'},
    'newPassword': {'en': 'New Password', 'ar': 'كلمة المرور الجديدة'},
    'newPasswordDesc': {
      'en': 'Create a new, strong password to secure your account.',
      'ar': 'أنشئ كلمة مرور جديدة وقوية لتأمين حسابك.',
    },
    'confirmPassword': {'en': 'Confirm Password', 'ar': 'تأكيد كلمة المرور'},
    'passwordsNoMatch': {'en': 'Passwords do not match', 'ar': 'كلمتا المرور غير متطابقتين'},
    'passwordResetSuccess': {
      'en': 'Password reset successfully! Please sign in.',
      'ar': 'تم إعادة تعيين كلمة المرور بنجاح! يرجى تسجيل الدخول.',
    },
    'rememberedPassword': {'en': 'Remembered your password? ', 'ar': 'تذكرت كلمة المرور؟ '},
    'forgotVisualTitle': {'en': 'Advanced Medical Intelligence', 'ar': 'ذكاء طبي متقدم'},
    'forgotVisualSubtitle': {
      'en': 'Empowering healthcare with state-of-the-art AI diagnostics and seamless patient-doctor connectivity.',
      'ar': 'تمكين الرعاية الصحية بتشخيصات الذكاء الاصطناعي المتطورة والتواصل السلس بين المرضى والأطباء.',
    },
    'otpSentSuccess': {'en': 'OTP sent successfully to', 'ar': 'تم إرسال رمز التحقق بنجاح إلى'},

    // ─── Common / Shared ─────────────────────────────────────
    'retry': {'en': 'Retry', 'ar': 'إعادة المحاولة'},
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
    'save': {'en': 'Save', 'ar': 'حفظ'},
    'ok': {'en': 'OK', 'ar': 'حسناً'},
    'loading': {'en': 'Loading...', 'ar': 'جاري التحميل...'},
    'error': {'en': 'An error occurred', 'ar': 'حدث خطأ'},
    'noData': {'en': 'No data available', 'ar': 'لا توجد بيانات'},
    'success': {'en': 'Success', 'ar': 'نجاح'},
  };

  /// Get a translated string by key and locale code.
  static String get(String key, String locale) {
    return _translations[key]?[locale] ?? _translations[key]?['en'] ?? key;
  }
}
