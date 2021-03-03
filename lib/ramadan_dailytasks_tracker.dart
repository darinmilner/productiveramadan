import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:productive_ramadan_app/controllers/task_controller.dart';
import 'package:productive_ramadan_app/controllers/task_state.dart';
import 'package:productive_ramadan_app/models/daily_tasks_model.dart';
import 'package:productive_ramadan_app/models/failure_model.dart';
import 'package:productive_ramadan_app/repositories/dailytask_repository.dart';
import 'package:productive_ramadan_app/utils/buttons/button.dart';
import 'dart:core';

import 'package:productive_ramadan_app/utils/constants.dart';
import 'package:productive_ramadan_app/utils/task_app_error.dart';

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
        appBar: AppBar(
          title: Center(
            child: Text(
              "Productive Ramadan",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
        ),
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
            return button.buildButton(
                kDarkTeal,
                Colors.white,
                pageController.page.toInt() + 1 < tasks.length
                    ? "Next Task"
                    : "See Results",
                //submitTask,
                () {
              context
                  .read(taskControllerProvider)
                  .nextTask(tasks, pageController.page.toInt());
              pageController.nextPage(
                duration: const Duration(microseconds: 250),
                curve: Curves.linear,
              );
            });
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
  static int day = 1;
  TaskResults({Key key, @required this.state, @required this.tasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double score = state.correct.length / tasks.length;
    void _startNextDayTaskTracker() {
      context.refresh(taskRepositoryProvider);
      context.read(taskControllerProvider).reset();
      print("Score $score");
      day++;
    }

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
        button.buildButton(kDarkTeal, Colors.amberAccent, "Day ${day} Tasks",
            _startNextDayTaskTracker),
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                HtmlCharacterEntities.decode(task.task),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
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
