import vimeo
import config
import time
import glob
import os
import argparse

api_key                        = config.CLIENT_ID
api_secret                     = config.CLIENT_SECRET
bearer_token	               = config.TOKEN
oauth_authorize_endpoint_url   = config.OAUTH_AUTHORIZE_URL or 'https://api.vimeo.com/oauth/authorize'
oauth_token_endpoint_url       = config.OAUTH_TOKEN_URL or 'https://api.vimeo.com/oauth/access_token'

parser = argparse.ArgumentParser()
parser.add_argument('--chan', required=True, help='VidUPloadServer channel-folder name', type=str)

def upload(arg):
	v = vimeo.VimeoClient(
		token=bearer_token,
		key=api_key,
		secret=api_secret)
	channel = str(arg)[16:-2]
	path = glob.glob("/media/usb/" + channel + "/*avi") + glob.glob("/media/usb/" + channel + "/*mp4") + glob.glob("/media/usb/" + channel + "/*flv") + glob.glob("/media/usb/" + channel + "/*mov")
	for i in path:
		if nope(i) is None:
			vido_uri = v.upload(i)					
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
