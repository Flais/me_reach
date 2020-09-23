import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:intl/intl.dart';

class ServerTile extends StatelessWidget {
  final String _serveDomain;
  final int _index;
  final DateTime _lastUpdate;
  final bool _isOnline;
  final Function _removeServer;

  ServerTile({
    @required String serverDomain,
    @required int index,
    @required DateTime latUpdate,
    @required bool isOnline,
    @required Function removeServer,
  })  : this._serveDomain = serverDomain,
        this._index = index,
        this._lastUpdate = latUpdate,
        this._removeServer = removeServer,
        this._isOnline = isOnline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: .3),
        Slidable(
          actionPane: const SlidableBehindActionPane(),
          secondaryActions: [
            GestureDetector(
              onTap: this._removeServer,
              child: Container(
                height: 68,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    Text(
                      'Atualizar',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: this._removeServer,
              child: Container(
                height: 68,
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text(
                      'Excluir',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
          child: Container(
            height: 70,
            color: Colors.white,
            alignment: Alignment.center,
            child: ListTile(
              dense: true,
              title: Text(
                this._serveDomain,
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this._index.toString(),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: this._isOnline ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        this._isOnline ? 'Online' : 'Offline',
                      ),
                    ],
                  ),
                  Text('Ult. Update: ${_getFormattedDate(this._lastUpdate)}h')
                ],
              ),
              trailing: Handle(
                delay: Duration(milliseconds: 100),
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    final DateFormat hourFormatter = DateFormat('HH:mm');
    final String formatted = hourFormatter.format(dateTime);

    return formatted;
  }
}
