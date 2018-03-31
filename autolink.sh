#!/bin/bash

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
					          echo "\tFailed to remove symlink...Exiting"
					          exit 1
				        fi
			      fi

		    elif [[ -f $target ]]; then
			      printf "\tFile already present at TARGET path.\n"
			      replaceAndLink=""
			      while [[ $replaceAndLink != "y" ]] \
				              && [[ $replaceAndLink != "n" ]]; do
				        printf "\t\tReplace and link? (y/n)"
				        read replaceAndLink
			      done

			      if [[ $replaceAndLink = "y" ]]; then
				        sudo mv $target $target".tmpbackup"
				        if [[ -f $target ]]; then
					          echo "\t\tCouldnt move/remove TARGET file...Exiting"
					          exit 1
				        fi

                			sudo mkdir --parents $(dirname $target)
				        sudo ln -s $file $target

				        if [[ $(readlink $target) = $file ]]; then
					          sudo rm $target".tmpbackup"
				        else
					          echo "\t\tCouldnt link files"
					          echo "\t\tRestoring old file and exiting"

					          sudo mv $target".tmpbackup" $target

					          exit 1
				        fi

				        echo "\tReplaced and linked file...Success"
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
					          echo "File linked!"
				        else
					          echo "Failed to link file... exiting"
					          exit 1
				        fi
			      fi
		    fi
	  fi

	fi
done

exit 0
