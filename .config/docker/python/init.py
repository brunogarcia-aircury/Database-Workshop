import os
import sys
import stat
import gdown
import zipfile
import psycopg2
from dotenv import load_dotenv
import time


class colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

os.umask(0)

base_download_folder=".config/temp/"

DOWNLOAD_LIST= [
    ("Airport", "airport",
        [
            ("1C7PVxeYvLDr6n_7qjdA2k0vahv__jMEo", "zip/postgres_air_2024.sql.zip")
        ]
    )
]


print(colors.HEADER + "\nInitializing the database" + colors.ENDC)
print("-------------------------\n" + colors.ENDC)

print(colors.WARNING + "Downloading..." + colors.ENDC)
for Bundle,subfolder,files in DOWNLOAD_LIST:
    print("Bundle: ", colors.OKCYAN + Bundle + colors.ENDC)
    download_folder=base_download_folder+subfolder+"/"

    i=1
    for file_id, file_name in files:
        download_path=download_folder+file_name
        final_download_folder=os.path.dirname(download_path)

        print(colors.WARNING + "\t" + str(i) + ": " + colors.ENDC + file_name + " -> " + download_path)

        if not os.path.exists(final_download_folder):
            os.makedirs(final_download_folder)
            gdown.download(f"https://drive.google.com/uc?id={file_id}", download_path, quiet=False)
        else:
            print(colors.OKCYAN + "\tSkip" + colors.ENDC)

        i+=1


print(colors.WARNING + "\nUnzip..." + colors.ENDC)
i=1
for root, _, files in os.walk(".config/temp"):
    for file in files:
        if file.endswith(".zip"):
            path=os.path.join(root, file)
            out_path=os.path.splitext(path.replace(".config/temp", ".config/temp/unzip"))[0]
            print(colors.WARNING + "\t" + str(i) + ": " + colors.ENDC + path, " -> ", out_path)


            if not os.path.exists(out_path):
                # Extract the zip file
                with zipfile.ZipFile(path, 'r') as zip_ref:
                    zip_ref.extractall(out_path)
            else:
                print(colors.OKCYAN + "\tSkip" + colors.ENDC)

            i+=1
