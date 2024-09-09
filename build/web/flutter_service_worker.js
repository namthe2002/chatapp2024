'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "4ccd5c4eae22932850df5e195f5b231e",
"version.json": "dde495debe3cc0a1b15e49383182a457",
"index.html": "b9f5716ddb0fcc68f907651179bdf72f",
"/": "b9f5716ddb0fcc68f907651179bdf72f",
"main.dart.js": "19ebe69686f098328297090f7b75ec94",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "9020048893b264d13794ca9df923e1d8",
"assets/asset/images/light_mode.svg": "833d222dbd2c54bb06c58d3b6f5a517a",
"assets/asset/images/empty_chat_detail.svg": "608c22046b116e33e504508cc976322d",
"assets/asset/images/ic_home_chat.png": "d67ddb6b442584ed03cac17a6b2af66e",
"assets/asset/images/img_theme_login.png": "244605561834d439a43338b119944179",
"assets/asset/images/gg_service_account.json": "853f29281a49341b3058a22f9742105f",
"assets/asset/images/ic_notification.png": "018f917ffabe984225fae3dcd602268e",
"assets/asset/images/bg_light.png": "757d53720bb1bde3804fb12324561822",
"assets/asset/images/ic_language.png": "8b26b8c99eb7311518938bd87db55733",
"assets/asset/images/img_defaut_avatar.png": "dd88c3ccbd9f296fb0ac92af35b20821",
"assets/asset/images/ic_ud_profile.png": "8a34f739a635c13a53d7f56686b2301e",
"assets/asset/images/dark_mode.svg": "adca0c4f70e50e951590c9a3c646e6cf",
"assets/asset/images/empty_chat_darkmode.png": "52db3c5b6327ed4930f2ca4c0f61665c",
"assets/asset/images/ic_log_out.png": "be2de24acdfe7d737a57b297f1a74e7f",
"assets/asset/images/bg_dark.png": "a782bbaef4bc65efc97e76c695b86b50",
"assets/asset/images/default.svg": "ebd1e8761e23b9b157b80705670a00bf",
"assets/asset/images/empty_chat_lightmode.png": "9daad1ac8b1daca7cb98d65cffdfa9c8",
"assets/asset/images/ic_contact.png": "581c98352fdd248c25f5aeb0fac4af0f",
"assets/asset/images/img_embedded_qr.png": "5ed8f04085944d45d1894317e2e00d43",
"assets/asset/images/ic_friend_request.png": "7f38fbb6f54da873473255d1940509f5",
"assets/asset/images/ic_night_mode.png": "46991da2f5791e49941529ba655ec7ac",
"assets/asset/images/auto_mode.svg": "fc18c0cb33ecc000c570c5763320767d",
"assets/asset/images/ic_active_session.png": "5a9c1977e2d871095f53d601d2ebec2a",
"assets/asset/images/logo.svg": "ee9a3610861203e9f91c321613e90f93",
"assets/asset/images/ic_account_avatar.png": "ba53e492e346383fbe007c2c1145ed36",
"assets/asset/images/ic_chat_setting.png": "72faef7f6d7819738bc46a04536c10bd",
"assets/asset/json/importing.json": "bfdd8b7df7e7b9ed5912b3b0035a5506",
"assets/asset/icons/like.svg": "7d0ceaa2e5ab4c7fcab60feb66c518f9",
"assets/asset/icons/draw_7.svg": "9639e7f53d79cd5050bcdf5768b731ca",
"assets/asset/icons/smiling_face_with_sunglasses.svg": "51a6530ee635b7baec772356015f343a",
"assets/asset/icons/draw_6.svg": "c64078f795cf09fbf617bbbbd1fc2671",
"assets/asset/icons/txt.svg": "a50b07ab5406e7707fa18f4c06ca38ac",
"assets/asset/icons/flag_vietnam.svg": "e9cb27bac552ba71633e702e29c0c81e",
"assets/asset/icons/flag_china.svg": "8867eebdbdd3799b4e98ab33df4c42fb",
"assets/asset/icons/reply.svg": "555b7d82a21d6f171d89caa8930c387a",
"assets/asset/icons/draw_4.svg": "4fd5d895f6924c40760249626de2e651",
"assets/asset/icons/no_peding.svg": "e24f91b96ed0355de2098d3e743a36c8",
"assets/asset/icons/docx.svg": "faab72943bd0950a04858f0414a463a2",
"assets/asset/icons/flag_english.svg": "a1884ec2dabef417617183656db167b9",
"assets/asset/icons/draw_5.svg": "7a993457f86e8cccf69dcbb5420f80ef",
"assets/asset/icons/draw_1.svg": "378602d31531d5405606a9aeee561f0c",
"assets/asset/icons/ic_new_message.svg": "17163c9700615641066cb00981c82114",
"assets/asset/icons/hidden.svg": "734b82bb7569b90261475b16d52661af",
"assets/asset/icons/pdfx.svg": "fcd8f19ffa1aa9f0ecfb1f4db203d1bd",
"assets/asset/icons/draw_2.svg": "e111b9e4506b49e998237a3c8ed3fe9a",
"assets/asset/icons/file.svg": "01a2ec23a145f280e347a6f8519461c5",
"assets/asset/icons/select_image.svg": "f3c60220963625da61caf33dd5f9485b",
"assets/asset/icons/draw_3.svg": "e3bb0cfae9a77afe6ac05372e4b35eeb",
"assets/asset/icons/fire.svg": "3a157ee1f9c21990a9c4a2ed825f0866",
"assets/asset/icons/un_pin.svg": "99946cc9e2ad0121de7c7bbe46204128",
"assets/asset/icons/pin_note.svg": "54b33481f25b353f6de2733639de568a",
"assets/asset/icons/no_accout.svg": "7df66c062cfc29eec1b0247b63ff9c75",
"assets/asset/icons/group_add.svg": "99529e4282f91717055f167a66e6b94a",
"assets/asset/icons/pin.svg": "bc46f006f6a155340df1ede5c06941a9",
"assets/asset/icons/mic.svg": "74844990925a09738951d19b90852e03",
"assets/asset/icons/copy.svg": "6abeb2bde9ef238394bc3cab50f5c9fe",
"assets/asset/icons/image.svg": "8b4b395875f3c0fe5a5f15742f0c2c22",
"assets/asset/icons/xlsm.svg": "8063ec7a21501dde44f206325dc7aabe",
"assets/asset/icons/no_friend.svg": "075945ec93b6259a15147866d7bf3d83",
"assets/asset/icons/forward_chat.svg": "e08dcfe0ab6dd7b575ecfc79fb02454c",
"assets/asset/icons/camera.svg": "27ee6316315c0a4673c4f4022ae3c235",
"assets/asset/icons/edit.svg": "0062fdc278dc758fe7360f1bb913863a",
"assets/asset/icons/eye_login.svg": "e895a051743e4ee7f825065d30c11a64",
"assets/asset/icons/video_pick.svg": "a385929763918535ba48bf69a261ba4e",
"assets/asset/icons/no_results.svg": "8d17855563894b0864006ebdee975754",
"assets/asset/icons/delete.svg": "0e61b4491a71274558549650f72fe997",
"assets/asset/icons/loudly_crying_face.svg": "326df10372d62efbf7fa271fb0f1c519",
"assets/asset/icons/multiple_select.svg": "dcd39f92353f00d5860b569b79f0395d",
"assets/asset/icons/ic_new_group.svg": "2acdea1dd45517f77539f5212c79a152",
"assets/asset/icons/file_picker.svg": "2ab9f048c214280147b84394f7b0e1f8",
"assets/asset/icons/face_with_tears_of_joy.svg": "5bcaa5b641c8aaab84ee9a36d2ede58e",
"assets/asset/icons/add_chat.svg": "83a1997e4b7d58d89dfc0abfec43962f",
"assets/asset/icons/draw_8.svg": "8ffa2faad7ad88f9a88f676d0e3373c1",
"assets/asset/icons/forward.svg": "a9f3d7585b643209acd2ab9eea08fee7",
"assets/asset/icons/smiling_face_with_heart_eyes.svg": "10210b4e9ee524b6b41e916176627a04",
"assets/asset/icons/heart.svg": "5985bd1868f287348d90b5c0b0392177",
"assets/AssetManifest.json": "f0db2448e91612149cf97d537c2db416",
"assets/NOTICES": "6b362585dd85a674ec45f166f5cbdbb6",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "1dda65f6fc1104d3feba6dfda2ad9f80",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "871871f565e64c9712058b035caeb434",
"assets/fonts/MaterialIcons-Regular.otf": "f74c8c1c3474d585dea4066b7cc08a27",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
