import 'package:flutter/material.dart';

abstract class ChatMediator{
  void sendMessage(String msg, User user);

  void addUser(User user);
}

abstract class User {
  final ChatMediator mediator;
  final String name;

  User(this.mediator, this.name);

  void send(String msg);
  void receive(String msg);
}

class ChatMediatorImpl extends ChatMediator {
  late List<User> _users;

  ChatMediatorImpl() {
    _users = [];
  }

  @override
  void addUser(User user) {
    _users.add(user);
  }

  @override
  void sendMessage(String msg, User user) {
    for(User u in _users) {
      if(u != user) {
        u.receive(msg);
      }
    }
  }
}

class UserImpl extends User {
  UserImpl(ChatMediator med, String name) : super(med, name);

  @override
  void send(String msg) {
    debugPrint('$name: Sending Message=$msg');
    mediator.sendMessage(msg, this);
  }

  @override
  void receive(String msg) {
    debugPrint('$name: Received Message:$msg');
  }
}


void main() {
  ChatMediator mediator = ChatMediatorImpl();
  User user1 = UserImpl(mediator, "Pankaj");
  User user2 = UserImpl(mediator, "Lisa");
  User user3 = UserImpl(mediator, "Saurabh");
  User user4 = UserImpl(mediator, "David");
  mediator.addUser(user1);
  mediator.addUser(user2);
  mediator.addUser(user3);
  mediator.addUser(user4);

  user1.send("Hi All");
}
