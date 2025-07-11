# LofiMusic Flutter App – Architecture & Documentation

## Overview
LofiMusic is a modern, glassmorphic, and interactive music player focused on lofi tracks. The Flutter app features a beautiful, animated UI, a responsive player, a sidebar (drawer) for track selection and reordering, and a real-time audio visualizer. It leverages Dart and Flutter, using packages for audio playback, visualization, and glassmorphic UI effects.

---

## Features

- **Lofi Track Streaming:** Fetches lofi tracks from the Deezer API (via CORS proxy), displaying cover art, artist, album, and a 30-second preview.
- **Animated Visualizer:** Audio-reactive visualizer using `flutter_audio_waveforms` with unique waveforms per track.
- **Glassmorphic UI:** Uses `BackdropFilter`, translucency, and animated pastel blobs for a modern, frosted-glass look.
- **Responsive Design:** Works on mobile and desktop, with a collapsible sidebar (Drawer) for track selection.
- **Track Reordering:** Users can reorder tracks in the sidebar using drag-and-drop; order persists in local state.
- **Auto-Play Next Track:** When a track ends, the next track auto-plays (wraps around at the end).
- **Rain Sound Toggle:** Optional rain ambience can be toggled on/off, playing in the background.
- **Album Art/Visualizer Toggle:** Users can switch between album art and the visualizer view.
- **Progress Bar & Seeking:** Interactive progress bar allows seeking within the track.
- **Track Info:** Displays current track's cover, title, artist, and album.
- **Sidebar Drawer:** Track list is shown in a Drawer on all screen sizes.
- **Glassmorphic Overlay:** A translucent overlay sits above the animated blobs, enhancing the glass effect.
- **Pastel Animated Blobs:** Multiple animated blobs move in the background, using a pastel palette (pink, purple, teal, light blue).
- **Theme Toggle:** Light and dark mode support via Riverpod.
- **Comprehensive Testing:** Includes unit, widget, and Patrol UI tests.

---

## Architecture & Folder Structure

```
lib/
  main.dart                # App entry point
  src/
    widgets/
      player.dart          # Main player UI and logic
      sidebar.dart         # Sidebar/Drawer for track list
      visualizer.dart      # Audio visualizer widget
      animated_blobs.dart  # Animated pastel blobs
      glass_overlay.dart   # Glassmorphic overlay
    models/
      track.dart           # Track data model
    services/
      deezer_api.dart      # Deezer API integration
      audio_service.dart   # Audio playback and rain sound
    providers/
      theme_provider.dart  # Theme (light/dark) provider
      track_provider.dart  # Track list, selection, reordering
    theme/
      app_theme.dart       # Theme data, pastel palette
assets/
  sounds/
    rain.mp3              # Local rain ambience audio
integration_test/
  app_test.dart           # Patrol UI tests
  test_bundle.dart        # Patrol test bundle
```

---

## Main Components

### Player Widget
- Manages track list, selected track, play/pause, progress, rain toggle, view (album/visualizer), and reordering.
- Uses `just_audio` for playback.
- Integrates the visualizer widget for audio visualization.
- Controls: Play/pause, next/prev, rain toggle, progress bar, visualizer toggle.
- Animated pastel blobs and glass overlay for background.

### Sidebar/Drawer
- Shows track list with cover, title, artist, album, and drag handles for reordering.
- Clicking a track selects and plays it.
- Uses `ReorderableListView` for drag-and-drop reordering.

### Visualizer
- Uses `flutter_audio_waveforms` for pastel gradient audio visualization.
- Responsive: Sized to fit main content area, only visible in visualizer view.
- Each track has a unique waveform seeded by its ID.

### Animated Blobs
- Multiple animated pastel blobs move in the background.
- Colors and opacity adapt to light/dark mode.
- Uses custom animation controllers for smooth, organic movement.

### Glass Overlay
- Provides a frosted-glass effect using `BackdropFilter` and semi-transparent backgrounds.
- Sits above the animated blobs for enhanced glassmorphism.

### Rain Sound
- Plays `rain.mp3` in a loop at low volume using a separate audio player instance.
- Toggle button in the AppBar controls rain ambience.

### Theme Provider
- Light/dark mode toggle using Riverpod and Flutter’s theme system.

---

## Data Model

### Track
```
class Track {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String cover;
  final String preview;
  final int duration;
  // ...
}
```
- Represents a Deezer track with all relevant metadata.

---

## Services

### Deezer API Service
- Fetches lofi tracks from Deezer using a CORS proxy.
- Parses and returns a list of `Track` objects.

### Audio Service
- Manages audio playback, track selection, progress, and rain sound.
- Uses two `just_audio` players: one for music, one for rain.
- Handles auto-play next, previous, seek, and rain toggle logic.

---

## State Management
- Uses **Riverpod** for all app state: theme, track list, selection, and audio service.
- Providers:
  - `theme_provider.dart`: Manages light/dark mode.
  - `track_provider.dart`: Manages track list, selection, and reordering.
  - `audio_service.dart`: Manages playback, rain, and progress.

---

## UI/UX Design Language
- **Glassmorphism:** Uses `BackdropFilter`, semi-transparent backgrounds, and soft borders.
- **Pastel Colors:** Pink, purple, teal, and light blue dominate the palette.
- **Animated Blobs:** Custom-painted blobs with blur and opacity animate in the background.
- **Modern UI:** Rounded corners, soft shadows, and smooth transitions.
- **Accessibility:** Uses semantic widgets and accessible controls.

---

## Testing
- **Unit & Widget Tests:** Located in `test/` for models, providers, and widgets.
- **Patrol UI Tests:** Located in `integration_test/`, covering launch, theme toggle, rain toggle, sidebar, track selection, and visualizer toggle.

---

## Tech Stack
- **Flutter** (Dart, widgets, state management)
- **just_audio** (audio playback)
- **flutter_audio_waveforms** (audio visualization)
- **flutter_riverpod** (state management)
- **http** (network requests)
- **Patrol** (UI testing)
- **Material Icons** (icon set)

---

## Notable Details
- No genre filtering (tracks do not have genre info from Deezer API).
- Track reordering is local to the session (not persisted).
- Auto-play next track wraps to the first track at the end.
- Visualizer and album art are toggled via UI buttons.
- All network requests are proxied for CORS.
- No authentication or user accounts.
- No server-side code; all client-side.

---

## How to Recreate in Flutter
- Use Flutter with Dart.
- Use just_audio for audio playback.
- Use flutter_audio_waveforms for the audio spectrum.
- Use BackdropFilter and custom widgets for glass effects.
- Use Riverpod for state management.
- Fetch tracks from Deezer API (with CORS proxy).
- Implement animated pastel blobs and glass overlay in the background.
- Implement all features and UI as described above. 