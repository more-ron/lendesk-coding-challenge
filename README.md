# Lendesk: Coding Challenge 2018-11-14

EXIF data to CSV extractor.

Acceptance Criteria:
* ✓ must be executable through the command line
* ✓ must scan the current directory if no parameters where given
* ✓ must accept a parameter to specify a directory to scan
* ✓ good to have an option to switch between CSV and HTML as file output format


# Installation

    $ gem install specific_install
    $ gem specific_install git@github.com:more-ron/lendesk-coding-challenge.git

Please make sure you have installed `libexif`:

    $ brew install libexif             # Homebrew
    $ sudo apt-get install libexif-dev # APT
    $ sudo yum install libexif-devel   # CentOS

# Usage

  Recursively scan the current directory for images, extract GPS data and output to `./gps.csv`.

    $ extract-exif gps-location

  Specify the path to recursively scan for images.

    $ extract-exif --path=./images gps-location

  Specify output file path.

    $ extract-exif --output=./result.csv gps-location

  Specify HTML output format.

    $ extract-exif --output=./result.html gps-location

