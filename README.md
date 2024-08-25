# forge2d_game

### [Codelab from Google i/o 2024](https://codelabs.developers.google.com/codelabs/flutter-flame-forge2d)
> Also could be watched [here](https://io.google/2024/explore/c47e984b-af2f-4f5f-bcde-e148a5a626bf/)
### PLUS:
* Walls on the sides.
* Tileseheet codegen and macOS config fix scripts are now vs code tasks.
* Bricks take damage and destruct.
* Added cool direction painter for player drag.
* Unit tests for player drag painter path algorithm.

### PLUS second [codelab from the same i/0](https://codelabs.developers.google.com/codelabs/flutter-codelab-soloud)
> This one is about music/sfx addition 
* Made controller to cache loaded sound sources
* Track BGM status and update menu buttons accordingly
* Updated sound filters code to use new plugin API
* Added very verbose logging and error-handling
* Added simple static web-server in Go with [updated headers for wasm](https://docs.flutter.dev/platform-integration/web/wasm#serve-the-output-with-an-http-server).

#### To run on web: (not working atm due to [1](https://github.com/flutter/flutter/issues/153941), [2](https://github.com/flutter/flutter/issues/153222))
```sh
flutter run -d chrome --wasm -t lib/main.dart --release
```

