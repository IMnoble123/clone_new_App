package com.tomtompodcast.podcast_app

import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen

//class MainActivity: FlutterActivity() {
class MainActivity: AudioServiceActivity() {

override fun provideSplashScreen(): SplashScreen? = SplashView()

}

