'''Simple Hello World App
'''

from kivy.app import App
from kivy.logger import Logger


class HelloWorldApp(App):
	'''
	'''
	def __init__(self, *args, **kwargs):
		Logger.info(f'{self.__class__.__name__}: app __init___')
		super(HelloWorldApp, self).__init__(*args, **kwargs)

	def on_build(self):
		# Let's build our app's structure here.
		# by default if there is a file named as our App's ClassName.
		# `HelloWorld(App)` or `HelloWorldApp(App)` - Looks for -> `helloworld.kv`.
		# within the same dir as the class `HelloWorld`; then the structure is loaded from that file.
		# Alternatively you can provide structure here yourself if that file does not exist.
		# in this case we just pass as we want structure to be taken from that file
		Logger.info(f'{self.__class__.__name__}: on_build called')
		pass

	def on_kv_post(self):
		'''This is called once app is done loading the kv code from build(or the app_name.kv file.)
		'''
		Logger.info(f'{self.__class__.__name__}: kv file processed.')

	def on_start(self):
		
		Logger.info(f'{self.__class__.__name__}: on_start called')

	def on_pause(self):
		# Return true here if we want our app to not close when app is paused.
		# by default it 

		Logger.info(f'{self.__class__.__name__}: on_pause called')
		return True

	def on_resume(self):
		Logger.info(f'{self.__class__.__name__}: on_resume called')

	def on_stop(self):
		Logger.info(f'{self.__class__.__name__}: on_stop called')