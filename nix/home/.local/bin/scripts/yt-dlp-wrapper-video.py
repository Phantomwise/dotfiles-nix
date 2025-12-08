#!/usr/bin/env python3

import subprocess

def main():
    url = input("Enter the video URL: ").strip()
    # output_template = "%(title)s [%(id)s] [%(extractor)s, %(channel_id)s] [%(format_id)s].%(ext)s"
    output_template = "%(title)s [%(id)s] [%(extractor)s, %(uploader,uploader_id,channel,channel_id)s] [%(format_id)s].%(ext)s"
    # output_template = "%(title)s [%(extractor)s, %(uploader,uploader_id,channel,channel_id)s] [%(format_id)s].%(ext)s"
    # output_template = "%(title)s [%(webpage_url_domain)s, %(channel_id)s] [%(format_id)s].%(ext)s"
    # output_template = "%(title)s [%(webpage_url_domain)s, %(uploader,uploader_id,channel,channel_id)s] [%(format_id)s].%(ext)s"
    cmd = [
        "yt-dlp",
        "-o", output_template,
        url
    ]
    subprocess.run(cmd)

if __name__ == "__main__":
    main()