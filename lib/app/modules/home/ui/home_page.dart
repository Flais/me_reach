import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
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
    return CupertinoTextField(
      controller: controller.domainTextEditingController,
      placeholder: 'Adicione um domínio...',
      suffix: Row(
        children: [
          GestureDetector(
            child: Icon(
              Icons.add,
              color: Colors.green,
            ),
            onTap: () {
              controller.addServer(
                serverDomain: controller.domainTextEditingController.text,
              );
            },
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget reorderableList() {
    return Observer(
      builder: (_) {
        return ImplicitlyAnimatedReorderableList<IServerEntity>(
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
                  removeServer: () {
                    controller.removeServer(
                        serverDomain: controller.listOfServers[index].domain);
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
        );
      },
    );
  }
}
