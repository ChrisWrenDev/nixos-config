{pkgs, ...}: {
  home.packages = with pkgs; [
    syncthing
    yt-dlp

    obs-studio
    audio-recorder
    # davinci-resolve

    ffmpeg
    mediainfo
    libmediainfo

    vlc
    mpv
  ];
}
