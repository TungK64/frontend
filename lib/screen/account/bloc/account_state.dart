part of 'account_bloc.dart';

enum AccountStatus { initial, loading, changeScreen }

class AccountState {
  Map<String, dynamic> items = {};
  AccountStatus status = AccountStatus.initial;

  AccountState clone(AccountStatus status) {
    AccountState state = AccountState();
    state.status = status;
    state.items = items;
    return state;
  }
}
