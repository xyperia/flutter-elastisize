import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlutterElastisizeApp());

class FlutterElastisizeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Elastisize',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: ElastisizeHomePage(),
    );
  }
}

class ElastisizeHomePage extends StatefulWidget {
  @override
  _ElastisizeHomePageState createState() => _ElastisizeHomePageState();
}

class _ElastisizeHomePageState extends State<ElastisizeHomePage> {
  // Initial values for the input fields
  final TextEditingController _eventPerSecondController = TextEditingController(text: '10000');
  final TextEditingController _epsBytesController = TextEditingController(text: '512');
  final TextEditingController _ingestionRateController = TextEditingController(text: '100');
  final TextEditingController _retentionDayHotController = TextEditingController(text: '30');
  final TextEditingController _retentionDayWarmController = TextEditingController(text: '60');
  final TextEditingController _retentionDayColdController = TextEditingController(text: '0');
  final TextEditingController _bufferController = TextEditingController(text: '1.2');
  final TextEditingController _mlNodesController = TextEditingController(text: '0');
  final TextEditingController _masterNodesController = TextEditingController(text: '0');

  final TextEditingController _hotNodeSizeController = TextEditingController(text: '2048');
  final TextEditingController _warmNodeSizeController = TextEditingController(text: '10240');
  final TextEditingController _coldNodeSizeController = TextEditingController(text: '15360');
  final TextEditingController _hotShardsController = TextEditingController(text: '2');
  final TextEditingController _warmShardsController = TextEditingController(text: '2');
  final TextEditingController _coldShardsController = TextEditingController(text: '1');
  final TextEditingController _percentageUsableController = TextEditingController(text: '0.80');

  bool _isTweakingExpanded = false;

  String _result = '';
  List<TableRow> _hardwareRequirementsRows = [];

  void _convertEPS() {
    final double eps = double.parse(_eventPerSecondController.text);
    final double epsbytes = double.parse(_epsBytesController.text);
    // this.ingestionRate = Math.ceil(((this.eventPerSecond * this.avgEps) * 86400) / 1073741824);
    final int epsToGBD = (((eps * epsbytes) * 86400) / 1073741824).ceil();
    _ingestionRateController.text = epsToGBD.toString();
    
  }

