// import 'package:get/get.dart';
// import '../db/db_helper.dart';
// import '../models/task_model.dart';

// class TaskController extends GetxController {
//   @override
//   void onReady() {
//     super.onReady();
//     getTasks();
//     loadCategories();
//   }

//   var taskList = <Task>[].obs;
//   var filteredTaskList = <Task>[].obs;
//   var isSearching = false.obs;
//   var selectedCategory = 'All'.obs;
//   var selectedPriority = 'All'.obs;
//   // categories observable list for filters and dropdowns
//   var categories = <String>[].obs;

//   Future<int> addTask({Task? task}) async {
//     return await DBHelper.instance.insert(task!);
//   }

//   // ===== Category management =====
//   Future<void> loadCategories() async {
//     try {
//       final cats = await DBHelper.instance.getCategories();
//       if (cats.isEmpty) {
//         // seed defaults if none in DB
//         final defaultCats = ['Work', 'Personal', 'Shopping', 'Health'];
//         for (var c in defaultCats) {
//           await DBHelper.instance.insertCategory(c);
//         }
//         categories.assignAll(['All', ...defaultCats]);
//       } else {
//         categories.assignAll(['All', ...cats]);
//       }
//       // if selectedCategory not present, reset to 'All'
//       if (!categories.contains(selectedCategory.value)) {
//         selectedCategory.value = 'All';
//       }
//     } catch (e) {
//       // fallback to defaults on error
//       categories.assignAll(['All', 'Work', 'Personal', 'Shopping', 'Health']);
//     }
//   }

//   Future<void> addCategory(String name) async {
//     final newName = name.trim();
//     if (newName.isEmpty) return;
//     try {
//       await DBHelper.instance.insertCategory(newName);
//     } catch (_) {}
//     // refresh local list
//     await loadCategories();
//     // set as selected
//     selectedCategory.value = newName;
//   }

//   void getTasks() async {
//     List<Map<String, dynamic>> tasks = await DBHelper.instance.query();
//     taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
//     filterTasks();
//   }

//   Future<void> delete(Task task) async {
//     await DBHelper.instance.delete(task);
//     getTasks();
//   }

//   Future<void> markTaskCompleted(int id) async {
//     await DBHelper.instance.updateCompleted(id);
//     getTasks();
//   }

//   Future<void> updateTaskInfo(Task task) async {
//     await DBHelper.instance.updateTask(task);
//     getTasks();
//   }

//   void filterTasks() {
//     List<Task> tempTasks = taskList;

//     if (selectedCategory.value != 'All') {
//       tempTasks = tempTasks
//           .where((task) => task.category == selectedCategory.value)
//           .toList();
//     }

//     if (selectedPriority.value != 'All') {
//       tempTasks = tempTasks
//           .where((task) => task.priority == selectedPriority.value)
//           .toList();
//     }

//     filteredTaskList.assignAll(tempTasks);
//   }

//   void searchTasks(String query) {
//     if (query.isEmpty) {
//       isSearching.value = false;
//       filterTasks();
//     } else {
//       isSearching.value = true;
//       List<Task> tempTasks = taskList.where((task) {
//         return task.title!.toLowerCase().contains(query.toLowerCase()) ||
//             task.description!.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//       filteredTaskList.assignAll(tempTasks);
//     }
//   }

//   void updateCategory(String category) {
//     selectedCategory.value = category;
//     filterTasks();
//   }

//   void updatePriority(String priority) {
//     selectedPriority.value = priority;
//     filterTasks();
//   }
// }

import 'package:get/get.dart';
import '../db/db_helper.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  var filteredTaskList = <Task>[].obs;
  var isSearching = false.obs;

  var categories = <String>[].obs;
  var selectedCategory = 'All'.obs;
  var selectedPriority = 'All'.obs;

  @override
  void onReady() {
    super.onReady();
    loadCategories();
    getTasks();
  }

  // ===== Tasks =====
  Future<void> getTasks() async {
    final list = await DBHelper.instance.queryTasks();
    taskList.assignAll(list.map((e) => Task.fromJson(e)).toList());
    filterTasks();
  }

  // Future<void> addTask(Task task, {required Task task}) async {
  //   await DBHelper.instance.insert(task);
  //   await getTasks();
  // }
  Future<int> addTask({Task? task}) async {
    return await DBHelper.instance.insert(task!);
  }

  Future<void> updateTaskInfo(Task task) async {
    await DBHelper.instance.updateTask(task);
    await getTasks();
  }

  Future<void> deleteTask(Task task) async {
    await DBHelper.instance.delete(task);
    await getTasks();
  }

  Future<void> markTaskCompleted(int id) async {
    await DBHelper.instance.updateCompleted(id);
    await getTasks();
  }

  // ===== Categories =====
  Future<void> loadCategories() async {
    final cats = await DBHelper.instance.getCategories();
    categories.assignAll(['All', ...cats]);
    if (!categories.contains(selectedCategory.value)) {
      selectedCategory.value = 'All';
    }
  }

  Future<void> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await DBHelper.instance.insertCategory(trimmed);
    await loadCategories();
    selectedCategory.value = trimmed;
  }

  // ===== Filters =====
  void filterTasks() {
    List<Task> tempTasks = List.from(taskList);

    if (selectedCategory.value != 'All') {
      tempTasks = tempTasks
          .where(
            (task) =>
                task.category?.toLowerCase() ==
                selectedCategory.value.toLowerCase(),
          )
          .toList();
    }

    if (selectedPriority.value != 'All') {
      tempTasks = tempTasks
          .where((task) => task.priority == selectedPriority.value)
          .toList();
    }

    filteredTaskList.assignAll(tempTasks);
  }

  // ===== Search =====
  void searchTasks(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      filterTasks();
      return;
    }

    isSearching.value = true;
    final lower = query.toLowerCase();

    final results = taskList.where((task) {
      final title = task.title?.toLowerCase().contains(lower) ?? false;
      final desc = task.description?.toLowerCase().contains(lower) ?? false;
      return title || desc;
    }).toList();

    filteredTaskList.assignAll(results);
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    filterTasks();
  }

  void updatePriority(String priority) {
    selectedPriority.value = priority;
    filterTasks();
  }
}
