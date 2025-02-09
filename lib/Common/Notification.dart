import 'package:flutter/material.dart';

class LoginPageNotification extends Notification {
  LoginPageNotification();
}

class IsUnReadNotification extends Notification {
  IsUnReadNotification();
}

class ShowMessageNotification extends Notification {
  String title;
  String image;

  ShowMessageNotification(this.image, this.title);
}

class LaunchAdNotification extends Notification {
  LaunchAdNotification();
}

