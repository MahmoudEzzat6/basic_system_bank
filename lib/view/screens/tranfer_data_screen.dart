import 'package:basic_system_bank/shared/cubit/bank_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/bank_states.dart';
import '../components.dart';

class TransferData extends StatelessWidget {
  int index;
  var depositController = TextEditingController();
  var transferController = TextEditingController();
  var idController = TextEditingController();
  var withdrawController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  int flag = 0;

  TransferData(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BankCubit, BankStates>(
      listener: (context, state) {
        if (state is UpdateDatabaseSuccessState) {
          idController.clear();
          withdrawController.clear();
          depositController.clear();
          transferController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white30,
            foregroundColor: Colors.blueGrey,
            title: const Text(
              'Account Details',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Icon(Icons.person, size: 70),
                              Text(
                                '${users[index]['salary']}\$ ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 30,
                                    ),
                              ),
                              const Text(
                                'current Balance',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                'Name :  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              Text(
                                '  ${users[index]['name']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                'Email  :  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              Text(
                                '  ${users[index]['email']}',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const Text(
                                'Customer ID :  ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '  ${users[index]['id']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: defaultTextField(
                              controller: withdrawController,
                              type: TextInputType.number,
                              onValidate: (String? value) {
                                if (flag == 1 && value!.isEmpty) {
                                  return 'Can\'t be empty';
                                } else if (flag == 1 &&
                                    double.parse(withdrawController.text) >
                                        users[index]['salary']) {
                                  return 'You don\'t have enough Money';
                                }
                                return null;
                              },
                              label: 'WithDraw Amount',
                              prefix: Icons.monetization_on,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8),
                            child: defaultButton(
                              isUpper: false,
                              background: Colors.black26,
                              width: 100.0,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Withdraw?'),
                                        content: const Text(
                                            'Are You Sure to Withdraw this Money?'),
                                        actions: [
                                          TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Failed!'),
                                                  ),
                                                );
                                              }),
                                          TextButton(
                                            child: const Text('Yes',
                                                style: TextStyle(
                                                    color: Colors.green)),
                                            onPressed: () {
                                              flag = 1;
                                              if (formKey.currentState!
                                                  .validate()) {
                                                BankCubit.get(context).withdraw(
                                                    users[index],
                                                    double.parse(
                                                        withdrawController
                                                            .text));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Success operation!'),
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              } else {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Failed!'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              text: 'Withdraw',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: defaultTextField(
                              onValidate: (value) {
                                if (flag == 2 && value!.isEmpty) {
                                  return 'Can\'t be empty';
                                }
                                if (flag == 2 &&
                                    double.parse(transferController.text) >
                                        users[index]['salary']) {
                                  return 'You don\'t have enough Money';
                                }
                                return null;
                              },
                              controller: transferController,
                              type: TextInputType.number,
                              label: 'Transfer Amount ',
                              prefix: Icons.wifi_protected_setup,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8),
                            child: defaultButton(
                              width: 100,
                              isUpper: false,
                              background: Colors.grey,
                              onTap: () {
                                flag = 2;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Transfer Money?'),
                                        content: const Text(
                                            'Are You Sure to Transfer this Money?'),
                                        actions: [
                                          TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Failed!'),
                                                  ),
                                                );
                                              }),
                                          TextButton(
                                            child: const Text('Yes',
                                                style: TextStyle(
                                                    color: Colors.green)),
                                            onPressed: () {
                                              flag = 2;
                                              if (formKey.currentState!
                                                  .validate()) {
                                                BankCubit.get(context).transfer(
                                                    index,
                                                    double.parse(
                                                        transferController
                                                            .text),
                                                    int.parse(
                                                        idController.text));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Success operation!'),
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              } else {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Failed!'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              text: 'Transfer',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 120, left: 10),
                      child: defaultTextField(
                        onValidate: (value) {
                          if (flag == 2 && value!.isEmpty) {
                            return 'Enter Customer ID Which you will send the money';
                          }
                          if (flag == 2 &&
                              (users[index]['id'] ==
                                      int.parse(idController.text) ||
                                  int.parse(idController.text) < 0 ||
                                  int.parse(idController.text) > 10)) {
                            return ' ID not founded';
                          }

                          return null;
                        },
                        controller: idController,
                        type: TextInputType.number,
                        label: 'To Customer ID',
                        prefix: Icons.person,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
