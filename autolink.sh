#!/bin/bash

numOfLines=5

while [[ $platform != "desktop" ]] && [[ $platform != "laptop" ]]; do
	printf "Select platform: (desktop/laptop) "
	read platform
done

for file in $(find $PWD -type f ! -name "*.swp" ! -name "*#" ! -path "*.git*"); do
	if [[ $(head -$numOfLines $file) = *" linkto"* ]]; then

		linkString=$(head -$numOfLines $file | grep -E "linkto\[$platform\]:")

		if [[ $linkString = "" ]]; then
			linkString=$(head -$numOfLines $file | grep -E "linkto:")
		fi

		if [[ ! $linkString ]]; then
			echo "$file->???"
			printf "\tSkipping file, no link for selected platform!\n"

		else


		    eval target=$(echo $linkString \
			                    | sed -E "s/.{1,}\slinkto\[{0,1}.{0,}\]{0,1}:\s//")

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
				        mv $target $target".tmpbackup"
				        if [[ -f $target ]]; then
					          echo "\t\tCouldnt move/remove TARGET file...Exiting"
					          exit 1
				        fi

                mkdir --parents $(dirname $target)
				        ln -s $file $target
				        if [[ $(readlink $target) = $file ]]; then
					          rm $target".tmpbackup"
				        else
					          echo "\t\tCouldnt link files"
					          echo "\t\tRestoring old file and exiting"

					          mv $target".tmpbackup" $target

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
				        ln -s $file $target

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
