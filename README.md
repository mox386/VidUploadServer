# VidUploadServer

This is a set of bash and python scripts for running a video upload server on a Raspberry Pi. The end result should be a Raspberry Pi that you merely plug in a USB drive and it uploads the videos to the 
proper Video Sharing website (Youtube, Vimeo, or Dailymotion) without any more input. This means you copy the videos onto the thumb drive, plug it into a pi, and don't worry until it's finished uploading.

On a usb drive make a folder with a name identifying the channel. 

The script will begin uploads automatically within 1 minute of plugging in the USB drive.

Everything is intended to run from the "/home/pi/" folder and was developed on raspian.

	cd ~
	git clone https://github.com/mox386/VidUploadServer.git

To setup

        cd ~/VidUploadServer
        ./install

Please don't use spaces in this folder/channel name. If your channel has a space in the name either replace the space with an underscore or remove the space. This folder name will be used to identify which 
channel to upload various video files to which channels. So be careful to use the same name when the scripts ask you for input. 
The name you use in the scripts must match the name of the folder.

#For youtube 

Before running install. On the computer you normally upload via browser for your youtube channel. 
	
	1.) login and go to https://cloud.google.com/console/project.
	2.) Create a Project, name it anything.
	3.) On the left click APIs & auth, then APIs.
	4.) On the right click 'YouTube Data API'.
	5.) Click Enable API.
	6.) On the left, under APIs, click 'Consent screen' and fill it out with any information you would like, you're the only one going to see it Save/Accept.
	7.) On the left, click 'Credentials'.
	8.) On the right, click 'Creat new Client ID'. The application type is 'Installed Application', select 'Other'.
	9.) Download the json file and put it into a folder on the thumb drive named for the channel.

After this file is in the channel folder on the thumb drive. Plug it into the Raspberry Pi and run the NewChannel command. If you happen to have any doubts about the json file that you downloaded (because 
developers move stuff around all the time) the file should contain a 'client_secret' that is 25 characters long and a 'client_id' that is 73 charaters long. 'client_id' should end with 
apps.googleusercontent.conf'.

	cd ~/VidUploadServer
	./NewChannel

A link to a google consent webpage from step 6 above will be generated. However, since we are running a headless raspberry pi it will not display on the pi, copy paste, type, or otherwise move this 
authorization link to another computer where you can accept. Just in case you need the link, it will be placed in a file in the channel folder.

The link will generate a verification code that needs to be pasted (or otherwise inserted) into the raspberry pi to confirm the authorization. If you get interrupted in the process of verification, 
but did obtain the verification code its okay. Run the GoogAuth script inside the channel folder. Then put the verification code in (<channel_name> should be replaced by your folder/channel name on 
the thumb drive).

	cd ~/VidUploadServer/youtube/<channel_name>
	./GoogAuth

If you are running from a standalone raspberry pi hooked up to a monitor, then you many not be able to copy/paste the verification code into the cli. 
There is a slight trick to piping in the verification code into the command. Put the verification code into a file named 'verification' with nothing else in the file but the verification code. Put this file in the channel folder on the thumb drive and run this: (where <channel_name> is replaced by your folder/channel name)

	cd ~/VidUploadServer/youtube/<channel_name>
	cat /media/*/<channel_name>/verification* | ./GoogAuth

Once verification is complete it will upload a simple video, if you would rather not wait for this video to complete it is okay to ctrl+c out and move on.

#For vimeo

In Work

        1.) login and go to https://developer.vimeo.com/apps/new
        2.) Fill out the required fields with anything you like, and click create 
        3.) Click 'Request Upload Access' and fill out the form, there is an annoying 'please explain' field 
	NOTE: It may take 5 business days to get approval/rejection

#For dailyMotion

	1.) login and go to https://www.dailymotion.com/profile/developer
	2.) Click 'Create a new API Key' and fill out the fields, in Callback URL paste this in "https://api.dailymotion.com/oauth/token"
	3.) Wait a few seconds and refresh (F5)

In order to access daily motion a config.py file needs to be put together. If you are typing in commands into the ssh terminal on a computer that has browser-login-access to your dailymotion account, 
then you can copy/paste in the responses that will build the 'config.py'. The other option is to make the 'config.py' and place it in the channel folder on the thumb drive prior to setting up the
channel.

For information on the 'config.py' file see the bottom of the dailymotion SDK README https://github.com/dailymotion/dailymotion-sdk-python

In order to setup the channel run the NewChannel command.

        cd ~/VidUploadServer
        ./NewChannel

#Disabling a channel

To disable a channel comment it out in the "channels" file.

	nano ~/VidUploadServer/channels

#Removing a channel

To remove a channel run the "RemoveChannel" script it will wash all traces of a channel out of the VidUploadServer folder.

	~/VidUploadServer/RemoveChannel

#Clear Video Upload History

	rm ~/VidUploadServer/uploaded_videos.log

#Notes:

-Vimeo currently in work

-DailyMotion currently in work

-Youtube working as of 4/9/2015

-Do Not name a channel the same name on two different hosting services even if they are the same name on those hosting services. Give them a slightly different name in VidUploadServer.

-The script will not upload the same file twice, so if an upload gets interrupted or doesn't work you must rename the video file for it to work, or clear the upload from the history.

-If a video filename is shorter than 10 characters it may not upload.
