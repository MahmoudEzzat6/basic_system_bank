
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../view/components.dart';
import 'bank_states.dart';

class BankCubit extends Cubit<BankStates> {
  BankCubit() : super(BankAccountInitialState());

  static BankCubit get(context) => BlocProvider.of(context);

  var database;

  void createDatabase() {
    openDatabase(
      'bankAccount.db',
      version: 1,
      onCreate: (Database, version) {
        debugPrint('database created');

        Database
            .execute(
          'create table users (id INTEGER PRIMARY KEY, name TEXT,email Text, salary Double)',
        )
            .then((value) {
          debugPrint('table created');
        }).catchError((error) {
          debugPrint('failed creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        debugPrint('database opened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseSuccessState());
    }).catchError((error) {
      emit(CreateDatabaseErrorState());
      debugPrint('failed creating database ${error.toString()}');
    });
  }

  //
  void getDataFromDatabase(database) {
    database.rawQuery('SELECT * FROM users').then((value) {
      users = value;
      emit(GetDataFromDatabaseSuccessState());
    });
    debugPrint(users.toString());
  }

  void updateData({
    required double salary,
    required int id,
  }) async {
    await database.rawUpdate(
      'UPDATE users SET salary = ? WHERE id = ?',
      [salary, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(UpdateDatabaseSuccessState());
    }).catchError((error) {
      emit(UpdateDatabaseErrorState());
    });
  }

  void withdraw(Map model, double amount) {
    updateData(salary: (model['salary'] - amount), id: model['id']);
    emit(WithdrawSuccessState());
  }

  void deposit(Map model, double amount) {
    updateData(salary: (model['salary'] + amount), id: model['id']);
    emit(DepositSuccessState());
  }

  void transfer(int index, double amount, int id) {
    updateData(salary: (users[index]['salary'] - amount), id: users[index]['id']);
    updateData(salary: (users[id]['salary'] + amount), id: id);
  }

  void changeValue(Map model, double amount) {
    model['salary'] = amount;
    emit(ChangeValueSuccessState());
  }
  Future<void> deleteDb({required int id}) async {
    await database
        .rawDelete('DELETE FROM Test WHERE id =?',[id]);
    getDataFromDatabase(database);
  }
}
