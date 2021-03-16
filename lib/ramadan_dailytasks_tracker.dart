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
import 'package:productive_ramadan_app/repositories/sharedpreferences.dart';
import 'package:productive_ramadan_app/utils/appbar.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'dart:core';

import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/task_app_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'answer_card.dart';
import 'utils/side_drawer.dart';

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

  @override
  Widget build(BuildContext context) {
    String score =
        state.correct.length.toString() + "/" + tasks.length.toString();

    print(state.incorrect.asMap());

    // displayIncorrect() {
    //   return ListView.builder(itemBuilder: (context, index) => state.incorrect[index]);
    // }
    //List<DailyTasksScore> _dailyScores;

    // _saveScoreToSharedPrefs(List<String> newScore) async {
    //   await SharedPrefs.setNewDailyScore(newScore);
    // }

    void _startNextDayTaskTracker() async {
      context.refresh(taskRepositoryProvider);
      context.read(taskControllerProvider).reset();

      day++;
      print("day after ++ $day");
      print("Day before shared prefs $day");
      SharedPrefs.setDay(day);
      if (day >= 29) {
        day = 29;
      }
    }

    getDay() {
      int newDay = SharedPrefs.getDay();
      if (isLoading) {
        newDay++;
        isLoading = false;
      }
      // print("New Day from Shared Prefs $newDay");
      return newDay;
    }

    int newDay = getDay();
    var stringDay = newDay.toString();

    print("New day from shared Prefs $stringDay");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "${score.toString()}",
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "CORRECT",
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 40.0,
        ),
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              button.buildButton(kDarkTeal, Colors.amberAccent,
                  "Day ${newDay + 1} Tasks", _startNextDayTaskTracker),
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
