#!/run/current-system/sw/bin/zsh

record() {
  # Set output filenames
  timestamp=$(date '+%a__%b%d__%H_%M_%S')
  video_file="$HOME/recordings/video_${timestamp}.mp4"
  audio_file="$HOME/audio/audio_${timestamp}.wav"

  # Screen recording with wf-recorder (Wayland)
  wf-recorder \
    -r 60 \
    -c libx264 \
    -p preset=medium \
    -p crf=18 \
    -f "$video_file" &

  echo $! > /tmp/recpid

  # Audio recording with ffmpeg and noise filtering
  #ffmpeg \
  #  -f alsa -i default \
  #  -af "afftdn=nf=-75" \
  #  "$audio_file" &

  echo $! > /tmp/audpid
}

end() {
  # Stop processes
  kill -15 "$(cat /tmp/recpid)" 
  rm -f /tmp/recpid
}

# Toggle recording state
([[ -f /tmp/recpid ]] && end && exit 0) || record
