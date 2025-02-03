import os
import subprocess
import logging
import sys
import time
from pathlib import Path
from tqdm import tqdm

# Set FFmpeg path
FFMPEG_PATH = "C:\\ffmpeg\\ffmpeg.exe"

# Configure logging
LOG_FILE = "conversion_log.txt"
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def get_audio_files(directory):
    """Recursively get all .m4a and .opus files in the given directory."""
    return list(Path(directory).rglob("*.m4a")) + list(Path(directory).rglob("*.opus"))


def convert_audio_to_mp3(input_file):
    """Convert an audio file (M4A or OPUS) to MP3 using FFmpeg."""
    output_file = input_file.with_suffix(".mp3")
    command = [
        FFMPEG_PATH,
        "-i", str(input_file),
        "-b:a", "128k",
        "-y",  # Overwrite without asking
        str(output_file)
    ]

    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    _, stderr = process.communicate()

    if process.returncode == 0:
        logging.info(f"Successfully converted: {input_file} -> {output_file}")
        return output_file
    else:
        logging.error(f"Failed to convert {input_file}: {stderr.decode()}")
        return None


def verify_conversion(mp3_file):
    """Check if the MP3 file is valid."""
    command = [FFMPEG_PATH, "-v", "error", "-i", str(mp3_file), "-f", "null", "-"]
    process = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if process.returncode == 0:
        logging.info(f"Verification passed: {mp3_file}")
        return True
    else:
        logging.error(f"Verification failed: {mp3_file}, Error: {process.stderr.decode()}")
        return False


def main():
    """Main function to handle batch conversion."""
    directory = input("Enter the path to the directory: ").strip()
    files = get_audio_files(directory)

    if not files:
        print("No M4A or OPUS files found.")
        return

    total_files = len(files)
    print(f"Found {total_files} audio files.")

    start_time = time.time()
    overall_progress = tqdm(total=total_files, desc="Overall Progress", unit="file")

    for file in files:
        file_start = time.time()
        file_progress = tqdm(total=100, desc=f"Processing {file.name}", unit="%")

        mp3_file = convert_audio_to_mp3(file)
        file_progress.update(50)

        if mp3_file and verify_conversion(mp3_file):
            file_progress.update(50)
        else:
            logging.error(f"Skipping file due to errors: {file}")

        file_progress.close()
        overall_progress.update(1)

    overall_progress.close()
    elapsed_time = time.time() - start_time
    print(f"Conversion completed in {elapsed_time:.2f} seconds.")


if __name__ == "__main__":
    main()
