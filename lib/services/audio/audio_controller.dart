import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

const bundledSounds = {
  'pew1': 'assets/audio/sfx/pew1.mp3',
  'pew2': 'assets/audio/sfx/pew2.mp3',
  'pew3': 'assets/audio/sfx/pew3.mp3',
  'bgm': 'assets/audio/music/looped-song.ogg',
};

class AudioController {
  static final Logger _log = Logger('AudioController');

  late final SoLoud _soloud = SoLoud.instance;

  /// sound sources cache
  final Map<String, AudioSource> _cachedSources = {};

  /// active bgm sound handle, if any
  SoundHandle? _bgmHandle;

  /// bgm status flag
  ValueNotifier<bool> bgmPlaying = ValueNotifier(false);
  bool _bgmStopping = false;

  Future<void> initialize() async {
    try {
      _log.info('initialization started');
      await _soloud.init();
      // hack for hot-restart, so we restart with empty caches and sources
      if (kDebugMode) {
        _log.info('clear audio sources');
        _cachedSources.clear();
        _soloud.disposeAllSources();
      }

      // if (!_soloud.isInitialized) {
      //   throw const SoLoudNotInitializedException(
      //     'initialization process failed',
      //   );
      // }
      _log.info('initialization finished');
    } on SoLoudException catch (error, stackTrace) {
      _log.severe('SoLoud init error', error, stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      _log.severe('Unknown error on SoLoud init', error, stackTrace);
      rethrow;
    }
  }

  void dispose() {
    _log.info('dispose');
    _soloud.deinit();
  }

  void _logIgnoreActionOnError(
    String assetKey, {
    String action = 'start playback',
    String? reason,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log.warning(
        'Ignoring action($action) on `$assetKey`'
        '${reason?.isNotEmpty == true ? ': $reason' : ''}.',
        error,
        stackTrace,
      );

  Future<AudioSource?> _getAudioSourceFromAsset(
    String assetKey, [
    bool cacheInMemory = true,
  ]) async {
    if (!bundledSounds.containsKey(assetKey)) {
      _logIgnoreActionOnError(
        assetKey,
        action: 'load asset',
        reason: 'asset not specified to be included',
      );
      return null;
    }

    final assetPath = bundledSounds[assetKey]!;
    AudioSource? source;

    try {
      if (_cachedSources[assetKey] != null) {
        source = _cachedSources[assetKey];
        _log.info('got $assetKey source from cache');
      } else {
        _cachedSources[assetKey] = await _soloud.loadAsset(assetPath);
        source = _cachedSources[assetKey];
        _log.info('load and cached $assetKey source');
      }
    } catch (error, stackTrace) {
      _logIgnoreActionOnError(
        assetKey,
        action: 'load asset',
        error: error,
        stackTrace: stackTrace,
      );
      source = null;
    }

    return source;
  }

  Future<void> playSfx(String assetKey) async {
    final source = await _getAudioSourceFromAsset(assetKey);
    if (source != null) {
      try {
        await _soloud.play(source);
      } catch (error, stackTrace) {
        _logIgnoreActionOnError(
          assetKey,
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> toggleBgm() async {
    if (_bgmStopping) return;

    if (_bgmHandle != null) {
      if (_soloud.getIsValidVoiceHandle(_bgmHandle!)) {
        _log.info(
          'Music is already loaded. '
          '${bgmPlaying.value ? 'Pausing.' : 'Resuming.'}',
        );
        _soloud.pauseSwitch(_bgmHandle!);
        bgmPlaying.value = !_soloud.getPause(_bgmHandle!);

        return;
      } else {
        _bgmHandle = null;
      }
    }

    final source = await _getAudioSourceFromAsset('bgm', false);
    if (source != null) {
      _log.info('got audio source with #${source.handles.length} handles');
      try {
        _bgmHandle = await _soloud.play(
          source,
          volume: 0.5,
          looping: true,
          // the start of the loop is not the beginning of the audio file.
          loopingStartAt: const Duration(seconds: 25, milliseconds: 43),
        );
        _log.info('BGM start playing. ');
        bgmPlaying.value = true;
      } catch (error, stackTrace) {
        _logIgnoreActionOnError(
          'bgm',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> stopBgm() async {
    if (_bgmStopping) return;

    if (_bgmHandle != null) {
      if (_soloud.getIsValidVoiceHandle(_bgmHandle!)) {
        _log.info('Stop playback.');
        await _soloud.stop(_bgmHandle!);
      } else {
        _log.info('remove invalid handle.');
      }
      _bgmHandle = null;
    }

    await _disposeBgmSource();
  }

  Future<void> fadeOutBgm() async {
    if (_bgmStopping) return;

    if (_bgmHandle == null) {
      _log.info('Nothing to fade out');
      return;
    }
    _bgmStopping = true;

    const delay = Duration(seconds: 5);
    _soloud.fadeVolume(_bgmHandle!, 0, delay);
    _soloud.scheduleStop(_bgmHandle!, delay);
    _bgmHandle = null;

    await _disposeBgmSource();
  }

  /// request bgm music handle, wait until all instances finish playing,
  /// dispose resources
  Future<void> _disposeBgmSource() async {
    bgmPlaying.value = false;

    final source = await _getAudioSourceFromAsset('bgm', false);
    if (source != null) {
      // trick to wait for a moment when soundSource can be disposed safely
      await source.allInstancesFinished.first.then(
        (_) async {
          _cachedSources.remove('bgm');
          await _soloud.disposeSource(source);
          _log.info('Music source disposed');
        },
      );
    }
    _bgmStopping = false;
  }

  /// apply global filter
  void applyFilter() {
    final freeverbFilter = _soloud.filters.freeverbFilter;

    freeverbFilter.wet.value = 0.42;
    freeverbFilter.roomSize.value = 0.42;

    /// after API change there is no way to get status from C side
    // if (!_soloud.isFilterActive(FreeverbGlobal)) {
    freeverbFilter.activate();
    // }
  }

  void removeFilter() {
    final freeverbFilter = _soloud.filters.freeverbFilter;

    /// after API change there is no way to get status from C side
    // if (_soloud.isFilterActive(FreeverbGlobal)) {
    freeverbFilter.deactivate();
    // }
  }
}
