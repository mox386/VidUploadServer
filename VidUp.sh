#CHANNEL UPLOAD SCRIPT:
sed '/^$/d' channels >> temp
while read i; do
	case "$i" in \#*) continue ;; esac
        cd ~/VidUploadServer/*/$i
        for _file in /media/*/$i/*.mov /media/*/$i/*.mp4 /media/*/$i/*.flv /media/*/$i/*.avi; do
                path=$(echo $_file | wc -m)
                if [ $path -gt 35 ]; then
                        did=$(grep "$_file" ~/VidUploadServer/uploaded_videos.log | wc -l)
                        if [ $did = 0 ]; then
                                #Edit this to your liking
                                python upload_video.py --file="$_file" --title="Temp" --description="Temp" --keywords="Temp" --category="22" --privacyStatus="private" --noauth_local_webserver
                                echo $_file >> ~/VidUploadServer/uploaded_videos.log
                                echo uploaded $_file
                                sleep 5
                        fi
                fi
        done
        sleep 75
done < temp
rm temp
