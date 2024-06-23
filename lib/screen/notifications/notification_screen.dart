import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pHUST/constants/constant.dart';
import 'package:pHUST/screen/components/loading_icon.dart';
import 'package:pHUST/screen/notifications/bloc/notification_bloc.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc()..add(NotificationInitialEvent()),
      child: Builder(
        builder: (context) => _buildViewChild(context),
      ),
    );
  }
  
  Widget _buildViewChild (BuildContext context) {
  bloc = BlocProvider.of<NotificationBloc>(context);
  return Scaffold(
    body: Column(
      children: [
        Container(
          height: 100,
          color: Color.fromARGB(255, 191, 29, 45),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 120,),
                Center(child: Text("Notification".tr(), style: const TextStyle(color: Colors.white, fontSize: 20),),)
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<NotificationBloc, NotificationState>(
            bloc: bloc,
            builder: (context, state) {
              if (state.status == NotificationStatus.loading) {
                return const Center(
                  child: LoadingIcon(),
                );
              }
              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    "no_notification".tr(),
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Expanded(child: 
                ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: ()  {
                        bloc.add(NotificationChangeStatusEvent(index));
                      },
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: state.items[index]['type'] != "suggest topic" ? Container(
                              width: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.shade300
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.items[index]["type"], style: TextStyle(fontSize: 20, 
                                      fontWeight: ((state.items[index]['status'] == null || state.items[index]['status'] == false) ? FontWeight.bold : FontWeight.normal)),),
                                    const SizedBox(height: 10,),
                                    Text(state.items[index]['time'], style: TextStyle(color: Colors.grey),),
                                    const SizedBox(height: 15,),
                                    state.items[index]['type'] == 'created' ?
                                      Text(state.items[index]["message"].toString().substring(0, state.items[index]["message"].length - 9) + " task " + state.task[index] + " in project " + state.project[index], style: TextStyle(fontSize: 16,
                                        fontWeight: ((state.items[index]['status'] == null || state.items[index]['status'] == false) ? FontWeight.bold : FontWeight.normal))) :
                                      Text(state.items[index]["message"] + " in task " + state.task[index] + " in project " + state.project[index], style: TextStyle(fontSize: 16,
                                        fontWeight: ((state.items[index]['status'] == null || state.items[index]['status'] == false) ? FontWeight.bold : FontWeight.normal)),)
                                  ],
                                ),
                              ),
                            ) : 
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.shade300
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.items[index]["type"], style: TextStyle(fontSize: 20, 
                                      fontWeight: ((state.items[index]['status'] == null || state.items[index]['status'] == false) ? FontWeight.bold : FontWeight.normal)),),
                                    const SizedBox(height: 10,),
                                    Text(state.items[index]['time'], style: TextStyle(color: Colors.grey),),
                                    const SizedBox(height: 15,),
                                    Text(state.items[index]['message']),
                                    const SizedBox(height: 15,),
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor
                                                .resolveWith(
                                          (states) {
                                            return Colors.white;
                                          },
                                        ),
                                        side:
                                            MaterialStateBorderSide
                                                .resolveWith(
                                          (states) {
                                            return const BorderSide(
                                                color:
                                                    Colors.red);
                                          },
                                        ),
                                        shape: MaterialStateProperty
                                            .all<
                                                RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        bloc.add(NotificationRejectTopic(index));
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                          return NotificationScreen();
                                        }));
                                      },
                                      child: Text(
                                        "Reject".tr(),
                                        style: const TextStyle(
                                            color: Colors.red),
                                      )),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor
                                                  .resolveWith(
                                            (states) {
                                              return Colors.white;
                                            },
                                          ),
                                          side:
                                              MaterialStateBorderSide
                                                  .resolveWith(
                                            (states) {
                                              return const BorderSide(
                                                  color:
                                                      Colors.blue);
                                            },
                                          ),
                                          shape: MaterialStateProperty
                                              .all<
                                                  RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                            bloc.add(NotificationAcceptTopic(index));
                                        },
                                        child: Text(
                                          "Accept".tr(),
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        )),
                                  ],)
                                  ],
                                ),
                              ),
                            ),
                            
                            
                          ), const SizedBox(height:20,)
                        ],
                      ),
                    );
                  }
                )
              );
            }
          )
        )
      ],),
  );
}
}

