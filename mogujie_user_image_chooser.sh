#!/bin/bash
# -------------------------------------------------------
# Mogujie image picker
#
# @Brief: This bash script is used to choose the user
# images from the mogujie dataset. The directory trees
# is preserved during the process
#
# Written by Tingwu Wang, 15/08/2015
# -------------------------------------------------------

if [ $# -ne 2 ]
then
    echo 'Error! You must specify the input and output file names'
fi

# the big dir is stored in the variables $(big_class[index])
num_big_class=0
output_dir=$2

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
for var in "${big_class[@]}"  # the biggest dir, eg: clothes
do
    base_biggest=`basename $var`
    for sub_dir in `ls $var`  # the sub dir, eg: POLO
    do
        if [ ! -d $var/$sub_dir ]; then
            continue
        fi
        user_path=$var/$sub_dir
        for user_image_dir in `ls $user_path`  # the smallest dir, eg: 76asdq
        do
            # make the corresponding directory
            mkdir -p $2/$base_biggest/$sub_dir/$user_image_dir/
            type_name=`basename $sub_dir`

            # copy the image into the new directory
            cp $user_path/${user_image_dir}/user/*.jpg \
                $2/$base_biggest/$sub_dir/$user_image_dir/
            cp $user_path/${user_image_dir}/user/*.png \
                $2/$base_biggest/$sub_dir/$user_image_dir/ 2>/dev/null
            cp $user_path/${user_image_dir}/user/*.JPEG\
                $2/$base_biggest/$sub_dir/$user_image_dir/ 2>/dev/null
            cp $user_path/${user_image_dir}/*.jsn\
                $2/$base_biggest/$sub_dir/$user_image_dir/
            cp $user_path/${user_image_dir}/*.html\
                $2/$base_biggest/$sub_dir/$user_image_dir/
        done
    done
done
