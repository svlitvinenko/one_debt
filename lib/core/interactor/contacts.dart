import 'package:flutter/foundation.dart';
import 'package:one_debt/core/interactor/interactor.dart';
import 'package:one_debt/core/model/d_contact.dart';

class Contacts extends Interactor<List<DContact>> {
  @override
  final ValueNotifier<List<DContact>> model;

  bool _isInitialized = false;

  Contacts() : model = ValueNotifier([]);

  @override
  Future<void> initialize() async {
    model.value = [
      const DContact(
        id: '1',
        name: 'Seroja',
        avatarUrl:
            'https://media.licdn.com/dms/image/C4D03AQEqH62shvjy8A/profile-displayphoto-shrink_800_800/0/1645987033633?e=2147483647&v=beta&t=vgpCgH7sU9gOqrjv62UC1Sv_9rvXkItC_T61lPsybl0',
      ),
    ];
    _isInitialized = true;
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> clear() async {
    _isInitialized = false;
    value = [];
  }
}
