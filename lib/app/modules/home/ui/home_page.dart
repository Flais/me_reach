import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
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
  void initState() {
    //This method triggers the periodic server status refresh
    controller.periodicRefreshServers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD8E0EF),
      body: _getServersListFutureBuilder(),
    );
  }

  Widget _getServersListFutureBuilder() {
    final _getServersList = controller.getServersList();

    return FutureBuilder(
      future: _getServersList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _errorBody();
            break;
          case ConnectionState.waiting:
            return _loadingBody();
            break;
          default:
            return _loadedBody();
            break;
        }
      },
    );
  }

  Widget _loadedBody() {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _textField(),
            ),
            Expanded(
              child: _listView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField() {
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
                _dropDown(),
              ],
            ),
            suffix: Row(
              children: [
                _textFieldIconButton(),
                SizedBox(width: 5),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _listView() {
    return Builder(
      builder: (BuildContext context) {
        return Observer(
          builder: (_) {
            return LiquidPullToRefresh(
              key: controller.refreshIndicatorKey,
              onRefresh: () {
                return _handleRefresh(context);
              },
              showChildOpacityTransition: false,
              child: ImplicitlyAnimatedReorderableList<IServerEntity>(
                physics: AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                items: controller.listOfServers,
                areItemsTheSame: (oldItem, newItem) =>
                    oldItem.domain == newItem.domain,
                onReorderFinished: (_, __, ___, newItems) {
                  controller.reOrderServersList(newItems);
                },
                itemBuilder: (context, itemAnimation, item, index) {
                  return index < controller.listOfServers.length
                      ? Reorderable(
                          key: ValueKey(item),
                          builder: (context, dragAnimation, inDrag) {
                            final serverTile = ServerTile(
                              index: index,
                              serverDomain: controller.listOfServers[index].domain,
                              isOnline: controller.listOfServers[index].isOnline,
                              latUpdate: controller.listOfServers[index].lastUpdate,
                              refreshServerStatus: () {
                                controller.refreshServerStatus(
                                  serverDomain: controller.listOfServers[index].domain,
                                );
                              },
                              removeServer: () {
                                controller.removeServer(serverDomain: controller.listOfServers[index].domain,
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
                        )
                      : Reorderable(
                          key: ValueKey(item),
                          child: Container(),
                        );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleRefresh(BuildContext context) {
    return controller
        .getServersList()
        .then((value) => _showSnackBar(context, message: 'Atualizado!'));
  }

  void _showSnackBar(BuildContext context, {@required String message}) {
    final _snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
          ),
        ],
      ),
      duration: Duration(milliseconds: 500),
    );

    Scaffold.of(context).showSnackBar(_snackBar);
  }

  Widget _loadingBody() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _errorBody() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Algo deu errado. Tente novamente mais tarde.')),
        ],
      ),
    );
  }

  Widget _dropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        iconEnabledColor: Colors.transparent,
        elevation: 0,
        isExpanded: false,
        value: controller.textFieldSecurityProtocolOption,
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
          controller.setTextFieldSecurityProtocolOption(value);
        },
      ),
    );
  }

  Widget _textFieldIconButton() {
    return GestureDetector(
      child: Icon(
        Icons.add,
        color: Colors.green,
      ),
      onTap: controller.isAddingNewDomain
          ? () {
        print('blocked');
      }
          : () async {
        controller.setIsAddingNewDomain(true);
        try {
          // Check if the serverDomain is valid
          if (!controller.validateServerDomain(controller
              .domainTextEditingController.text
              .trim())) throw InvalidDomainAddressException();

          await controller.addServer(
            serverDomain: controller
                .textFieldSecurityProtocolOption +
                'www.' +
                controller.domainTextEditingController.text
                    .trim(),
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
        controller.setIsAddingNewDomain(false);
      },
    );
  }
}
