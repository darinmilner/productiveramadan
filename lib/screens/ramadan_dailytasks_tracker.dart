import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:productive_ramadan_app/controllers/pdf_api.dart';
import 'package:productive_ramadan_app/controllers/task_controller.dart';
import 'package:productive_ramadan_app/controllers/task_state.dart';
import 'package:productive_ramadan_app/models/daily_tasks_model.dart';
import 'package:productive_ramadan_app/models/failure_model.dart';
import 'package:productive_ramadan_app/repositories/dailytask_repository.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'dart:core';

import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/task_app_error.dart';

import '../admob_service.dart';
import '../utils/answer_card.dart';
import '../landing.dart';
import '../utils/side_drawer.dart';

final taskTrackerProvider = FutureProvider.autoDispose<List<DailyTaskModel>>(
  (ref) => ref.watch(taskRepositoryProvider).getDailyTasks(
        numTasks: 4,
        dayNumber: 1,
      ),
);
Button button = Button();

class DailyTasksTracker extends HookWidget {
  static const String routeName = "/tasktracker";

  MyAppBar _appBar = MyAppBar();
  @override
  Widget build(BuildContext context) {
    final taskQuestions = useProvider(taskTrackerProvider);
    final pageController = usePageController();

    print("Task questions ${taskQuestions}");

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: kBackgroundGreenGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _appBar.buildAppBar(context),
        drawer: SideDrawer(),
        body: taskQuestions.when(
          data: (questions) => _buildBody(context, pageController, questions),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => AppError(
            message: error is Failure ? error.message : "Something went wrong!",
          ),
        ),
        bottomSheet: taskQuestions.maybeWhen(
          data: (tasks) {
            final taskState = useProvider(taskControllerProvider.state);
            if (!taskState.answered) return const SizedBox.shrink();

            print(pageController.page.toString());
            return Container(
              height: 60.0,
              width: MediaQuery.of(context).size.width,
              child: button.buildButton(
                  kDarkTeal,
                  Colors.white,
                  pageController.page.toInt() + 1 < tasks.length
                      ? "Next Task"
                      : "See Results", () {
                context
                    .read(taskControllerProvider)
                    .nextTask(tasks, pageController.page.toInt());
                pageController.nextPage(
                  duration: const Duration(microseconds: 250),
                  curve: Curves.linear,
                );
              }),
            );
          },
          orElse: () => SizedBox.shrink(),
        ),
      ),
    );
  }
}

Widget _buildBody(
  BuildContext context,
  PageController pageController,
  List<DailyTaskModel> tasks,
) {
  if (tasks.isEmpty) return AppError(message: "No tasks found");
  final taskState = useProvider(taskControllerProvider.state);
  return taskState.status == TaskStatus.complete
      ? TaskResults(state: taskState, tasks: tasks)
      : TaskQuestions(
          pageController: pageController,
          state: taskState,
          tasks: tasks,
        );
}

class TaskResults extends StatefulWidget {
  final TaskState state;
  final List<DailyTaskModel> tasks;
  static int day = 1;
  TaskResults({Key key, @required this.state, @required this.tasks})
      : super(key: key);

  @override
  _TaskResultsState createState() => _TaskResultsState();
}

class _TaskResultsState extends State<TaskResults> {
  bool isLoading = true;

  String text = "";

  final ams = AdMobService();

  @override
  void initState() {
    super.initState();

    Admob.initialize();
  }

  @override
  Widget build(BuildContext context) {
    // String score = widget.state.correct.length.toString() +
    //     "/" +
    //     widget.tasks.length.toString();

    // if (widget.state.incorrect.length != 0) {
    //   text = "Ramadan tasks that were not completed today!";
    // } else {
    //   text = "All Tasks are completed today Alhamdulillah";
    // }
    text = "Today's Ramadan Goals.  Could you complete them?";
    List todaysTasks = [];
    for (int i = 0; i < widget.state.correct.length; i++) {
      todaysTasks.add(widget.state.correct[i]);
    }
    for (int i = 0; i < widget.state.incorrect.length; i++) {
      todaysTasks.add(widget.state.incorrect[i].task);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Text(
        //     // "${score.toString()}",
        //     "Today's Task Results",
        //     style: TextStyle(
        //       color: Colors.amberAccent,
        //       fontSize: 25.0,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        // Text(
        //   "COMPLETED",
        //   style: TextStyle(
        //     color: Colors.amberAccent,
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal[800],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          // child: widget.state.incorrect.length != 0
          child: widget.tasks.length != 0
              ? ListView.builder(
                  itemCount: widget.tasks.length,
                  itemBuilder: (ctx, index) {
                    print("Listview index: ${index}");
                    print(
                        "Todotask correct ${widget.tasks[index].correctTaskAnswer}");
                    print("todoTask ${todaysTasks[index]}");

                    // print("Answers ${widget.state.selectedAnswer[index]}" ??
                    //     "No answers");
                    //  print("Answers ${widget.state.correct[index]}");

                    return ListTile(
                        title: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.tealAccent,
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.green[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            //"${widget.state.incorrect[index].correctTaskAnswer}",
                            "${widget.tasks[index].correctTaskAnswer}",
                            //"${todaysTasks[index]}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ));
                  })
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.tealAccent,
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.green[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "JazakAllahu Khairun, May Allah accept your ibadah",
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "May Allah help you to increase your ibadah throughout Ramadan and after",
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Divider(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Center(
            child: Text(
          "Please Remember to fast tomorrow.",
          style: kDailyTrackerTestStyle,
          textAlign: TextAlign.center,
        )),
        const SizedBox(
          height: 20.0,
        ),
        Center(
            child: Text(
          "Get the PDF to review the daily Ramadan goals.",
          style: kDailyTrackerTestStyle,
          textAlign: TextAlign.center,
        )),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              button.buildButton(kDarkTeal, Colors.amberAccent, "Get PDF",
                  () async {
                final pdfFile = await PdfApi.generatePdf(
                  widget.tasks,
                );
                PdfApi.openFile(pdfFile);
              }),
            ],
          ),
        ),
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              button.buildButton(
                kDarkTeal,
                Colors.amberAccent,
                "Back To Home",
                () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LandingPage(),
                    ),
                    (route) => false),
              ),
            ],
          ),
        ),
        //AD
        AdmobBanner(
            adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.BANNER),
      ],
    );
  }
}

class TaskQuestions extends StatelessWidget {
  final PageController pageController;
  final TaskState state;
  final List<DailyTaskModel> tasks;

  const TaskQuestions({
    Key key,
    @required this.pageController,
    @required this.state,
    @required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = tasks[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question ${index + 1} of ${tasks.length}",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                HtmlCharacterEntities.decode(task.task),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                  fontFamily: "Syne",
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Divider(
              color: Colors.greenAccent,
              height: 32.0,
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Column(
              children: task.allPossibleAnswers
                  .map(
                    (e) => AnswerCard(
                      answer: e,
                      isSelected: e == state.selectedAnswer,
                      isCorrect: e == task.correctTaskAnswer,
                      isDisplayingAnswer: state.answered,
                      onTap: () => context
                          .read(taskControllerProvider)
                          .submitAnswer(task, e),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
