#!/run/current-system/sw/bin/sh

record() {
  notify-send "Started screen recording"

  timestamp=$(date '+%a__%b%d__%H_%M_%S')
  video_file="$HOME/captures/recordings/video_${timestamp}.mp4"
  audio_file="$HOME/captures/audio/audio_${timestamp}.wav"

  wf-recorder \
    -r 60 \
    -c libx264 \
    -p preset=medium \
    -p crf=18 \
    -f "$video_file" &

  echo $! > /tmp/recpid

  # Optional audio recording
  # ffmpeg \
  #   -f alsa -i default \
  #   -af "afftdn=nf=-75" \
  #   "$audio_file" &
  # echo $! > /tmp/audpid
}

end() {
  if [[ -f /tmp/recpid ]]; then
    kill -15 "$(cat /tmp/recpid)" && rm -f /tmp/recpid
  fi

  notify-send "Stopped screen recording"
}

if [[ -f /tmp/recpid ]] && pgrep -F /tmp/recpid -x wf-recorder > /dev/null 2>&1; then
  end
else
  record
fi