  void _calculateResult() {
    final double eventPerSecond = double.parse(_eventPerSecondController.text);
    final double epsBytes = double.parse(_epsBytesController.text);
    final double ingestionRate = double.parse(_ingestionRateController.text);
    final double retentionDayHot = double.parse(_retentionDayHotController.text);
    final double retentionDayWarm = double.parse(_retentionDayWarmController.text);
    final double retentionDayCold = double.parse(_retentionDayColdController.text);
    final double buffer = double.parse(_bufferController.text);
    final int mlNodes = int.parse(_mlNodesController.text);
    final int masterNodes = int.parse(_masterNodesController.text);

    final double hotNodeSize = double.parse(_hotNodeSizeController.text);
    final double warmNodeSize = double.parse(_warmNodeSizeController.text);
    final double coldNodeSize = double.parse(_coldNodeSizeController.text);
    final double hotShards = double.parse(_hotShardsController.text);
    final double warmShards = double.parse(_warmShardsController.text);
    final double coldShards = double.parse(_coldShardsController.text);
    final double percentageUsable = double.parse(_percentageUsableController.text);

    double hotTotal = ingestionRate * retentionDayHot * buffer * hotShards;
    double warmTotal = ingestionRate * retentionDayWarm * buffer * warmShards;
    double coldTotal = ingestionRate * retentionDayCold * buffer * coldShards;

    int hotNode = (hotTotal / (hotNodeSize * percentageUsable)).ceil();
    int warmNode = (warmTotal / (warmNodeSize * percentageUsable)).ceil();
    int coldNode = (coldTotal / (coldNodeSize * percentageUsable)).ceil();

    double totalRetention = retentionDayHot + retentionDayWarm + retentionDayCold;
    int totalNodes = hotNode + warmNode + coldNode + mlNodes + masterNodes;

    // General results
    _result = """
    Sizing Details:

    Retention Total = $totalRetention Days
    - Hot = $retentionDayHot Days
    - Warm = $retentionDayWarm Days
    - Cold = $retentionDayCold Days

    Dedicated Master Nodes
    $masterNodes Nodes

    Dedicated ML Nodes
    $mlNodes Nodes

    Hot Nodes
    $ingestionRate GB x $retentionDayHot Days x $buffer x $hotShards = $hotTotal GB = $hotNode Nodes

    Warm Nodes
    $ingestionRate GB x $retentionDayWarm Days x $buffer x $warmShards = $warmTotal GB = $warmNode Nodes
    
    Cold Nodes
    $ingestionRate GB x $retentionDayCold Days x $buffer x $coldShards = $coldTotal GB = $coldNode Nodes

    Total Nodes = $totalNodes Nodes
    """;

    // Hardware requirements
    setState(() {
      _hardwareRequirementsRows = [
        TableRow(children: [
          Text('Component'),
          Text('vCPU(Cores)'),
          Text('Memory(GB)'),
          Text('Storage(GB)'),
          Text('Qty')
        ]),
        TableRow(children: [
          Text('Dedicated ML Nodes'),
          Text('8'),
          Text('32'),
          Text('1024'),
          Text('$mlNodes')
        ]),
        TableRow(children: [
          Text('Dedicated Master Nodes'),
          Text('4'),
          Text('16'),
          Text('512'),
          Text('$masterNodes')
        ]),
        TableRow(children: [
          Text('Hot Nodes'),
          Text('16'),
          Text('64'),
          Text('$hotNodeSize'),
          Text('$hotNode')
        ]),
        TableRow(children: [
          Text('Warm Nodes'),
          Text('16'),
          Text('64'),
          Text('$warmNodeSize'),
          Text('$warmNode')
        ]),
        TableRow(children: [
          Text('Cold Nodes'),
          Text('16'),
          Text('64'),
          Text('$coldNodeSize'),
          Text('$coldNode')
        ]),
        TableRow(children: [
          Text('Kibana'),
          Text('8'),
          Text('16'),
          Text('512'),
          Text('1')
        ]),
        TableRow(children: [
          Text('Logstash'),
          Text('16'),
          Text('32'),
          Text('1024'),
          Text('1')
        ]),
        TableRow(children: [
          // Text('Fleet Server', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)), 
          Text('Fleet Server'), 
          Text('4'),
          Text('16'),
          Text('1024'),
          Text('1')
        ]),
      ];
    });
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
          CupertinoTextField(
            controller: controller,
            keyboardType: keyboardType,
          ),
        ],
      ),
    );
  }

  Widget _buildTweakingParameters() {
    return Column(
      children: [
        _buildInputField('Hot Node Size (GB)', _hotNodeSizeController, TextInputType.number),
        _buildInputField('Warm Node Size (GB)', _warmNodeSizeController, TextInputType.number),
        _buildInputField('Cold Node Size (GB)', _coldNodeSizeController, TextInputType.number),
        _buildInputField('Number of Hot Shards', _hotShardsController, TextInputType.number),
        _buildInputField('Number of Warm Shards', _warmShardsController, TextInputType.number),
        _buildInputField('Number of Cold Shards', _coldShardsController, TextInputType.number),
        _buildInputField('Disk Usable Size (%)', _percentageUsableController, TextInputType.numberWithOptions(decimal: true)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Elastisize by VTI'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildInputField('Event Per Second (EPS)', _eventPerSecondController, TextInputType.number),
              _buildInputField('EPS Size (Bytes)', _epsBytesController, TextInputType.number),
              CupertinoButton.filled(
                onPressed: _convertEPS,
                child: Text('Convert'),
              ),
              _buildInputField('Ingestion Rate (GB/Day)', _ingestionRateController, TextInputType.number),
              _buildInputField('Hot Retention (Days)', _retentionDayHotController, TextInputType.number),
              _buildInputField('Warm Retention (Days)', _retentionDayWarmController, TextInputType.number),
              _buildInputField('Cold Retention (Days)', _retentionDayColdController, TextInputType.number),
              _buildInputField('Buffer (Data Grow)', _bufferController, TextInputType.numberWithOptions(decimal: true)),
              _buildInputField('Number of ML Nodes', _mlNodesController, TextInputType.number),
              _buildInputField('Number of Dedicated Master Nodes', _masterNodesController, TextInputType.number),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isTweakingExpanded = !_isTweakingExpanded;
                  });
                },
                child: Container(
                  color: CupertinoColors.extraLightBackgroundGray,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Advanced Options', style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontWeight: FontWeight.bold)),
                      Icon(_isTweakingExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down)
                    ],
                  ),
                ),
              ),
              _isTweakingExpanded ? _buildTweakingParameters() : Container(),
              SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _calculateResult,
                child: Text('Submit'),
              ),
              SizedBox(height: 16),
              Text(
                _result,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16),
              _hardwareRequirementsRows.isNotEmpty
                  ? Table(
                      border: TableBorder.all(),
                      children: _hardwareRequirementsRows,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
