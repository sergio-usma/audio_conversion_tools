import os
import mutagen
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, APIC

def embed_thumbnails(folder_path):
    for file in os.listdir(folder_path):
        if file.lower().endswith(".mp3"):
            mp3_path = os.path.join(folder_path, file)
            base_name = os.path.splitext(file)[0]
            
            # Search for the corresponding image
            for ext in [".jpg", ".jpeg"]:
                img_path = os.path.join(folder_path, base_name + ext)
                if os.path.exists(img_path):
                    try:
                        # Load MP3 file
                        audio = MP3(mp3_path, ID3=ID3)
                        
                        # Ensure ID3 tag exists
                        if audio.tags is None:
                            audio.add_tags()
                        
                        # Remove existing APIC tags to avoid duplicates
                        audio.tags.delall("APIC")
                        
                        # Read the image file
                        with open(img_path, "rb") as img_file:
                            img_data = img_file.read()
                            
                        # Embed the image
                        audio.tags.add(APIC(
                            encoding=3,  # UTF-8
                            mime=f"image/{ext[1:]}",  # image/jpeg
                            type=3,  # Front cover
                            desc="Cover",
                            data=img_data
                        ))
                        
                        # Save changes
                        audio.save()
                        print(f"Embedded thumbnail in: {mp3_path}")
                    except Exception as e:
                        print(f"Error embedding thumbnail in {mp3_path}: {e}")
                    break  # Stop searching for images once found

if __name__ == "__main__":
    folder = input("Enter the folder path: ").strip()
    if os.path.isdir(folder):
        embed_thumbnails(folder)
    else:
        print("Invalid folder path.")
