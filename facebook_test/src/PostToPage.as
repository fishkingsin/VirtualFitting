﻿package 
	import com.facebook.graph.FacebookMobile;
			
				
				FacebookMobile.login(handleLogin, stage, ['manage_pages','user_photos', 'publish_stream' , 'user_likes' , 'read_stream'], new StageWebView());
			
				log_tf.appendText("\n"+response.toString());