import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            TextFormField(
              controller: controller.domainTextEditingController,
            ),
            Row(
              children: [
                RaisedButton(
                  child: Text('Add'),
                  onPressed: () {
                    controller.addServer(
                        domainServer: controller.domainTextEditingController.text);
                  },
                ),
                RaisedButton(
                  child: Text('Remove'),
                  onPressed: () {
                    controller.removeServer(
                        domainServer: controller.domainTextEditingController.text);
                  },
                ),
              ],
            ),
            Expanded(
              child: Observer(builder: (_) {
                return ListView.builder(
                    itemCount: controller.listOfServers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Text(controller.listOfServers[index].domain),
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
