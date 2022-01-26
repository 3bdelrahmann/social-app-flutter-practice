abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserOnLoadingState extends AppStates {}

class AppGetUserOnSuccessState extends AppStates {}

class AppGetUserOnFailedState extends AppStates {
  final String error;

  AppGetUserOnFailedState(this.error);
}

class AppChangeNavBarState extends AppStates {}

class AppProfileImagePickedOnSuccessState extends AppStates {}

class AppProfileImagePickedOnFailedState extends AppStates {}

class AppCoverImagePickedOnSuccessState extends AppStates {}

class AppCoverImagePickedOnFailedState extends AppStates {}

class AppUploadProfileImageOnLoadingState extends AppStates {}

class AppUploadProfileImageOnSuccessState extends AppStates {}

class AppUploadProfileImageOnFailedState extends AppStates {}

class AppUploadCoverImageOnLoadingState extends AppStates {}

class AppUploadCoverImageOnSuccessState extends AppStates {}

class AppUploadCoverImageOnFailedState extends AppStates {}

class AppUpdateUserDataOnFailedState extends AppStates {}

class AppClearImageFilesState extends AppStates {}

//Create post

class AppCreatePostOnLoadingState extends AppStates {}

class AppCreatePostOnSuccessState extends AppStates {}

class AppCreatePostOnFailedState extends AppStates {}

class AppPostImagePickedOnSuccessState extends AppStates {}

class AppPostImagePickedOnFailedState extends AppStates {}

class AppUploadPostImageOnLoadingState extends AppStates {}

class AppUploadPostImageOnFailedState extends AppStates {}

class AppRemovePostImageState extends AppStates {}

//Get post

class AppGetPostOnLoadingState extends AppStates {}

class AppGetPostOnSuccessState extends AppStates {}

//Like post

class AppLikePostOnSuccessState extends AppStates {}

class AppLikePostOnFailedState extends AppStates {
  final String error;

  AppLikePostOnFailedState(this.error);
}

//Write a comment on post

class AppCommentOnPostOnSuccessState extends AppStates {}

class AppCommentOnPostOnFailedState extends AppStates {
  final String error;

  AppCommentOnPostOnFailedState(this.error);
}

//Get comments

class AppGetCommentsOnSuccessState extends AppStates {}

//Get all users

class AppGetAllUserOnLoadingState extends AppStates {}

class AppGetAllUserOnSuccessState extends AppStates {}

class AppGetAllUserOnFailedState extends AppStates {
  final String error;

  AppGetAllUserOnFailedState(this.error);
}

//Chat

class AppSendMessageOnSuccessState extends AppStates {}

class AppSendMessageOnFailedState extends AppStates {}

class AppGetMessageOnSuccessState extends AppStates {}

// Get user by ID

class AppGetUserByIdOnSuccessState extends AppStates {}

class AppGetUserByIdOnFailedState extends AppStates {}
