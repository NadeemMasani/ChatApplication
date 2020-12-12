import 'package:ChatApplication/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{

  /// Save UserInfo In SharedPreferences
  static Future<bool> saveUserData(UserModel user) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("firstName", user.firstName);
    preferences.setString("lastName", user.lastName);
    preferences.setString("email", user.email);
    preferences.setString("password", user.password);
    preferences.setInt("phoneNumber", user.phoneNumber);

  }

  /// Fetch UserInfo  from SharedPreference
  static Future<UserModel> retrieveUserInfo() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserModel user = new UserModel();
    user.firstName = await preferences.getString("firstName");
    user.lastName=  await preferences.getString("lastName");
    user.email = await preferences.getString("email");
    user.password = await preferences.getString("password");
    user.phoneNumber = await preferences.getInt("phoneNumber");
    return user;
  }


}