import 'package:flutter/material.dart';

void main() {
  runApp(const ComplaintApp());
}

class ComplaintApp extends StatelessWidget {
  const ComplaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'অনলাইন অভিযোগ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF075985)),
        fontFamily: 'sans',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final pages = const [
    HomeTab(),
    ComplaintFormPage(),
    TrackPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'হোম',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'অভিযোগ',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'ট্র্যাক',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              'অনলাইন অভিযোগ কেন্দ্র',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'অপরাধের তথ্য নিরাপদে জমা দিন এবং অভিযোগের অগ্রগতি অনুসরণ করুন।',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 25),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.red.shade50,
                      child: const Icon(Icons.emergency, color: Colors.red),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('জরুরি বিপদে',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text('তাৎক্ষণিক সহায়তার জন্য ৯৯৯-এ যোগাযোগ করুন।'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('যেভাবে কাজ করবে',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _step(Icons.edit_document, '১', 'অভিযোগ লিখুন',
                'ঘটনার তথ্য ও প্রয়োজনীয় প্রমাণ দিন।'),
            _step(Icons.confirmation_number, '২', 'Complaint ID পান',
                'জমা দেওয়ার পর একটি ইউনিক আইডি পাবেন।'),
            _step(Icons.track_changes, '৩', 'অবস্থা দেখুন',
                'Complaint ID দিয়ে অভিযোগের অগ্রগতি দেখুন।'),
          ],
        ),
      ),
    );
  }

  Widget _step(IconData icon, String n, String title, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Text(n)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(text),
        trailing: Icon(icon),
      ),
    );
  }
}

class ComplaintFormPage extends StatefulWidget {
  const ComplaintFormPage({super.key});

  @override
  State<ComplaintFormPage> createState() => _ComplaintFormPageState();
}

class _ComplaintFormPageState extends State<ComplaintFormPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  final location = TextEditingController();
  final description = TextEditingController();

  String? crimeType;
  DateTime? incidentDate;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    location.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => incidentDate = picked);
  }

  void submit() {
    if (!formKey.currentState!.validate() || incidentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সব প্রয়োজনীয় তথ্য পূরণ করুন।')),
      );
      return;
    }

    final id =
        'CMP-${DateTime.now().year}-${100000 + DateTime.now().millisecondsSinceEpoch % 900000}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('অভিযোগ জমা হয়েছে'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 12),
            const Text('আপনার অভিযোগ সফলভাবে গ্রহণ করা হয়েছে।'),
            const SizedBox(height: 12),
            SelectableText(
              id,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text('এই Complaint ID সংরক্ষণ করুন।'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('অভিযোগ দাখিল',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('তারকা (*) চিহ্নিত ঘরগুলো পূরণ করা আবশ্যক।'),
            const SizedBox(height: 20),
            _field(name, 'পূর্ণ নাম *', 'আপনার নাম'),
            _field(phone, 'মোবাইল নম্বর *', '01XXXXXXXXX',
                keyboard: TextInputType.phone),
            DropdownButtonFormField<String>(
              value: crimeType,
              decoration: const InputDecoration(
                labelText: 'অপরাধের ধরন *',
                border: OutlineInputBorder(),
              ),
              items: const [
                'চুরি', 'ছিনতাই', 'প্রতারণা', 'হুমকি', 'মারধর',
                'সাইবার অপরাধ', 'নারী ও শিশু নির্যাতন', 'মাদক সংক্রান্ত অপরাধ',
                'অন্যান্য'
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => crimeType = v),
              validator: (v) => v == null ? 'অপরাধের ধরন নির্বাচন করুন' : null,
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: chooseDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(incidentDate == null
                  ? 'ঘটনার তারিখ নির্বাচন করুন *'
                  : '${incidentDate!.day}/${incidentDate!.month}/${incidentDate!.year}'),
            ),
            const SizedBox(height: 15),
            _field(location, 'ঘটনার স্থান *', 'ঘটনাস্থলের ঠিকানা'),
            _field(description, 'বিস্তারিত অভিযোগ *',
                'কী ঘটেছে বিস্তারিত লিখুন...', maxLines: 7),
            const SizedBox(height: 5),
            const Text(
              'নোট: বাস্তব ব্যবহারে প্রমাণ আপলোড, ডেটাবেস, নিরাপদ লগইন ও সার্ভার সংযোগ যুক্ত করতে হবে।',
              style: TextStyle(color: Colors.deepOrange),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: submit,
              icon: const Icon(Icons.send),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('অভিযোগ পাঠান', style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, String hint,
      {TextInputType? keyboard, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        maxLines: maxLines,
        validator: (v) => (v == null || v.trim().isEmpty) ? 'তথ্য দিন' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final controller = TextEditingController();
  bool searched = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('অভিযোগ ট্র্যাক করুন',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('আপনার Complaint ID লিখুন।'),
            const SizedBox(height: 25),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Complaint ID',
                hintText: 'CMP-2026-123456',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() => searched = true),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (searched)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('অভিযোগের বর্তমান অবস্থা',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      const ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.check),
                        ),
                        title: Text('অভিযোগ গ্রহণ করা হয়েছে'),
                        subtitle: Text('Received'),
                      ),
                      const Divider(),
                      const ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.pending_actions),
                        ),
                        title: Text('পরবর্তী ধাপ'),
                        subtitle: Text('পর্যালোচনা চলছে'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
