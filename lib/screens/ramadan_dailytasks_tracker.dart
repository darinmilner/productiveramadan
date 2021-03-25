import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:productive_ramadan_app/controllers/task_controller.dart';
import 'package:productive_ramadan_app/controllers/task_state.dart';
import 'package:productive_ramadan_app/models/daily_tasks_model.dart';
import 'package:productive_ramadan_app/models/dailytasks_score_model.dart';
import 'package:productive_ramadan_app/models/failure_model.dart';
import 'package:productive_ramadan_app/repositories/dailytask_repository.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'dart:core';

import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/task_app_error.dart';

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

class TaskResults extends StatelessWidget {
  final TaskState state;
  final List<DailyTaskModel> tasks;
  bool isLoading = true;
  static int day = 1;
  TaskResults({Key key, @required this.state, @required this.tasks})
      : super(key: key);
  //TaskController taskController = TaskController();

  String text = "";
  @override
  Widget build(BuildContext context) {
    String score =
        state.correct.length.toString() + "/" + tasks.length.toString();

    print(state.incorrect.length.toString());

    if (state.incorrect.length != 0) {
      text = "Ramadan tasks that were not completed today!";
    } else {
      text = "All Tasks are completed today Alhamdulillah";
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "${score.toString()}",
            style: TextStyle(
              color: Colors.amberAccent,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          "COMPLETED",
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 28,
              color: Colors.teal[800],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: state.incorrect.length != 0
              ? ListView.builder(
                  itemCount: state.incorrect.length,
                  itemBuilder: (ctx, index) {
                    print("Listview index: ${index}");

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
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "${state.incorrect[index].correctTaskAnswer}",
                            style: TextStyle(
                              fontSize: 20,
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
                    padding: const EdgeInsets.all(15.0),
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
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "JazakAllahu Khairun, All are complete! May Allah accept your ibadah",
                          style: kDailyTrackerTestStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              "May Allah help you to increase your ibadah throughout Ramadan and after",
              style: kDailyTrackerTestStyle,
            ),
          ),
        ),
        Divider(
          height: 20.0,
        ),
        Center(
            child: Text(
          "Please Remember to fast tomorrow.",
          style: kDailyTrackerTestStyle,
          textAlign: TextAlign.center,
        )),
        const SizedBox(
          height: 40.0,
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
                () => Navigator.of(context)
                    .pushReplacementNamed(LandingPage.routeName),
              ),
            ],
          ),
        ),
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
