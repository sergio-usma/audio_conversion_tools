# 🎵 Audio Converter: M4A & OPUS to MP3 🎶

This script converts all `.m4a` and `.opus` files inside a specified folder (including subfolders) to `.mp3` format at 128 kbps using FFmpeg. It also includes progress bars for individual and overall file conversions and logs detailed information about the process.

## ✨ Features
- 🔍 Recursively scans for `.m4a` and `.opus` files in a given directory.
- 🔄 Converts files to `.mp3` at 128 kbps using FFmpeg.
- 📊 Displays two progress bars:
  - 📌 One for each file conversion.
  - 📌 One for overall progress with estimated time remaining.
- 📝 Generates a detailed log file (`conversion_log.txt`).
- ✅ Verifies the integrity of each converted file.

## ⚙️ Requirements
- **FFmpeg** installed at `C:\ffmpeg\ffmpeg.exe`.
- **Python 3.x** installed.
- Required Python packages:
  - `tqdm` (for progress bars)

Install `tqdm` using:
```sh
pip install tqdm
```

## 🚀 Usage
1. Open a terminal or command prompt.
2. Run the script:
```sh
python script.py
```
3. Enter the path to the directory containing `.m4a` and `.opus` files when prompted.

## 📝 Log File
- The script generates a `conversion_log.txt` file that records conversion success, failures, and verification results.

## 🛠️ Troubleshooting
- Ensure `FFmpeg` is correctly installed at `C:\ffmpeg\ffmpeg.exe`.
- Check the log file for errors.
- Verify that the input directory contains `.m4a` or `.opus` files.

# 📌 Embed Thumbnails in MP3 Metadata

This script automatically embeds corresponding JPG/JPEG images as thumbnails in MP3 files' metadata. It scans a given folder, matches MP3 files with their respective images, and updates the metadata accordingly. 🎵🖼️

## ✨ Features
- 🔍 Scans the specified folder for MP3 files.
- 🔗 Finds and matches images (`.jpg` or `.jpeg`) with the same filename as the MP3.
- 🛠️ Embeds the image as the MP3 file's thumbnail metadata.
- ✅ Ensures that only one thumbnail is embedded per file (removes existing album art to avoid duplicates).
- 🚀 Saves the updated MP3 file with the new album cover.

## 🛠️ Requirements
Make sure you have Python installed and the following library:

```bash
pip install mutagen
```

## 📌 How to Use
1. Run the script and provide the folder path containing the MP3 and image files:

```bash
python embed_thumbnails.py
```

2. Enter the folder path when prompted.
3. The script will process all MP3 files and embed the corresponding image as a thumbnail.

## ⚠️ Notes
- The image file must have the exact same name as the MP3 file (excluding the extension).
- Supported image formats: `.jpg`, `.jpeg`.
- The script automatically removes existing album art before adding the new one.

## 📜 License
This project is licensed under the **MIT License**. See the `LICENSE` file in the root folder for details.

Enjoy seamless audio conversion! 🎧🔥
