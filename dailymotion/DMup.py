import dailymotion
import config
import time
import glob
import os
import argparse

api_base_url                   = config.BASE_URL or 'http://api.dailymotion.com'
api_key                        = config.CLIENT_ID
api_secret                     = config.CLIENT_SECRET
username                       = config.USERNAME
password                       = config.PASSWORD
redirect_uri                   = config.REDIRECT_URI
oauth_authorize_endpoint_url   = config.OAUTH_AUTHORIZE_URL or 'https://api.dailymotion.com/oauth/authorize'
oauth_token_endpoint_url       = config.OAUTH_TOKEN_URL or 'https://api.dailymotion.com/oauth/token'

parser = argparse.ArgumentParser()
parser.add_argument('--chan', required=True, help='VidUPloadServer channel-folder name', type=str)

def upload(arg):
	d = dailymotion.Dailymotion(api_base_url=api_base_url,
      		                oauth_authorize_endpoint_url=oauth_authorize_endpoint_url,
               		        oauth_token_endpoint_url=oauth_token_endpoint_url,
                       		session_store_enabled=True)
	d.set_grant_type('password', api_key=api_key, api_secret=api_secret, scope=['manage_videos'], info={'username': username, 'password': password})
	channel = str(arg)[16:-2]
	path = glob.glob("/media/usb/" + channel + "/*avi") + glob.glob("/media/usb/" + channel + "/*mp4") + glob.glob("/media/usb/" + channel + "/*flv") + glob.glob("/media/usb/" + channel + "/*mov")
	for i in path:
		if nope(i) is None:
			url = d.upload(i)
			d.post('/videos', {'url' : url, 'title' : 'temp_%s' % time.strftime("%c"), 'published' : 'false', 'channel' : 'news'}	)
			logging = 'echo "' + i + '" >> ~/VidUploadServer/uploaded_videos.log'
			print logging
			os.system(logging)
			path = glob.glob("/media/usb/" + channel + "/*avi") + glob.glob("/media/usb/" + channel + "/*mp4") + glob.glob("/media/usb/" + channel + "/*flv") + glob.glob("/media/usb/" + channel + "/*mov")
			print path
			print i
			
def nope(filepath):
	log = open('/home/pi/VidUploadServer/uploaded_videos.log','r')
	for line in log:
		if filepath == line[:-1]:
			return True

if __name__ == '__main__':
	arg = parser.parse_args()
	upload(arg)
