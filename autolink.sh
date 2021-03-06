#!/bin/bash

# This script searches PWD and sub-dirs for files containing linkto/linkto[platform] strings and
# creates symbolic links.

numOfLines=100

function getTargetPath {
    file=$1

    linkString=$(head -$numOfLines $file | grep -E "\s{1}linkto\[$platform\]:")

    if [[ $linkString = "" ]]; then
        linkString=$(head -$numOfLines $file | grep -E "\s{1}linkto:")
    fi

    if [[ $linkString ]]; then
        eval target=$(echo $linkString \
            | sed -E "s/.{1,}\s{1}linkto\[{0,1}.{0,}\]{0,1}:\s//")

        echo $target
    fi
}

# uses a linkto file to generate link path for file
function getTargetPathFromCommon {

    # max number of levels to climb, probably not needed
    levels=10

    file=$1
    dir=$(dirname $1)

    # adds 1 to get right number of /..
    currentLevel=1

    while [[ currentLevel -ne levels ]]; do
        # Generates string that navigate back currentLevel number of levels
        navString=$dir$(seq -s/.. $currentLevel|tr -d "[:digit:]")
        path=$(realpath $navString)

        if [[ $(find $path -maxdepth 1 -type f -name $(basename $0)) ]]; then
            break
        fi
    
	# If there is a file called nolink stop looking for a link for this file
	nolinkFile=$(find $path -maxdepth 1 -type f -name "nolink")
	if [[ $nolinkFile ]]; then
		print "a"
		break
	fi

        linktoFile=$(find $path -maxdepth 1 -type f -name "linkto")

        if [[ $linktoFile ]]; then
            baseDir=$(dirname $linktoFile)
            commonTarget=$(getTargetPath $linktoFile)

            echo "${file/$baseDir/$commonTarget}"
            break
        fi

        currentLevel=$(($currentLevel+1))
    done
}

function linkFile {

	file=$1
	linkTarget=$2
	
        if [[ ! $linkTarget ]]; then
            linkTarget=$(getTargetPathFromCommon $file)
            echo $linkTarget
        fi

		if [[ ! $linkTarget ]]; then
			echo "$file->???"
			printf "\tSkipping file, no link for selected platform!\n"

		else

            printf "$file->$linkTarget\n"
		    if [[ $(readlink $linkTarget) = $file ]]; then
			      printf "\tFile is already linked. Remove link? (y/N)"
			      read removeLink
			      if [[ $removeLink = "y" ]]; then
				        rm $linkTarget
				        if [[ -f $linkTarget ]]; then
					          printf "\tFailed to remove symlink...Exiting\n"
					          exit 1
				        fi
			      fi

		    elif [[ -f $linkTarget ]] || [[ -L $linkTarget ]]; then
			      printf "\tOther file/link already present at TARGET path.\n"
			      replaceAndLink=""
			      while [[ $replaceAndLink != "y" ]] \
				              && [[ $replaceAndLink != "n" ]]; do
				        printf "\t\tReplace and link? (y/n/b)"
				        read replaceAndLink
			      done

			      if [[ $replaceAndLink = "y" ]]; then
				      	sudo rm $linkTarget".tmpbackup"
				        sudo mv $linkTarget $linkTarget".tmpbackup"
				        if [[ -f $linkTarget ]]; then
					          printf "\t\tCouldnt move/remove TARGET file...Exiting\n"
					          exit 1
				        fi

                			sudo mkdir --parents $(dirname $linkTarget)
				        sudo ln -s $file $linkTarget

				        if [[ $(readlink $linkTarget) = $file ]] && [[ $replaceAndLink != "b" ]]; then
					          sudo rm $linkTarget".tmpbackup"
				        else
					          printf "\t\tCouldnt link files\n"
					          printf "\t\tRestoring old file and exiting\n"

					          sudo mv $linkTarget".tmpbackup" $linkTarget

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
                mkdir --parents $(dirname $linkTarget)
				        sudo ln -s $file $linkTarget

				        if [[ $(readlink $linkTarget) = $file ]]; then
					          printf "File linked!\n"
				        else
					          printf "Failed to link file... exiting\n"
					          exit 1
				        fi
			      fi
		    fi
	  fi
}


while [[ $platform != "desktop" ]] && [[ $platform != "laptop" ]]; do
	printf "Select platform: (desktop/laptop) "
	read platform
done


#If a argument is passed, just run autolinker for that file and exit
if [[ $1 ]]; then
	
	#use readlink to get absolute path of file
	file=$(readlink -f $1)
	linkTarget=$(getTargetPath $file)

	linkFile $file $linkTarget	

	exit 0
fi


for file in $(find $PWD -type f \
    ! -name "*.swp" \
    ! -name "*#" \
    ! -name "linkto" \
    ! -path "*.git*" \
    ! -path "*configfiles/auto-setups*"); do

    # basename $0 checks if the file is itself
	if [[ $file != *$(basename $0) ]] && [[ $(head -$numOfLines $file | grep -E "\s{1}nolink") = "" ]]; then

        linkTarget=$(getTargetPath $file)

	linkFile $file $linkTarget


	fi
done

exit 0

