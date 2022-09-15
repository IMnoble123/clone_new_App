import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/player/progress_bar_state.dart';
import 'package:uri_to_file/uri_to_file.dart';

class TomTomPlayer {
  final _audioPlayer = AudioPlayer();
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  final List<Podcast> podcasts = [];
  late MainController mainController; //= Get.find<MainController>();

  TomTomPlayer() {
    // _init();
  }

  void _init() async {
    //mainController = Get.find<MainController>();
    //_audioPlayer = AudioPlayer();
    //_setInitialPlaylist();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    _listenForChangesInSequenceState();
  }

  void _setInitialPlaylist() async {
    _playlist = ConcatenatingAudioSource(children: []);

    await _audioPlayer.setAudioSource(_playlist);
  }

  void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      switch (playerState.processingState) {
        case ProcessingState.idle:
          // TODO: Handle this case.
          break;
        case ProcessingState.loading:
          mainController.updateLoading(true);
          break;
        case ProcessingState.buffering:
          mainController.updateLoading(true);
          break;
        case ProcessingState.ready:
          mainController.updateLoading(false);
          break;
        case ProcessingState.completed:
          //_audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
          break;
      }
    });

    _audioPlayer.playingStream.listen((b) {
      mainController.updatePlayingState(b);
    });
  }

  /*void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        mainController.isLoadingPodcast.value = true;
      } else if (!isPlaying) {
        //mainController.isPlaying.value = false;
        mainController.updatePlayingState(false);
      } else if (processingState != ProcessingState.completed) {
        //mainController.isPlaying.value = true;
        mainController.updatePlayingState(true);
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }*/

  void _listenForChangesInPlayerPosition() {
    _audioPlayer.positionStream.listen((position) {

      if(mainController.isSeekbarTouched.value) return;

      final oldState = mainController.progressNotifier.value;
      mainController.updateProgressStates(ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      ));
      /*mainController.progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );*/
    });
  }

  void _listenForChangesInBufferedPosition() {
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = mainController.progressNotifier.value;

      mainController.updateProgressStates(ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      ));
      /*mainController.progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );*/
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = mainController.progressNotifier.value;
      mainController.updateProgressStates(ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      ));
      /*mainController.progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );*/
    });
  }

  StreamSubscription? streamlisten = null;

  void _listenForChangesInSequenceState() {
    if (streamlisten != null) {
      streamlisten?.cancel();
    }

    print('Called');
    streamlisten = _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null || sequenceState.currentSource == null) return;

      final currentItem = sequenceState.currentSource;
      final mediaItem = currentItem?.tag as MediaItem;

      // final podcast = currentItem?.tag as Podcast;
      final podcast = podcasts.where((e) => e.podcastId == mediaItem.id).first;
      print('Outer called');
      if (mainController.currentPodcast == null ||
          mainController.currentPodcast!.podcastId != podcast.podcastId) {
        mainController.updatePodcast(podcast);
        print('inner called');
      }

      // update playlist
      final playlist = sequenceState.effectiveSequence;

      // update shuffle mode
      mainController.isShuffleModeEnabled.value =
          sequenceState.shuffleModeEnabled;

      // update previous and next buttons
      /* if (playlist.isEmpty || currentItem == null) {
        mainController.updateIsFirstPage(true);
        mainController.updateIsLastPage(true);
      } else {
        mainController.updateIsFirstPage(playlist.first == currentItem);
        mainController.updateIsLastPage(playlist.last == currentItem);
      }*/

      mainController.updateIsFirstPage(false);
      mainController.updateIsLastPage(false);
    });
  }

  bool isPlaying() {
    return _audioPlayer.playing;
  }

  void play() async {
    _audioPlayer.play();
  }

  void stop() async {
    _audioPlayer.stop();
  }

  void pause() {
    print('paused');
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() async{
    await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []));
    await _audioPlayer.dispose();
  }

  void onRepeatButtonPressed() {
    _audioPlayer.setLoopMode(LoopMode.all);
  }

  void onPreviousSongButtonPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {

    _audioPlayer.seekToNext();
  }

  void setLoopMode(bool b) async {
    _audioPlayer.setLoopMode(b ? LoopMode.all : LoopMode.off);
  }

  void setShuffleMode(bool b) async {
    // final enable = !_audioPlayer.shuffleModeEnabled;
    if (b) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(b);
  }

  /*void onShuffleButtonPressed() async {
    final enable = !_audioPlayer.shuffleModeEnabled;
    if (enable) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(enable);
    mainController.updateSongShuffle(enable);
  }*/

  Podcast convertToPodcast(DpPodcast dpPodcast) {
    final podcast = Podcast(
      podcastId: dpPodcast.podcastId,
      podcastName: dpPodcast.podcastName,
      rjname: dpPodcast.rjname,
      userId: dpPodcast.userId,
      imagepath: dpPodcast.imagepath,
      audiopath: dpPodcast.audiopath,
      broadcastDate: dpPodcast.broadcastDate,
      authorName: dpPodcast.authorName,
      likeCount: dpPodcast.likeCount,
      localFile: dpPodcast.localPath,
    );

    return podcast;
  }

  void addAllDownloadedPodcasts(
      List<DpPodcast> dpPods, int initialPodcast) async {
    if (timer != null) {
      timer?.cancel();
    }

    mainController = Get.find<MainController>();

    if (streamlisten != null) {
      streamlisten?.cancel();
    }

    _playlist.clear();

    mainController.updateLoading(true);

    await _audioPlayer.stop();
    podcasts.clear();

    final selectedPodcast = convertToPodcast(dpPods[initialPodcast]);
    // final selectedPodcast = pods[initialPodcast];

    podcasts.add(selectedPodcast);

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder = Directory(
        '${_appDocDir.path}/${AppConstants.DOWNLOADS_FILES_DIRECTORY}/');

    //String path = _appDocDirFolder.path+'podcast A.mp4';

    await _playlist.add(AudioSource.uri(
      Uri.file(_appDocDirFolder.path + selectedPodcast.localFile!),
      // Uri.file(path),
      // Uri.file(selectedPodcast.localFile!,windows: false),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: selectedPodcast.podcastId!,
        // Metadata to display in the notification:
        album: 'By ${selectedPodcast.rjname}',
        title: selectedPodcast.podcastName!,
        artUri: Uri.parse(selectedPodcast.imagepath ?? AppConstants.dummyPic),
      ),
    ));

    await _audioPlayer.setAudioSource(_playlist);

    _init();
    play();

    for (int x = 0; x < dpPods.length; x++) {
      int pos = (initialPodcast + x) % dpPods.length;

      print(pos);

      final podcast = convertToPodcast(dpPods[pos]);

      if (!podcasts.contains(podcast)) {
        podcasts.add(podcast);

        await _playlist.add(AudioSource.uri(
          Uri.file(_appDocDirFolder.path + podcast.localFile!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: podcast.podcastId!,
            // Metadata to display in the notification:
            album: 'By ${podcast.rjname}',
            title: podcast.podcastName!,
            artUri: Uri.parse(podcast.imagepath ?? AppConstants.dummyPic),
          ),
        ));
      }
    }
  }

  void addAllDownloadedPodcastsOld(
      List<DpPodcast> pods, int initialPodcast) async {
    mainController = Get.find<MainController>();

    if (streamlisten != null) {
      streamlisten?.cancel();
    }

    _playlist.clear();

    podcasts.clear();

    mainController.updateLoading(true);

    //final selectedPodcast = pods[initialPodcast];

    for (var dpPodcast in pods) {
      final podcast = Podcast(
        podcastId: dpPodcast.podcastId,
        podcastName: dpPodcast.podcastName,
        rjname: dpPodcast.rjname,
        userId: dpPodcast.userId,
        imagepath: dpPodcast.imagepath,
        audiopath: dpPodcast.audiopath,
        broadcastDate: dpPodcast.broadcastDate,
        authorName: dpPodcast.authorName,
        likeCount: dpPodcast.likeCount,
        localFile: dpPodcast.localPath,
      );

      if (!podcasts.contains(podcast) &&
          !podcast.audiopath!.contains(".jfif")) {
        podcasts.add(podcast);
        // File file = await toFile(podcast.localFile!);
        // File file = File(podcast.localFile!);
        //String localPath = file.path;
        // String localPath = "file://"+file.path.replaceAll(" ", "%20");
        print(podcast.localFile!);

        //File file = File(Uri.file(podcast.localFile!).toFilePath());
        var encodedUrl = Uri.encodeFull(podcast.localFile!);
        print(encodedUrl);
        await _playlist.add(AudioSource.uri(
          // File.fromUri(Uri.parse(encodedUrl)).uri,
          Uri.parse(File.fromUri(Uri.parse(encodedUrl)).path),
          //  Uri.file(podcast.localFile!),
          // Uri.file(podcast.localFile!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: podcast.podcastId!,
            // Metadata to display in the notification:
            album: 'By ${podcast.rjname}',
            title: podcast.podcastName!,
            artUri: Uri.parse(podcast.imagepath ?? AppConstants.dummyPic),
          ),
        ));
      }
    }

    print(podcasts.length);

    await _audioPlayer.setAudioSource(_playlist,
        initialIndex: initialPodcast, initialPosition: Duration.zero);

    _init();

    play();
  }


  Timer? timer;


  void addAllPodcasts(List<Podcast> pods, int initialPodcast) async {
    if (timer != null) {
      timer?.cancel();
    }

    mainController = Get.find<MainController>();

    if (streamlisten != null) {
      streamlisten?.cancel();
    }

    _playlist.clear();

    mainController.updateLoading(true);


    await _audioPlayer.stop();
    podcasts.clear();

    final selectedPodcast = pods[initialPodcast];

    podcasts.add(selectedPodcast);
    print(selectedPodcast.audiopath);

    if(selectedPodcast.audiopath!=null && selectedPodcast.audiopath!.isNotEmpty){
      await _playlist.add(AudioSource.uri(
        Uri.parse(selectedPodcast.audiopath!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: selectedPodcast.podcastId!,
          // Metadata to display in the notification:
          album: 'By ${selectedPodcast.rjname}',
          title: selectedPodcast.podcastName!,
          artUri: Uri.parse(selectedPodcast.imagepath ?? AppConstants.dummyPic),
        ),
      ));
    }


    await _audioPlayer.setAudioSource(_playlist);

    _init();
    play();

    for (int x = 0; x < pods.length; x++) {
      int pos = (initialPodcast + x) % pods.length;



      //await Future.delayed(const Duration(seconds: 1));

      if (!podcasts.contains(pods[pos])) {
        podcasts.add(pods[pos]);

        await _playlist.add(AudioSource.uri(
          Uri.parse(pods[pos].audiopath!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: pods[pos].podcastId!,
            // Metadata to display in the notification:
            album: 'By ${pods[pos].rjname}',
            title: pods[pos].podcastName!,
            artUri: Uri.parse(pods[pos].imagepath ?? AppConstants.dummyPic),
          ),
        ));

        print(pos);

      }
    }




  }

  /*void addAllPodcastsOld(List<Podcast> pods, int initialPodcast) async {
    //working
    mainController = Get.find<MainController>();

    if (streamlisten != null) {
      streamlisten?.cancel();
    }

    _playlist = ConcatenatingAudioSource(children: []);
    podcasts.clear();

    mainController.updateLoading(true);

    final selectedPodcast = pods[initialPodcast];

    for (var podcast in pods) {
      if (!podcasts.contains(podcast) &&
          (podcast.audiopath!.contains("http") ||
              podcast.audiopath!.contains("https"))) {
        podcasts.add(podcast);
        await _playlist.add(AudioSource.uri(
          Uri.parse(podcast.audiopath!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: podcast.podcastId!,
            // Metadata to display in the notification:
            album: 'BY ${podcast.rjname}',
            title: podcast.podcastName!,
            artUri: Uri.parse(podcast.imagepath ?? AppConstants.dummyPic),
          ),
        ));
      }
    }

    print(podcasts.length);

    await _audioPlayer.setAudioSource(_playlist,
        initialIndex: podcasts.indexOf(selectedPodcast),
        initialPosition: Duration.zero);

    _init();

    play();
  }*/

  void addPodcast(Podcast podcast) async {
    _playlist = ConcatenatingAudioSource(children: []);

    if (!podcasts.contains(podcast)) {
      podcasts.add(podcast);
      _playlist.add(AudioSource.uri(
        Uri.parse(podcast.audiopath!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: podcast.podcastId!,
          // Metadata to display in the notification:
          album: 'By ${podcast.rjname}',
          title: podcast.podcastName!,
          artUri: Uri.parse(podcast.imagepath ?? AppConstants.dummyPic),
        ),
      ));

      if (_playlist.length == 1) {
        await _audioPlayer.setAudioSource(_playlist);
      }
    }
  }

  void addPodcastOld(Podcast podcast) async {
    _playlist = ConcatenatingAudioSource(children: []);

    if (!podcasts.contains(podcast)) {
      podcasts.add(podcast);
      _playlist.add(AudioSource.uri(
        Uri.parse(podcast.audiopath!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: podcast.podcastId!,
          // Metadata to display in the notification:
          album: 'By ${podcast.rjname}',
          title: podcast.podcastName!,
          artUri: Uri.parse(podcast.imagepath ?? AppConstants.dummyPic),
        ),
      ));

      if (_playlist.length == 1) {
        await _audioPlayer.setAudioSource(_playlist);
      }
    }
  }

  void removeSong() {
    final index = _playlist.length - 1;
    if (index < 0) return;
    _playlist.removeAt(index);
  }

  bool isPlayerPlaying = false;
  void holdPlayer(){


    isPlayerPlaying = _audioPlayer.playing;

    if(isPlayerPlaying){
      _audioPlayer.pause();
    }



  }

  void releaseHold(){

    if(isPlayerPlaying){
      _audioPlayer.play();
    }


  }

}
