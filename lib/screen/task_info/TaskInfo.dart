import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants/constant.dart';
import 'package:frontend/screen/components/loading_icon.dart';
import 'package:frontend/screen/task/TaskScreen.dart';
import 'package:frontend/screen/task/bloc/task_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class TaskInfo extends StatefulWidget {
  dynamic taskInfo;

  TaskInfo(this.taskInfo, {super.key});

  @override
  State<StatefulWidget> createState() => _taskInfoState();
}

class _taskInfoState extends State<TaskInfo> {
  late TaskBloc bloc;
  late dynamic taskInfo;
  DateTime? _selectedDate;
  final List<String> statusList = <String>['To do', 'On progress', 'Done'];
  late String dropdownValue;
  late String priorityText;
  final TextEditingController commentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late List<String> fileType;
  late List<String> fileName;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    taskInfo = widget.taskInfo;
    dropdownValue = statusList.first;
    priorityText = taskInfo['priority'];
    fileType = [];
    fileName = [];
    _selectedDate = DateTime.parse(taskInfo['deadline']);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc()..add(TaskInfoEvent(taskInfo)),
      child: Builder(
        builder: (context) => _buildViewChild(context),
      ),
    );
  }

  Widget _buildViewChild(BuildContext context) {
    bloc = BlocProvider.of<TaskBloc>(context);
    return BlocBuilder<TaskBloc, TaskState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == TaskStatus.loading) {
            return const Center(
              child: LoadingIcon(),
            );
          }
          return Scaffold(
            body: Column(children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 236, 233, 232),
                    ),
                  ),
                ),
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15, top: 30),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return TaskScreen();
                        }));
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "task".tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String? topicId = prefs.getString(TOPIC_ID);
                        String? role = prefs.getString(ROLE);
                        String? studentNumber = prefs.getString(STUDENT_NUMBER);
                        String? userNumber = prefs.getString(USER_NUMBER);

                        String description = "";
                        if(descriptionController.text.isNotEmpty) {
                          description = descriptionController.text;
                          final addDescriptionUrl = Uri.parse("${HOST}add-description/${taskInfo['taskID']}");
                          Map<String, String> bodyData = {'description': description};
                          String jsonBody = jsonEncode(bodyData);
                          await http.post(addDescriptionUrl,
                            headers: {"Content-Type": "application/json"}, body: jsonBody);
                        }

                        if(_selectedDate != null) {
                          if(role == "Student") {
                            if(taskInfo['reporter'] != userNumber) {
                              final changeDeadlineUrl = Uri.parse("${HOST}deadline/${taskInfo['taskID']}/$userNumber/${taskInfo['reporter']}");
                              Map<String, String> bodyData = {'deadline': _selectedDate.toString()};
                              String jsonBody = jsonEncode(bodyData);
                              await http.put(changeDeadlineUrl, body: jsonBody);
                            }
                          } else {
                            final changeDeadlineUrl = Uri.parse("${HOST}deadline/${taskInfo['taskID']}/$userNumber/$studentNumber");
                              Map<String, String> bodyData = {'deadline': _selectedDate.toString()};
                              String jsonBody = jsonEncode(bodyData);
                              await http.put(changeDeadlineUrl, body: jsonBody);
                          }
                        } 

                        if(taskInfo['status'] != dropdownValue) {
                          String newStatus = dropdownValue.toLowerCase();
                          newStatus = newStatus.replaceAll(' ', "-");
                          final changeStatusUrl = Uri.parse("${HOST}change-status/${taskInfo['taskID']}/$newStatus");
                          await http.put(changeStatusUrl);
                        }

                        if(taskInfo['priority'] != priorityText) {
                          final changePriority = Uri.parse("${HOST}set-prio/${taskInfo['taskID']}/$userNumber/$priorityText");
                          await http.put(changePriority);
                        }

                        final getTaskByIdUrl = Uri.parse("${HOST}get-task-by-id/${taskInfo['taskID']}");
                        final response = await http.get(getTaskByIdUrl);
                        if(response.statusCode == 200) {
                          dynamic editedTask = jsonDecode(utf8.decode(response.bodyBytes));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return TaskInfo(editedTask);
                          }));
                        }
                      },
                      child: const Icon(
                        Icons.done,
                        size: 24,
                      ),
                    )
                  ]),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 240, 240, 240),
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.lock,
                      size: 18,
                      color: Color.fromARGB(255, 109, 110, 111),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Private to members of its project".tr(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 109, 110, 111),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              taskInfo['taskName'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Assignee".tr(),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Builder(builder: (context) {
                                      return Text(
                                        state.assignee['userName'] ?? "Unknown",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      );
                                    })
                                  ],
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'project'.tr(),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Builder(builder: (context) {
                                      return Text(
                                        state.projectInfo["projectName"] ??
                                            "Unknown",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      );
                                    })
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () => selectDate(context),
                              child: Row(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Due date".tr(),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        _selectedDate == null
                                            ? tr(
                                                "Pick a date") // Change this line
                                            : DateFormat('dd MM yyyy')
                                                .format(_selectedDate!),
                                        style: _selectedDate == null
                                            ? TextStyle(
                                                color: Colors.grey.shade400)
                                            : const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "topic".tr(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  state.topicInfo['topicName'] ?? "Unknown",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                DropdownMenu<String>(
                                  width: 150,
                                  textStyle: TextStyle(color: Colors.grey),
                                  inputDecorationTheme: InputDecorationTheme(
                                    border: InputBorder.none,
                                  ),
                                  initialSelection: taskInfo['status'] == "to-do" ? "To do" : taskInfo['status'] == "on-progress" ? "On progress" : "Done",
                                  onSelected: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  dropdownMenuEntries: statusList
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Priority".tr(),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ),
                            Expanded(
                                child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: ((BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            height: 300,
                                            width: 250,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "Choose priority".tr(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        priorityText = "-";
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        "-",
                                                        style: TextStyle(
                                                            fontSize: 22),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        priorityText = "High";
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: 100,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    240,
                                                                    106,
                                                                    106)),
                                                        child: Center(
                                                          child:
                                                              Text("High".tr()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        priorityText = "Medium";
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: 100,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    141,
                                                                    113)),
                                                        child: Center(
                                                          child: Text(
                                                              "Medium".tr()),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        priorityText = "Low";
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        width: 100,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    241,
                                                                    189,
                                                                    108)),
                                                        child: Center(
                                                          child:
                                                              Text("Low".tr()),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }));
                                },
                                child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: priorityText == "-"
                                      ? null
                                      : priorityText == "High"
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 240, 106, 106))
                                          : priorityText == "Medium"
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: const Color.fromARGB(
                                                      255, 236, 141, 113))
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: const Color.fromARGB(
                                                      255, 241, 189, 108)),
                                  child: Center(
                                    child: Text(
                                      priorityText.tr(),
                                      style: priorityText == "-"
                                          ? const TextStyle(fontSize: 20)
                                          : const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "description".tr(),
                              style: TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            taskInfo['description'] != null
                                ? Text(
                                    taskInfo['description'],
                                    style: TextStyle(fontSize: 18),
                                  )
                                : TextField(
                                  controller: descriptionController,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Add more detail for this task"
                                                .tr(),
                                        border: InputBorder.none),
                                  )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 0.8,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Attachments"),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: taskInfo['attachments'] != null
                                    ? taskInfo['attachments'].length + 1
                                    : 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 20, right: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: ((BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  height: 170,
                                                  width: 150,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15,
                                                            left: 15),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          Text(
                                                            "Attachment".tr(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              final ImagePicker
                                                                  picker =
                                                                  ImagePicker();
                                                              final XFile?
                                                                  image =
                                                                  await picker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                              if (image !=
                                                                  null) {
                                                                fileType.add(
                                                                    "image");
                                                                fileName.add(
                                                                    image.name);
                                                                File imgFile =
                                                                    File(image
                                                                        .path);
                                                                List<int>
                                                                    imgFileBytes =
                                                                    imgFile
                                                                        .readAsBytesSync();

                                                                setState(() {
                                                                  if (taskInfo[
                                                                          'attachments'] ==
                                                                      null) {
                                                                    taskInfo[
                                                                        'attachments'] = [];
                                                                  }
                                                                  taskInfo[
                                                                          'attachments']
                                                                      .add(
                                                                          imgFileBytes);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons
                                                                    .photo_library_outlined),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "Photo Gallery"
                                                                      .tr(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            height: 0.8,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              FilePickerResult?
                                                                  result =
                                                                  await FilePicker
                                                                      .platform
                                                                      .pickFiles(
                                                                type: FileType
                                                                    .custom,
                                                                allowedExtensions: [
                                                                  'pdf',
                                                                  'doc',
                                                                  'docx',
                                                                  'mp4',
                                                                  'xlsx',
                                                                  'pptx',
                                                                  'png',
                                                                  'jpg',
                                                                  'jpeg'
                                                                ],
                                                              );

                                                              if (result !=
                                                                  null) {
                                                                fileType.add(result
                                                                    .files
                                                                    .single
                                                                    .extension!);
                                                                fileName.add(
                                                                    result
                                                                        .files
                                                                        .single
                                                                        .name);
                                                                File file =
                                                                    File(result
                                                                        .files
                                                                        .single
                                                                        .path!);
                                                                List<int>
                                                                    fileBytes =
                                                                    file.readAsBytesSync();
                                                                setState(() {
                                                                  if (taskInfo[
                                                                          'attachments'] ==
                                                                      null) {
                                                                    taskInfo[
                                                                        'attachments'] = [];
                                                                  }
                                                                  taskInfo[
                                                                          'attachments']
                                                                      .add(
                                                                          fileBytes);
                                                                });
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(Icons
                                                                    .attach_file),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "Document"
                                                                        .tr(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                        child: Container(
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(width: 1)),
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        // Thumbnail Image
                                        GestureDetector(
                                          onTap: () async {
                                            Directory directory =
                                                await getApplicationCacheDirectory();
                                            String filePath =
                                                '${directory.path}/${fileName[index - 1]}';
                                            File imageFile = File(filePath);
                                            imageFile.writeAsBytesSync(
                                                taskInfo['attachments']
                                                    [index - 1]);
                                            OpenFile.open(filePath);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10, right: 10),
                                            child: fileType[index - 1] ==
                                                    "image"
                                                ? Image.memory(
                                                    taskInfo['attachments']
                                                        [index - 1],
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    height: 60,
                                                    // width: 260,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          getIconForFileType(
                                                              fileType[
                                                                  index - 1]),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                fileName[
                                                                    index - 1],
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                fileType[
                                                                    index - 1],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setState(() {
                                              taskInfo['attachments']
                                                  .removeAt(index - 1);
                                              fileName.removeAt(index - 1);
                                              fileType.removeAt(index - 1);
                                            });
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.clear_rounded,
                                                size: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: taskInfo['notifications'].length,
                            itemBuilder: (context, index) {
                              if(taskInfo['notifications'][index]['type'] == "created") {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(taskInfo['notifications'][index]['message'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),), 
                                      // const SizedBox(height: 5,), 
                                      Text(taskInfo['notifications'][index]['time'], style: TextStyle(color: Color.fromARGB(255, 125, 126, 127)),)],),
                                );
                              } else if(taskInfo['notifications'][index]['type'] == "notice") {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(taskInfo['notifications'][index]['message'], style: TextStyle(fontSize: 16),), 
                                      // const SizedBox(height: 5,), 
                                      Text(taskInfo['notifications'][index]['time'], style: TextStyle(color: Color.fromARGB(255, 125, 126, 127)),)],),
                                );
                              }
                            
                            }),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(width: 0.5))),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextField(
                          controller: commentController,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              hintText:
                                  "Ask a question or post an update...".tr(),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          String comment = commentController.text;
                          if (comment.isNotEmpty) {}
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue),
                          child: const Center(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          );
        });
  }

  Widget getIconForFileType(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Image.asset('assets/icons/pdf.png', width: 30, height: 30);
      case 'doc':
      case 'docx':
        return Image.asset('assets/icons/word.png', width: 30, height: 30);
      case 'mp4':
        return Image.asset('assets/icons/mp4.png', width: 30, height: 30);
      case 'xlsx':
        return Image.asset('assets/icons/xlsx.png', width: 30, height: 30);
      case 'pptx':
        return Image.asset('assets/icons/pptx-file.png', width: 30, height: 30);
      default:
        return Icon(Icons.insert_drive_file, size: 30);
    }
  }
}
