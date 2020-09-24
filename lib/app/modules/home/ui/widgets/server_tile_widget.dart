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
  final Function _refreshServerStatus;

  ServerTile({
    @required String serverDomain,
    @required int index,
    @required DateTime latUpdate,
    @required bool isOnline,
    @required Function removeServer,
    @required Function refreshServerStatus,
  })  : this._serveDomain = serverDomain,
        this._index = index,
        this._lastUpdate = latUpdate,
        this._removeServer = removeServer,
        this._refreshServerStatus = refreshServerStatus,
        this._isOnline = isOnline;

  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: .3),
        Slidable(
          actionPane: const SlidableScrollActionPane(),
          secondaryActions: [
            _slidableAction(
              title: 'Atualizar',
              iconData: Icons.refresh,
              backGroundColor: Colors.green,
              snackBarOnTapMessage: 'Atualizado!',
              onTapAction: this._refreshServerStatus,
            ),
            _slidableAction(
              title: 'Excluir',
              iconData: Icons.delete,
              backGroundColor: Colors.red,
              snackBarOnTapMessage: 'Removido!',
              onTapAction: this._removeServer,
            ),
          ],
          child: _lisTileBody(),
        ),
      ],
    );
  }

  Widget _slidableAction({
    @required String snackBarOnTapMessage,
    @required String title,
    @required IconData iconData,
    @required Color backGroundColor,
    @required Function onTapAction,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            onTapAction();
            Slidable.of(context).close();
            _showSnackBar(context, message: snackBarOnTapMessage);
          },
          child: Container(
            height: 68,
            color: backGroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, {@required String message}) {
    final _snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
        ],
      ),
      duration: Duration(milliseconds: 500),
    );
    Scaffold.of(context).showSnackBar(_snackBar);
  }

  Widget _lisTileBody() {
    return Container(
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
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    final DateFormat hourFormatter = DateFormat('HH:mm');
    final String formatted = hourFormatter.format(dateTime);

    return formatted;
  }
}
