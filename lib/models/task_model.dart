
class TaskModel {
    final int id;
    final String taskName;
    final String taskDescription;
    final bool isHighPrio;
    bool isDone;

    TaskModel({
      required this.id,
     required this.taskName,
     required this.taskDescription,
     required this.isHighPrio,
     this.isDone=false,
    });

    factory TaskModel.fromJson(Map<String,dynamic>json){
      return TaskModel(
        id: json["id"],
        taskName: json["taskName"],
        taskDescription: json["taskDescription"],
        isHighPrio: json["isHighPrio"],
        isDone: json["isDone"] ?? false, // IF NULL SO MAKE IT FALSE
       );
    }

    Map<String,dynamic> toMap(){
      return{
        "id": id,
        "taskName": taskName,
    "taskDescription": taskDescription,
    "isHighPrio": isHighPrio,
        "isDone" : isDone ,
      };
    }
}