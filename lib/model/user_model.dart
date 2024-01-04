import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String name;
  final String email;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final bool isVerified;
  final List<String> following;
  final List<String> follower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserModel({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.isVerified,
    required this.following,
    required this.follower,
    required this.createdAt,
    required this.updatedAt,
  });

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          profilePic == other.profilePic &&
          bannerPic == other.bannerPic &&
          uid == other.uid &&
          bio == other.bio &&
          isVerified == other.isVerified &&
          following == other.following &&
          follower == other.follower);

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      profilePic.hashCode ^
      bannerPic.hashCode ^
      uid.hashCode ^
      bio.hashCode ^
      isVerified.hashCode ^
      following.hashCode ^
      follower.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' name: $name,' +
        ' email: $email,' +
        ' profilePic: $profilePic,' +
        ' bannerPic: $bannerPic,' +
        ' uid: $uid,' +
        ' bio: $bio,' +
        ' isVerified: $isVerified,' +
        ' following: $following,' +
        ' follower: $follower,' +
        '}';
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    bool? isVerified,
    List<String>? following,
    List<String>? follower,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      following: following ?? this.following,
      follower: follower ?? this.follower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'profilePic': this.profilePic,
      'bannerPic': this.bannerPic,
      'bio': this.bio,
      'isVerified': this.isVerified,
      'following': this.following,
      'follower': this.follower,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      profilePic: map['profilePic'],
      bannerPic: map['bannerPic'],
      uid: map['\$id'],
      bio: map['bio'],
      isVerified: map['isVerified'],
      following: List<String>.from(map['following']),
      follower: List<String>.from(map['follower']),
      createdAt: DateTime.parse(map['\$createdAt']),
      updatedAt: DateTime.parse(map['\$updatedAt']),
    );
  }

  //</editor-fold>
}
