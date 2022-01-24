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

class AppGetPostOnFailedState extends AppStates {
  final String error;

  AppGetPostOnFailedState(this.error);
}

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

class AppGetCommentsOnLoadingState extends AppStates {}

class AppGetCommentsOnSuccessState extends AppStates {}

class AppGetCommentsOnFailedState extends AppStates {
  final String error;

  AppGetCommentsOnFailedState(this.error);
}
