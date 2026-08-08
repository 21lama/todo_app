
class TaskModel {
    final String taskName;
    final String taskDescription;
    final bool isHighPrio;
    bool isDone;

    TaskModel({
     required this.taskName,
     required this.taskDescription,
     required this.isHighPrio,
     this.isDone=false,
    });

    factory TaskModel.fromJson(Map<String,dynamic>json){
      return TaskModel(
        taskName: json["taskName"],
        taskDescription: json["taskDescription"],
        isHighPrio: json["isHighprio"],
        isDone: json["isDone"] ?? false, // IF NULL SO MAKE IT FALSE
       );
    }

    Map<String,dynamic> toMap(){
      return{
        "taskName": taskName,
    "taskDescription": taskDescription,
    "isHighprio": isHighPrio,
        "isDone" : isDone ,
      };
    }
}