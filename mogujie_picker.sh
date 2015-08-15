#!/bin/bash
# -------------------------------------------------------
# Mogujie image picker
#
# @Brief: this script is used to pick up to 1000 image 
#   per image class from the user part.
#   The image will be save in a new output file with the 
#   image named as CLASS_0001.jpg
#
# Written by Tingwu Wang, 12/08/2015
# -------------------------------------------------------

if [ $# -ne 2 ]
then
    echo 'Error! You must specify the input and output file names'
fi

# the big dir is stored in the variables $(big_class[index])
num_big_class=0
max_number_image_per_dir=5
total_image_one_class=50

echo "Processing the image in the directory $1"
for dir in `ls $1`
do
    if [ -d "$1/$dir" ]
    then
        big_class[$num_big_class]=$1/$dir
        echo "Detecting a dir called ${big_class[$num_big_class]}"
        num_big_class=`expr $num_big_class + 1`
    fi
done
# iterating in each big class dir
for var in "${big_class[@]}"  # the biggest dir
do
    for sub_dir in `ls $var`  # the sub dir
    do
        if [ ! -d $var/$sub_dir ]; then
            continue
        fi
        image_counter=0
        user_path=$var/$sub_dir
        for user_image_dir in `ls $user_path`  # the smallest dir
        do
            smallest_dir_counter=0  # in each sub dir, we take up to 5 images
            for image_file in `ls $user_path/${user_image_dir}/user/*.jpg`  # the image file
            do  
                type_name=`basename $sub_dir`
                cp $image_file $2/${type_name}_${image_counter}.jpg
                image_counter=`expr $image_counter + 1`
                smallest_dir_counter=`expr $smallest_dir_counter + 1`
                if [ $smallest_dir_counter -ge $max_number_image_per_dir ]; then
                    break
                fi
                if [ $image_counter -ge $total_image_one_class ]; then
                    break 2
                fi
            done
        done
    done
done
