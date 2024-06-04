import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SizingPlatinum(),
    );
  }
}

class SizingPlatinum extends StatefulWidget {
  const SizingPlatinum({Key? key}) : super(key: key);

  @override
  State<SizingPlatinum> createState() => _SizingPlatinumState();
}

class _SizingPlatinumState extends State<SizingPlatinum> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  final Map<String, TextEditingController> _assessmentControllers = {
    'ingestionRate': TextEditingController(text: '100'),
    'retentionDayHot': TextEditingController(text: '30'),
    'retentionDayWarm': TextEditingController(text: '60'),
    'retentionDayCold': TextEditingController(text: '0'),
    'buffer': TextEditingController(text: '1.2'),
    'numberMLNodes': TextEditingController(text: '1'),
    'numberMasterNodes': TextEditingController(text: '0'),
  };

  final Map<String, TextEditingController> _parameterControllers = {
    'hotNodeSize': TextEditingController(text: '2048'),
    'warmNodeSize': TextEditingController(text: '10240'),
    'coldNodeSize': TextEditingController(text: '15360'),
    'numberHotShards': TextEditingController(text: '2'),
    'numberWarmShards': TextEditingController(text: '2'),
    'numberColdShards': TextEditingController(text: '1'),
    'percentageUsable': TextEditingController(text: '0.80'),
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sizing Platinum')),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          AssessmentPage(controllers: _assessmentControllers),
          ParameterPage(controllers: _parameterControllers),
          ResultsPage(
            assessmentControllers: _assessmentControllers,
            parameterControllers: _parameterControllers,
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
        itemPadding: EdgeInsets.all(25),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: _onItemTapped,
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.present_to_all),
    title: const Text("Assessment"),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.settings),
    title: const Text("Parameter"),
    selectedColor: Colors.pink,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.assessment),
    title: const Text("Results"),
    selectedColor: Colors.orange,
  ),
];



class AssessmentPage extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  AssessmentPage({required this.controllers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildTextField('Ingestion Rate', controllers['ingestionRate']!, TextInputType.number),
        buildTextField('Retention Day Hot', controllers['retentionDayHot']!, TextInputType.number),
        buildTextField('Retention Day Warm', controllers['retentionDayWarm']!, TextInputType.number),
        buildTextField('Retention Day Cold', controllers['retentionDayCold']!, TextInputType.number),
        buildTextField('Buffer', controllers['buffer']!, TextInputType.numberWithOptions(decimal: true)),
        buildTextField('Number of ML Nodes', controllers['numberMLNodes']!, TextInputType.number),
        buildTextField('Number of Dedicated Master Nodes', controllers['numberMasterNodes']!, TextInputType.number),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: inputType,
      ),
    );
  }
}

class ParameterPage extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  ParameterPage({required this.controllers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildTextField('Hot Node Size', controllers['hotNodeSize']!, TextInputType.number),
        buildTextField('Warm Node Size', controllers['warmNodeSize']!, TextInputType.number),
        buildTextField('Cold Node Size', controllers['coldNodeSize']!, TextInputType.number),
        buildTextField('Number of Hot Shards', controllers['numberHotShards']!, TextInputType.number),
        buildTextField('Number of Warm Shards', controllers['numberWarmShards']!, TextInputType.number),
        buildTextField('Number of Cold Shards', controllers['numberColdShards']!, TextInputType.number),
        buildTextField('Percentage of Usable', controllers['percentageUsable']!, TextInputType.numberWithOptions(decimal: true)),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: inputType,
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final Map<String, TextEditingController> assessmentControllers;
  final Map<String, TextEditingController> parameterControllers;

  ResultsPage({required this.assessmentControllers, required this.parameterControllers});

  @override
  Widget build(BuildContext context) {
    double ingestionRate = double.tryParse(assessmentControllers['ingestionRate']!.text) ?? 100;
    int retentionDayHot = int.tryParse(assessmentControllers['retentionDayHot']!.text) ?? 30;
    int retentionDayWarm = int.tryParse(assessmentControllers['retentionDayWarm']!.text) ?? 60;
    int retentionDayCold = int.tryParse(assessmentControllers['retentionDayCold']!.text) ?? 0;
    double buffer = double.tryParse(assessmentControllers['buffer']!.text) ?? 1.2;
    int numberMLNodes = int.tryParse(assessmentControllers['numberMLNodes']!.text) ?? 1;
    int numberMasterNodes = int.tryParse(assessmentControllers['numberMasterNodes']!.text) ?? 0;

    int hotNodeSize = int.tryParse(parameterControllers['hotNodeSize']!.text) ?? 2048;
    int warmNodeSize = int.tryParse(parameterControllers['warmNodeSize']!.text) ?? 10240;
    int coldNodeSize = int.tryParse(parameterControllers['coldNodeSize']!.text) ?? 15360;
    int numberHotShards = int.tryParse(parameterControllers['numberHotShards']!.text) ?? 2;
    int numberWarmShards = int.tryParse(parameterControllers['numberWarmShards']!.text) ?? 2;
    int numberColdShards = int.tryParse(parameterControllers['numberColdShards']!.text) ?? 1;
    double percentageUsable = double.tryParse(parameterControllers['percentageUsable']!.text) ?? 0.80;

    double gtHot = ingestionRate * retentionDayHot * buffer * numberHotShards;
    double gtWarm = ingestionRate * retentionDayWarm * buffer * numberWarmShards;
    double gtCold = ingestionRate * retentionDayCold * buffer * numberColdShards;

    int hotNode = _roundUp(gtHot / (hotNodeSize * percentageUsable));
    int warmNode = _roundUp(gtWarm / (warmNodeSize * percentageUsable));
    int coldNode = _roundUp(gtCold / (coldNodeSize * percentageUsable));
    int totalNodes = hotNode + warmNode + coldNode + numberMLNodes + numberMasterNodes;

    int totalRetention = retentionDayHot + retentionDayWarm + retentionDayCold;
    int totalVM = numberMasterNodes + numberMLNodes + hotNode + warmNode + coldNode + 3 ;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text('Results', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('ELK Sizing with ingestion rate of $ingestionRate GB/Day & $totalRetention Days retention', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
            SizedBox(height: 32),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Dedicated Master'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$numberMasterNodes'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Dedicated ML'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$numberMLNodes'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Hot Phase'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$ingestionRate x $retentionDayHot x $buffer x $numberHotShards = $gtHot = $hotNode'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Warm Phase'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$ingestionRate x $retentionDayWarm * $buffer x $numberWarmShards = $gtWarm = $warmNode'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Cold Phase'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$ingestionRate x $retentionDayCold x $buffer x $numberColdShards = $gtCold = $coldNode'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total Nodes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$totalNodes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
              ],
            ),
            
            SizedBox(height: 32),
            Text('Hardware Requirements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 32),

            Table(
              border: TableBorder.all(color: Color.fromRGBO(200, 200, 200, 0.5)),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Component', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('vCPU', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('RAM(GB)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Storage', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Dedicated Master'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('4'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1024 GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$numberMasterNodes'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Dedicated ML'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('32'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1024 GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$numberMLNodes'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Hot Nodes'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('64'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$hotNodeSize GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$hotNode'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Warm Nodes'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('64'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$warmNodeSize GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$warmNode'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Cold Nodes'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('64'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$coldNodeSize GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$coldNode'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Logstash'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('32'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1024 GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Kibana'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('8'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('512 GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fleet Server'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('4'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('16'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1024 GB'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('1'),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$totalVM VMs', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _roundUp(double value) {
    return value.ceil();
  }
}
