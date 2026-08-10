
enum TaskItemActionsEnum {
  //بدون الي داخل الاقواس رح يظهروا سمول ففي القائمة يعني اعمللت override
  markAsDone(name: "Mark As Done"),
  delete (name: "Delete"),
  edit (name: "Edit");



  final String name;

  const TaskItemActionsEnum({required this.name});
}