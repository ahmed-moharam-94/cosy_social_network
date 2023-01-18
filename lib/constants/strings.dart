import 'enums.dart';

const fcmServer =
    'key=AAAAWEfAMUY:APA91bGPLDaCAl7yeN6JR5cV6Houl0jR7330-zgdW81_1TG7yy4zwdpojPX8fczAU3i3rcW4WwM0Dh3FbvNTbvaAdlKHPj4UTXRP0fb4rPyb2EYCh7HVnfjGsA3QwVGoyT8nD6LZkAk_';
const imageMessageBucket = 'https://firebasestorage.googleapis.com/v0/b/zaghroota-9cfe2.appspot.com/o/chatImages';
const applicationEmail = 'cozy.social.network@gmail.com';
const gmailApplicationPassword = 'gjaifjymaleldppc';


const notificationChannelName = 'channel_id_1121212';
const notificationChannelId = 'my_very_unique_social_app_id';
const enterVerificationCode = 'Enter the code sent to your email.';
const didNotReceiveCode = 'Didn\'t receive an email';
const bioHint =
    'Describe your opinion within 50 characters.';

const profileUpdated = 'Your profile has been updated successfully.';
const completeYourProfile = 'Please complete your profile.';
const yourPostHasBeenPublished = 'Your post has been published successfully, to manage your posts go to user posts screen.';
const writeYourOpinion = 'Please write your opinion.';
const noPostsYet = 'There is no posts yet.';
const editMyPost = 'Edit My Post.';
const deletePost = 'Are you sure you want to delete this post?';
const youDidNotReceiveRequests = 'You don\'t have any new requests now.';
const sentYouRequest = 'Sent you a request.';
const thePostOfUserWhoWantsToContactYou =
    'The post of the user who want to contact with you:';
const acceptTheRequestAlertDialogString = 'Accept the request?';
const rejectTheRequestString = 'Reject the request';
const alertDialogAcceptContentString =
    'If you accept the request you will be able to chat with the user.';
const alertDialogRejectContentString =
    'If you reject the request you will not be able to chat with the user.';
const startChatWithUser = 'You can now start to chat with this user.';
const youHaveRejectedRequest = 'You have rejected this request.';
const writeYourMessage = 'Write your message';
const sentYouFriendRequest = 'Sent you a friend request';


String statusText(RequestStatus status) {
  if (status == RequestStatus.friends) {
    return 'Friends';
  } else {
    return 'Request Sent';
  }
}