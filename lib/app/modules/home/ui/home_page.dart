import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:me_reach/app/core/exceptions.dart';
import 'package:me_reach/app/modules/home/domain/entities_interfaces/server_entity_interface.dart';
import 'package:me_reach/app/modules/home/ui/widgets/server_tile_widget.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD8E0EF),
      body: getServersListFutureBuilder(),
    );
  }

  Widget getServersListFutureBuilder() {
    final getServersList = controller.getServersList();

    return FutureBuilder(
      future: getServersList,
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            throw UnimplementedError();
            break;
          case ConnectionState.waiting:
            return Container();
            break;
          case ConnectionState.active:
            throw UnimplementedError();
            break;
          case ConnectionState.done:
            return body();
            break;
        }
      },
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: addServerDomainTextField(),
            ),
            Expanded(
              child: reorderableList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget addServerDomainTextField() {
    return Builder(
      builder: (BuildContext context) {
        return Observer(builder: (_) {
          return CupertinoTextField(
            controller: controller.domainTextEditingController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(25),
            ],
            keyboardType: TextInputType.emailAddress,
            placeholder: 'Adicione um domínio...',
            prefix: Row(
              children: [
                SizedBox(width: 10),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    iconEnabledColor: Colors.transparent,
                    elevation: 0,
                    isExpanded: false,
                    value: controller.securityProtocol,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: Colors.black,
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text('Https://'),
                        value: 'https://',
                      ),
                      DropdownMenuItem(
                        child: Text('Http://'),
                        value: 'http://',
                      ),
                    ],
                    onChanged: (value) {
                      controller.setSecurityProtocol(value);
                    },
                  ),
                ),
              ],
            ),
            suffix: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  onTap: () async {
                    try {
                      // Check if the serverDomain is valid
                      if (!_validateServerDomain(
                          controller.domainTextEditingController.text.trim()))
                        throw InvalidDomainAddressException();

                      await controller.addServer(
                        serverDomain: controller.securityProtocol + 'www.' +
                            controller.domainTextEditingController.text.trim(),
                      );
                    } on InvalidDomainAddressException {
                      _showSnackBar(
                        context,
                        message:
                            'Este não é um domínio válido. Por favor, utilize um válido.',
                      );
                    } on ServerAlreadyExistsException {
                      _showSnackBar(
                        context,
                        message: 'Este domínio já foi adicionado.',
                      );
                    }
                  },
                ),
                SizedBox(width: 5),
              ],
            ),
          );
        });
      },
    );
  }

  Widget reorderableList() {
    return Observer(
      builder: (_) {
        return LiquidPullToRefresh(
          key: controller.refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          child: ImplicitlyAnimatedReorderableList<IServerEntity>(
            controller: controller.scrollController,
            items: controller.listOfServers,
            areItemsTheSame: (oldItem, newItem) =>
                oldItem.domain == newItem.domain,
            onReorderFinished: (_, __, ___, newItems) {
              controller.reOrderServersList(newItems);
            },
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                key: ValueKey(item),
                builder: (context, dragAnimation, inDrag) {
                  final serverTile = ServerTile(
                    serverDomain: controller.listOfServers[index].domain,
                    index: index,
                    isOnline: controller.listOfServers[index].isOnline,
                    latUpdate: controller.listOfServers[index].lastUpdate,
                    refreshServerStatus: () {
                      controller.refreshServerStatus(
                        serverDomain: controller.listOfServers[index].domain,
                      );
                    },
                    removeServer: () {
                      controller.removeServer(
                        serverDomain: controller.listOfServers[index].domain,
                      );
                    },
                  );

                  return dragAnimation.value > 0
                      ? serverTile
                      : SizeFadeTransition(
                          animation: itemAnimation,
                          axis: Axis.horizontal,
                          axisAlignment: 1.0,
                          curve: Curves.ease,
                          child: serverTile,
                        );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      print('ok');
    });
  }

  void _showSnackBar(BuildContext context, {@required String message}) {
    final _snackBar = SnackBar(
      content: Text(
        message,
      ),
    );

    Scaffold.of(context).showSnackBar(_snackBar);
  }

  bool _validateServerDomain(String serverDomain) {
    return RegExp(
            r"^((?!-))(xn--)?[a-z0-9][a-z0-9-_]{0,61}[a-z0-9]{0,1}\.(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,})$")
        .hasMatch(serverDomain);
  }
}
