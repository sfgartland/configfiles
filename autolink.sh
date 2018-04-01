#!/bin/bash

# This script searches PWD and sub-dirs for files containing linkto/linkto[platform] strings and
# creates symbolic links.

numOfLines=100

while [[ $platform != "desktop" ]] && [[ $platform != "laptop" ]]; do
	printf "Select platform: (desktop/laptop) "
	read platform
done

for file in $(find $PWD -type f ! -name "*.swp" ! -name "*#" ! -path "*.git*"); do
	if [[ $file != *$(basename $0) ]] && [[ $(head -$numOfLines $file) = *" linkto:"* ]]; then

		linkString=$(head -$numOfLines $file | grep -E "\s{1}linkto\[$platform\]:")

		if [[ $linkString = "" ]]; then
			linkString=$(head -$numOfLines $file | grep -E "\s{1}linkto:")
		fi

		if [[ ! $linkString ]]; then
			echo "$file->???"
			printf "\tSkipping file, no link for selected platform!\n"

		else


		    eval target=$(echo $linkString \
			                    | sed -E "s/.{1,}\s{1}linkto\[{0,1}.{0,}\]{0,1}:\s//")

		    printf "$file->$target\n"
		    if [[ $(readlink $target) = $file ]]; then
			      printf "\tFile is already linked. Remove link? (y/N)"
			      read removeLink
			      if [[ $removeLink = "y" ]]; then
				        rm $target
				        if [[ -f $target ]]; then
					          printf "\tFailed to remove symlink...Exiting\n"
					          exit 1
				        fi
			      fi

		    elif [[ -f $target ]] || [[ -L $target ]]; then
			      printf "\tOther file/link already present at TARGET path.\n"
			      replaceAndLink=""
			      while [[ $replaceAndLink != "y" ]] \
				              && [[ $replaceAndLink != "n" ]]; do
				        printf "\t\tReplace and link? (y/n/b)"
				        read replaceAndLink
			      done

			      if [[ $replaceAndLink = "y" ]]; then
				      	sudo rm $target".tmpbackup"
				        sudo mv $target $target".tmpbackup"
				        if [[ -f $target ]]; then
					          printf "\t\tCouldnt move/remove TARGET file...Exiting\n"
					          exit 1
				        fi

                			sudo mkdir --parents $(dirname $target)
				        sudo ln -s $file $target

				        if [[ $(readlink $target) = $file ]] && [[ $replaceAndLink != "b" ]]; then
					          sudo rm $target".tmpbackup"
				        else
					          printf "\t\tCouldnt link files\n"
					          printf "\t\tRestoring old file and exiting\n"

					          sudo mv $target".tmpbackup" $target

					          exit 1
				        fi

				        printf "\tReplaced and linked file...Success\n"
			      fi

		    else
			      linkFiles=""
			      while [[ $linkFiles != "y" ]] && [[ $linkFiles != "n" ]]; do
				        printf "\tLink? (y/n)"
				        read linkFiles
			      done

			      if [[ $linkFiles = "y" ]]; then
                mkdir --parents $(dirname $target)
				        sudo ln -s $file $target

				        if [[ $(readlink $target) = $file ]]; then
					          printf "File linked!\n"
				        else
					          printf "Failed to link file... exiting\n"
					          exit 1
				        fi
			      fi
		    fi
	  fi

	fi
done

exit 0
