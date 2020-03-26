/*
 * Developed by Nhan Cao on 12/25/19 2:33 PM.
 * Last modified 12/25/19 2:33 PM.
 */

abstract class BaseModel<T> {

  Map<String, dynamic> toMap();

  T fromMap(Map<String, dynamic> map);
}