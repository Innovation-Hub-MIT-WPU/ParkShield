// ignore_for_file: deprecated_member_use, package_api_docs, public_member_api_docs
import 'package:ParkShield/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io' show Platform;

const String STA_DEFAULT_SSID = "STA_SSID";
const String STA_DEFAULT_PASSWORD = "STA_PASSWORD";
const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

const String AP_DEFAULT_SSID = "AP_SSID";
const String AP_DEFAULT_PASSWORD = "AP_PASSWORD";

class ScanVehiclesBody extends StatefulWidget {
  const ScanVehiclesBody({Key? key}) : super(key: key);

  @override
  _ScanVehiclesBodyState createState() => _ScanVehiclesBodyState();
}

class _ScanVehiclesBodyState extends State<ScanVehiclesBody> {
  String? _sPreviousAPSSID = "";
  String? _sPreviousPreSharedKey = "";

  List<WifiNetwork?>? _htResultNetwork;
  Map<String, bool>? _htIsNetworkRegistered = Map();

  bool _isEnabled = false;
  bool _isConnected = false;
  bool _isWifiDisableOpenSettings = true;
  bool _isWifiEnableOpenSettings = true;

  final TextStyle textStyle = const TextStyle(color: Colors.black);

  void _refresh() {
    setNetworkList();
    setState(() {});
  }

  void setNetworkList() async {
    _htResultNetwork = await loadWifiList();
  }

