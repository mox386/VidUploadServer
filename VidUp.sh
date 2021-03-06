#!/bin/bash
#CHANNEL UPLOAD SCRIPT:
#Phillip Moxley
cd ~/VidUploadServer
touch uploaded_videos.log
rm UploadCycle
sed '/^$/d' channels >> UploadCycle
while read i;do
	case "$i" in \#*) continue ;; esac
	cd ~/VidUploadServer/*/$i
	cd ..
	serv="$(basename "$PWD")"
	#echo "$(date)     The channel for the this  upload is $i. $serv is the service for $serv." >> ~/VidUploadServer/VidUp.log
        for _file in /media/usb/$i/*.mov /media/usb/$i/*.mp4 /media/usb/$i/*.flv /media/usb/$i/*.avi; do
		#echo "$(date)     Uploading from $_file. '*'=disregard" >> ~/VidUploadServer/VidUp.log
		cd /media/*
		cd /media/*/$i
		cd ..
		devicename="$(basename "$PWD")"
		pathmin=$(echo $devicename/$i/xxxxxxxxxxxx | wc -m)
		path=$(echo $_file | wc -m)
		if [ $path -gt $pathmin ]; then
			did=$(grep "$_file" ~/VidUploadServer/uploaded_videos.log | wc -l)
			if [ $did = 0 ]; then
				if [ "$serv" == "youtube" ]; then
					#echo "$(date)     The youtube upload has begun for $_file." >> ~/VidUploadServer/VidUp.log
					cd ~/VidUploadServer/youtube/$i/
					#Edit this to your liking
					python upload_video.py --file="$_file" --title="Temp" --description="Temp" --keywords="Temp" --category="22" --privacyStatus="private" --noauth_local_webserver
                        	        echo "$_file" >> ~/VidUploadServer/uploaded_videos.log
					echo "$(date)     $_file uploaded." >>  ~/VidUploadServer/VidUp.log
					sleep 3s
				elif [ "$serv" == "vimeo" ]; then
					echo "$(date)     vimeo is in development." >> ~/VidUploadServer/VidUp.log
				elif [ "$serv" == "dailymotion" ]; then
				        echo "$(date)     The dailymotion upload has begun for $_file." >> ~/VidUploadServer/VidUp.log
					cd ~/VidUploadServer/dailymotion/$i
					python DMup.py --chan="$i"
					echo "$(date)     $i videos uploaded uploaded." >>  ~/VidUploadServer/VidUp.log
					sleep 3s
				else
					echo "Not supposed to happen."
					#echo "$(date)     No video hosting service defined. Do not know how this one slipped by." >> ~/VidUploadServer/VidUp.log
				fi
			else
				echo "No Dice."
				#echo "$(date)     This file was previously uploaded. Either change the name of the video file, or clear the video upload log." >> ~/VidUploadServer/VidUp.log
                       	fi
		else
			echo "nothin to upload"
			#echo "$(date)     The filename is too short. The path '$path' was too short for this to be a video file. Suggest giving the video file a 10 charcter name minimum. However, if an '*' is present this is not the problem." >> ~/VidUploadServer/VidUp.log
		fi
	done
	#echo "$(date)     Video $_file upload complete for channel $i." >> ~/VidUploadServer/VidUp.log
done < UploadCycle
cd ~/VidUploadServer
rm UploadCycle
