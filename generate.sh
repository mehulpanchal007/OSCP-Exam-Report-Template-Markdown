#!/bin/bash

# This script is just conversion of Ruby script written by https://github.com/noraj for the repository https://github.com/noraj/OSCP-Exam-Report-Template-Markdown

templates=(
    "Use my own Markdown file"
    "src/OSCP-exam-report-template_whoisflynn_v3.2.md"
    "src/OSCP-exam-report-template_OS_v1.md"
    "src/OSWE-exam-report-template_OS_v1.md"
    "src/OSWE-exam-report-template_noraj_v1.md"
    "src/OSCE-exam-report-template_OS_v1.md"
    "src/OSEE-exam-report-template_OS_v1.md"
    "src/OSWP-exam-report-template_OS_v1.md"
)

for i in `seq 0 $(expr ${#templates[@]} - 1)`
do
    echo \[$i\] ${templates[$i]}
done

read -p "Which one of these you wanna choose [1]: " choice

choice=${choice:-1}

if [ $choice -lt ${#templates[@]} ] && [ $choice -ge 0 ]
then
    if [ $choice -eq 0 ]
    then
        read -p "Enter path of MarkDown file [Report.md]: " mdpath
        mdpath=${mdpath:-Report.md}
    else
        mdpath=$(pwd)/src/${templates[$choice]}
    fi
else
    echo Please enter only from above values
    exit
fi

read -p "Enter your OS ID [OS-XXXXX]: OS-" osid
osid=${osid:-OS-XXXXX}

read -p "Enter your Exam name [OSCP]: " exam
exam=${exam:-OSCP}

read -p "Enter the theme you want to use [breezedark]: " style
style=${style:-breezedark}

echo "Creating folder named 'output'"
if ! mkdir -p $(pwd)/output
then
    echo "Failed to create 'output' directory"
fi

pdf=$(pwd)/output/$exam-$osid-Exam-Report.pdf
zipped=$(pwd)/output/$exam-$osid-Exam-Report.7z

echo Generating PDF...

pandoc $mdpath -o $pdf \
 --from markdown+yaml_metadata_block+raw_html \
 --template eisvogel \
 --table-of-contents \
 --toc-depth 6 \
 --number-sections \
 --top-level-division=chapter \
 --highlight-style $style

echo Generating Archive...
7z a $zipped $pdf

read -p "Do you want to add another PDF to the archive [y/N]: "
if [ $REPLY == "y" ]
then
    read -p "Enter path of PDF to add to archive: "
    7z a $zipped $REPLY
fi

echo Done!
