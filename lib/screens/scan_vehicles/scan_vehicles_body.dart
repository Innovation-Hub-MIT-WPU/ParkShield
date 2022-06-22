// ignore_for_file: deprecated_member_use, package_api_docs, public_member_api_docs
import 'dart:convert';

import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Firebase/FireAuth/fireauth.dart';

import 'package:ParkShield/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
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
  final String userID = getCurrentUserId();
  var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(hideUrlBar: false),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)));
  List<WifiNetwork?>? _htResultNetwork;
  final Map<String, bool>? _htIsNetworkRegistered = Map();
  late TextEditingController passwordController = TextEditingController();

  bool _isEnabled = false;
  bool withInternet = false;
  bool _isConnected = false;
  int vehicleState = -1;
  bool _isWifiDisableOpenSettings = true;
  bool _isWifiEnableOpenSettings = true;

  final TextStyle textStyle = const TextStyle(color: Colors.black);

  Future<void> _refresh() async {
    await getNetworkList();
    setState(() {});
  }

  Future<void> getNetworkList() async {
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

    getNetworkList();

    super.initState();
  }

  // WiFi List
  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = <WifiNetwork>[];
    }

    return htResultNetwork;
  }

  Future<void> isRegisteredWifiNetwork(String ssid) async {
    bool bIsRegistered;

    try {
      bIsRegistered = await WiFiForIoTPlugin.isRegisteredWifiNetwork(ssid);
      if (bIsRegistered == false) {
        WiFiForIoTPlugin.registerWifiNetwork(ssid);
      }
    } on PlatformException {
      bIsRegistered = false;
    }

    setState(() {
      _htIsNetworkRegistered![ssid] = bIsRegistered;
    });
  }

  Widget getWidgets({required BuildContext buildContext}) {
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

    if (_htResultNetwork != null && _htResultNetwork!.isNotEmpty) {
      _htResultNetwork!.forEach((oNetwork) {
        final PopupCommand oCmdConnect =
            PopupCommand("Connect", oNetwork!.ssid!);

        final List<PopupMenuItem<PopupCommand>> htPopupMenuItems = [];

        htPopupMenuItems.add(
          PopupMenuItem<PopupCommand>(
            value: oCmdConnect,
            child: const Text('Connect'),
          ),
        );

        bool connectNow = false;

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
              onSelected: (PopupCommand poCommand) async {
                switch (poCommand.command) {
                  case "Connect":
                    print("Connecting to ${oNetwork.ssid!}");
                    await showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return FittedBox(
                          fit: BoxFit.contain,
                          child: AlertDialog(
                            title: Text('Enter password for ${oNetwork.ssid}'),
                            content: Flex(
                              direction: Axis.vertical,
                              children: [
                                TextField(
                                  controller: passwordController,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: MAIN_COLOR_THEME['primary'],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                        child: const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "Connect",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {});
                                          Navigator.of(context).pop();
                                          connectNow = true;
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: MAIN_COLOR_THEME['primary'],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                        child: const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    // Add password input here
                    if (connectNow) {
                      print("FORCE WIFI USAGE");
                      print(WiFiForIoTPlugin.forceWifiUsage(true));
                      if (withInternet) {
                        await WiFiForIoTPlugin.findAndConnect(
                          oNetwork.ssid!,
                          password: passwordController.text,
                          joinOnce: false,
                          withInternet: true,
                        );
                      } else {
                        await WiFiForIoTPlugin.connect(
                          oNetwork.ssid!,
                          password: passwordController.text,
                          joinOnce: false,
                          security: NetworkSecurity.WPA,
                        );
                      }

                      // final response =
                      //     await http.get(Uri.parse('https://192.168.0.1/'));
                      // print(response.body);

                      late BuildContext dialogContextDefault;
                      if (withInternet) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext dialogContext) {
                            dialogContextDefault = dialogContext;
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 10),
                                    Text("Loading")
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      while (await WiFiForIoTPlugin.isConnected() != true);
                      Future.delayed(const Duration(seconds: 2), () async {
                        print("THIS IS HTTP");
                        print(await http.get(Uri.parse(
                            'http://192.168.4.1/2/on?userID=$userID')));
                        if (withInternet) {
                          Navigator.pop(dialogContextDefault);
                        }
                        // await browser.openUrlRequest(
                        //     urlRequest: URLRequest(
                        //         url: Uri.parse("http://192.168.4.1")),
                        //     options: options);
                      });
                    }

                    break;
                  default:
                    break;
                }
              },
              itemBuilder: (BuildContext context) => htPopupMenuItems,
            ),
          ),
        );
        setState(() {});
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
            onPressed: () async {
              String ssid = await WiFiForIoTPlugin.getSSID() as String;
              await WiFiForIoTPlugin.disconnect();
              await WiFiForIoTPlugin.removeWifiNetwork(ssid);
              setState(() {});
            },
          ),
          MaterialButton(
            color: const Color(0xFFC1F0F6),
            child: Text(
                vehicleState != -1
                    ? ("Turn " +
                        (vehicleState == 0 ? "on" : "off") +
                        " vehicle")
                    : "Check the vehicle state",
                style: textStyle),
            onPressed: () async {
              print("Getting state");
              var response =
                  await http.get(Uri.parse("http://192.168.4.1/state"));

              print("THE RESPONSE");

              print(response.body);
              Map<String, dynamic> jsonResponse = jsonDecode(response.body);
              print(jsonResponse);
              if (vehicleState == -1) {
                vehicleState = jsonResponse["state"] == 0 ? 0 : 1;
              } else {
                if (jsonResponse["state"] == 0) {
                  await http
                      .get(Uri.parse("http://192.168.4.1/2/on?userID=$userID"));
                  vehicleState = 0;
                } else {
                  await http.get(
                      Uri.parse("http://192.168.4.1/2/off?userID=$userID"));
                  vehicleState = 1;
                }
              }
              setState(() {});
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
          MaterialButton(
            color: const Color(0xFFC1F0F6),
            child: Text(withInternet ? "Internet : true" : "Internet : false",
                style: textStyle),
            onPressed: () {
              withInternet = !withInternet;
              setState(() {});
            },
          ),
        ]);
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        const SizedBox(height: 10),
        const Text("Wifi Disabled"),
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

    htPrimaryWidgets.add(const Divider(
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
      htPrimaryWidgets.add(const Text("Wifi Enabled"));
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
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        const Text("Wifi Disabled"),
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
      setState(() {});
    }

    return htPrimaryWidgets;
  }

  @override
  Widget build(BuildContext poContext) {
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Scan for Vehicle Wifi',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 24,
              ),
        ),
        actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    await _refresh();
                  },
                  icon: const Icon(Icons.refresh))
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
      body: getWidgets(buildContext: poContext),
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument);
}