  @override
  void initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });

    WiFiForIoTPlugin.isConnected().then((val) {
      _isConnected = val;
    });

    setNetworkList();

    super.initState();
  }

  storeAndConnect(String psSSID, String psKey) async {
    await storeAPInfos();
    await WiFiForIoTPlugin.setWiFiAPSSID(psSSID);
    await WiFiForIoTPlugin.setWiFiAPPreSharedKey(psKey);
  }

  storeAPInfos() async {
    String? sAPSSID;
    String? sPreSharedKey;

    try {
      sAPSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    } on PlatformException {
      sAPSSID = "";
    }

    try {
      sPreSharedKey = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
    } on PlatformException {
      sPreSharedKey = "";
    }

    setState(() {
      _sPreviousAPSSID = sAPSSID;
      _sPreviousPreSharedKey = sPreSharedKey;
    });
  }

  restoreAPInfos() async {
    WiFiForIoTPlugin.setWiFiAPSSID(_sPreviousAPSSID!);
    WiFiForIoTPlugin.setWiFiAPPreSharedKey(_sPreviousPreSharedKey!);
  }

  // [sAPSSID, sPreSharedKey]
  Future<List<String>> getWiFiAPInfos() async {
    String? sAPSSID;
    String? sPreSharedKey;

    try {
      sAPSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    } on Exception {
      sAPSSID = "";
    }

    try {
      sPreSharedKey = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
    } on Exception {
      sPreSharedKey = "";
    }

    return [sAPSSID!, sPreSharedKey!];
  }

  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = <WifiNetwork>[];
    }

    return htResultNetwork;
  }

  isRegisteredWifiNetwork(String ssid) async {
    bool bIsRegistered;

    try {
      bIsRegistered = await WiFiForIoTPlugin.isRegisteredWifiNetwork(ssid);
    } on PlatformException {
      bIsRegistered = false;
    }

    setState(() {
      _htIsNetworkRegistered![ssid] = bIsRegistered;
    });
  }

  Widget getWidgets() {
    final List<ListTile> htNetworks = <ListTile>[];

    WiFiForIoTPlugin.isConnected().then((val) {
      setState(() {
        _isConnected = val;
      });
    });

    // disable scanning for ios as not supported
    if (Platform.isIOS) {
      _htResultNetwork = null;
    }

    if (_htResultNetwork != null && _htResultNetwork!.length > 0) {
      _htResultNetwork!.forEach((oNetwork) {
        final PopupCommand oCmdConnect =
            PopupCommand("Connect", oNetwork!.ssid!);
        final PopupCommand oCmdRemove = PopupCommand("Remove", oNetwork.ssid!);

        final List<PopupMenuItem<PopupCommand>> htPopupMenuItems = [];

        htPopupMenuItems.add(
          PopupMenuItem<PopupCommand>(
            value: oCmdConnect,
            child: const Text('Connect'),
          ),
        );

        setState(() {
          isRegisteredWifiNetwork(oNetwork.ssid!);
          if (_htIsNetworkRegistered!.containsKey(oNetwork.ssid) &&
              _htIsNetworkRegistered![oNetwork.ssid]!) {
            htPopupMenuItems.add(
              PopupMenuItem<PopupCommand>(
                value: oCmdRemove,
                child: const Text('Remove'),
              ),
            );
          }

          htNetworks.add(
            ListTile(
              title: Text(
                "" +
                    oNetwork.ssid! +
                    ((_htIsNetworkRegistered!.containsKey(oNetwork.ssid) &&
                            _htIsNetworkRegistered![oNetwork.ssid]!)
                        ? " *"
                        : ""),
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 24,
                    ),
              ),
              trailing: PopupMenuButton<PopupCommand>(
                padding: EdgeInsets.zero,
                onSelected: (PopupCommand poCommand) {
                  switch (poCommand.command) {
                    case "Connect":
                      WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                          password: STA_DEFAULT_PASSWORD,
                          joinOnce: true,
                          security: STA_DEFAULT_SECURITY);
                      break;
                    case "Remove":
                      WiFiForIoTPlugin.removeWifiNetwork(poCommand.argument);
                      break;
                    default:
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => htPopupMenuItems,
              ),
            ),
          );
        });
      });
    }

    final List<Widget> wifiTitle = [
      Center(
        child: Text(
          'WIFI LIST',
          style: Theme.of(context).textTheme.headline3,
        ),
      )
    ];
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: Platform.isIOS
              ? getButtonWidgetsForiOS()
              : getButtonWidgetsForAndroid() + wifiTitle + htNetworks,
        ),
      ),
    );
  }

  List<Widget> getButtonWidgetsForAndroid() {
    final List<Widget> htPrimaryWidgets = <Widget>[];

    WiFiForIoTPlugin.isEnabled().then((val) {
      setState(() {
        _isEnabled = val;
      });
    });

    if (_isEnabled) {
      htPrimaryWidgets.addAll([
        const SizedBox(height: 10),
        const Text("Wifi Enabled"),
        MaterialButton(
          color: const Color(0xFFC1F0F6),
          child: const Text("Disable"),
          onPressed: () {
            WiFiForIoTPlugin.setEnabled(false,
                shouldOpenSettings: _isWifiDisableOpenSettings);
          },
        ),
      ]);

      WiFiForIoTPlugin.isConnected().then((val) {
        setState(() {
          _isConnected = val;
        });
      });

      if (_isConnected) {
        htPrimaryWidgets.addAll(<Widget>[
          const Text("Connected", style: TextStyle(color: Colors.green)),
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadowColor: Theme.of(context).colorScheme.primary,
            child: ListTile(
              leading: const Icon(
                Icons.wifi_outlined,
                color: Colors.green,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: WiFiForIoTPlugin.getSSID(),
                      initialData: "Loading..",
                      builder:
                          (BuildContext context, AsyncSnapshot<String?> ssid) {
                        return Text(
                          "SSID: ${ssid.data}",
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 24),
                        );
                      }),
                  FutureBuilder(
                      future: WiFiForIoTPlugin.getBSSID(),
                      initialData: "Loading..",
                      builder:
                          (BuildContext context, AsyncSnapshot<String?> bssid) {
                        return Text("BSSID: ${bssid.data}");
                      }),
                  FutureBuilder(
                      future: WiFiForIoTPlugin.getCurrentSignalStrength(),
                      initialData: 0,
                      builder:
                          (BuildContext context, AsyncSnapshot<int?> signal) {
                        return Text("Signal: ${signal.data}");
                      }),
                  FutureBuilder(
                      future: WiFiForIoTPlugin.getFrequency(),
                      initialData: 0,
                      builder:
                          (BuildContext context, AsyncSnapshot<int?> freq) {
                        return Text("Frequency : ${freq.data}");
                      }),
                  FutureBuilder(
                      future: WiFiForIoTPlugin.getIP(),
                      initialData: "Loading..",
                      builder:
                          (BuildContext context, AsyncSnapshot<String?> ip) {
                        return Text("IP : ${ip.data}");
                      }),
                ],
              ),
              subtitle: FutureBuilder(
                  future: WiFiForIoTPlugin.getFrequency(),
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot<int?> freq) {
                    return Text("Frequency : ${freq.data}");
                  }),
            ),
          ),
          MaterialButton(
            color: const Color(0xFFC1F0F6),
            child: Text("Disconnect", style: textStyle),
            onPressed: () {
              WiFiForIoTPlugin.disconnect();
            },
          ),
        ]);
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          const Text("Disconnected", style: TextStyle(color: Colors.red)),
          MaterialButton(
            color: const Color(0xFFC1F0F6),
            child: Text("Scan", style: textStyle),
            onPressed: () async {
              _htResultNetwork = await loadWifiList();
              setState(() {});
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: const Color(0xFFC1F0F6),
                child: Text("Use WiFi", style: textStyle),
                onPressed: () {
                  WiFiForIoTPlugin.forceWifiUsage(true);
                },
              ),
              const SizedBox(width: 50),
              MaterialButton(
                color: const Color(0xFFC1F0F6),
                child: Text("Use 3G/4G", style: textStyle),
                onPressed: () {
                  WiFiForIoTPlugin.forceWifiUsage(false);
                },
              ),
            ],
          ),
        ]);
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        SizedBox(height: 10),
        Text("Wifi Disabled"),
        MaterialButton(
          color: const Color(0xFFC1F0F6),
          child: Text("Enable", style: textStyle),
          onPressed: () async {
            setState(() {
              WiFiForIoTPlugin.setEnabled(true,
                  shouldOpenSettings: _isWifiEnableOpenSettings);
            });
          },
        ),
      ]);
    }

    htPrimaryWidgets.add(Divider(
      height: 32.0,
    ));

    return htPrimaryWidgets;
  }

  List<Widget> getButtonWidgetsForiOS() {
    final List<Widget> htPrimaryWidgets = <Widget>[];

    WiFiForIoTPlugin.isEnabled().then((val) => setState(() {
          _isEnabled = val;
        }));

    if (_isEnabled) {
      htPrimaryWidgets.add(Text("Wifi Enabled"));
      WiFiForIoTPlugin.isConnected().then((val) => setState(() {
            _isConnected = val;
          }));

      String? _sSSID;

      if (_isConnected) {
        htPrimaryWidgets.addAll(<Widget>[
          const Text("Connected", style: TextStyle(color: Colors.green)),
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadowColor: Theme.of(context).colorScheme.primary,
            child: ListTile(
              leading: const Icon(
                Icons.wifi_outlined,
                color: Colors.green,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: WiFiForIoTPlugin.getSSID(),
                      initialData: "Loading..",
                      builder:
                          (BuildContext context, AsyncSnapshot<String?> ssid) {
                        return Text(
                          "SSID: ${ssid.data}",
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 24),
                        );
                      }),
                ],
              ),
            ),
          ),
        ]);

        if (_sSSID == STA_DEFAULT_SSID) {
          htPrimaryWidgets.addAll(<Widget>[
            MaterialButton(
              color: const Color(0xFFC1F0F6),
              child: Text("Disconnect", style: textStyle),
              onPressed: () {
                WiFiForIoTPlugin.disconnect();
              },
            ),
          ]);
        } else {
          htPrimaryWidgets.addAll(<Widget>[
            MaterialButton(
              color: const Color(0xFFC1F0F6),
              child: Text("Connect to '$AP_DEFAULT_SSID'", style: textStyle),
              onPressed: () {
                WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                    password: STA_DEFAULT_PASSWORD,
                    joinOnce: true,
                    security: NetworkSecurity.WPA);
              },
            ),
          ]);
        }
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          const Text("Disconnected"),
          MaterialButton(
            color: const Color(0xFFC1F0F6),
            child: Text("Connect to '$AP_DEFAULT_SSID'", style: textStyle),
            onPressed: () {
              WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                  password: STA_DEFAULT_PASSWORD,
                  joinOnce: true,
                  security: NetworkSecurity.WPA);
            },
          ),
        ]);
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        Text("Wifi Disabled?"),
        MaterialButton(
          color: const Color(0xFFC1F0F6),
          child: Text("Connect to '$AP_DEFAULT_SSID'", style: textStyle),
          onPressed: () {
            WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                password: STA_DEFAULT_PASSWORD,
                joinOnce: true,
                security: NetworkSecurity.WPA);
          },
        ),
      ]);
    }

    return htPrimaryWidgets;
  }

  @override
  Widget build(BuildContext poContext) {
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: AppBar(
        title: Text(
          'Scan for Vehicle Wifi',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 24,
              ),
        ),
        actions: <Widget>[
              IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))
            ] +
            (_isConnected
                ? <Widget>[
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case "disconnect":
                            WiFiForIoTPlugin.disconnect();
                            break;
                          case "remove":
                            WiFiForIoTPlugin.getSSID().then((val) =>
                                WiFiForIoTPlugin.removeWifiNetwork(val!));
                            break;
                          default:
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          const <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: "disconnect",
                          child: Text('Disconnect'),
                        ),
                        PopupMenuItem<String>(
                          value: "remove",
                          child: Text('Remove'),
                        ),
                      ],
                    ),
                  ]
                : <Widget>[]),
      ),
      body: getWidgets(),
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument);
}
